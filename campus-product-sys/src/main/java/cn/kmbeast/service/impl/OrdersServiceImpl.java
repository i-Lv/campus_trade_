package cn.kmbeast.service.impl;

import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.mapper.OrdersMapper;
import cn.kmbeast.mapper.ProductMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.OrdersQueryDto;
import cn.kmbeast.pojo.entity.Orders;
import cn.kmbeast.pojo.entity.Product;
import cn.kmbeast.pojo.vo.OrdersVO;
import cn.kmbeast.pojo.vo.ProductVO;
import cn.kmbeast.service.OrdersService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单业务逻辑接口实现类
 */
@Service
public class OrdersServiceImpl implements OrdersService {

    @Resource
    private OrdersMapper ordersMapper;
    @Resource
    private ProductMapper productMapper;
    // 交易状态
    private final static Integer AWAITING_PAY = 1; // 待支付状态
    private final static Integer OK_PAY = 2; // 已支付状态
    private final static Integer CHANNEL_PAY = 3; // 已取消状态状态
    // 退款状态
    private final static Integer REFUNDING = 1; // 无退款
    private final static Integer REPLY_REFUND = 2; // 申请退款
    private final static Integer REJECT_REFUND = 3; // 拒绝退款
    private final static Integer OK_REFUND = 4; // 已退款

    /**
     * 创建订单
     *
     * @param orders 参数
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> save(Orders orders) {
        if (orders.getProductId() == null) {
            return ApiResult.error("商品ID不能为空");
        }
        if (orders.getAddressId() == null) {
            return ApiResult.error("请选择收货地址");
        }
        if (orders.getBuyNumber() == null || orders.getBuyNumber() == 0) {
            return ApiResult.error("购买数量不能为空");
        }
        ProductVO productVO = productMapper.queryById(orders.getProductId());
        if (productVO == null) {
            return ApiResult.error("商品参数异常");
        }
        if (productVO.getInventory() - orders.getBuyNumber() < 0) {
            return ApiResult.error("商品库存不足");
        }
        createOrderInfo(productVO.getPrice(), orders);
        // 订单入库
        ordersMapper.save(orders);
        // 扣除商品库存
        Product product = new Product();
        product.setId(productVO.getId());
        product.setInventory(productVO.getInventory() - orders.getBuyNumber());
        productMapper.update(product);

        return ApiResult.success("订单创建成功，请尽快支付");
    }

    /**
     * 创建订单信息
     *
     * @param orders 订单信息
     */
    private void createOrderInfo(BigDecimal price, Orders orders) {
        orders.setBuyPrice(price); // 价格参数设置进订单中
        orders.setBuyPrice(orders.calculateTotalPrice()); // 调用方法，计算订单总价
        orders.setCode(String.valueOf(System.currentTimeMillis())); // 当前时间戳作为订单号
        orders.setUserId(LocalThreadHolder.getUserId()); // 设置用户ID，标识谁人下单
        orders.setTradeStatus(AWAITING_PAY); // 订单设置为未付款状态
        orders.setRefundStatus(REFUNDING); // 订单退款状态设置为未退款
        orders.setCreateTime(LocalDateTime.now()); // 设置订单创建时间
    }

    /**
     * 修改
     *
     * @param orders 参数
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> update(Orders orders) {
        ordersMapper.update(orders);
        // 订单确定退款
        if (orders.getRefundStatus() != null && orders.getRefundStatus() == 4) {
            orders.setRefundTime(LocalDateTime.now());
            orders.setIsRefundConfirm(true);
            ordersMapper.update(orders);
        }
        // 订单取消，库存恢复
        if (orders.getTradeStatus() != null && orders.getTradeStatus() == 3) {
            inventoryRestore(orders.getId());
        }
        return ApiResult.success("订单修改成功");
    }

    /**
     * 删除
     *
     * @param ids 待删除ID集合
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> batchDelete(List<Integer> ids) {
        ordersMapper.batchDelete(ids);
        return ApiResult.success("订单删除成功");
    }

    private void inventoryRestore(Integer id) {
        OrdersQueryDto queryDto = new OrdersQueryDto();
        queryDto.setId(id);
        List<OrdersVO> ordersVOS = ordersMapper.query(queryDto);
        if (!ordersVOS.isEmpty()) {
            OrdersVO ordersVO = ordersVOS.get(0);
            Integer buyNumber = ordersVO.getBuyNumber();
            Integer productId = ordersVO.getProductId();
            ProductVO productVO = productMapper.queryById(productId);
            if (productVO != null) {
                Product product = new Product();
                product.setId(productVO.getId());
                product.setInventory(productVO.getInventory() + buyNumber);
                productMapper.update(product);
            }
        }
    }

    /**
     * 查询
     *
     * @param ordersQueryDto 查询参数
     * @return Result<List < OrdersVO>> 后台通用返回封装类
     */
    @Override
    public Result<List<OrdersVO>> query(OrdersQueryDto ordersQueryDto) {
        int totalCount = ordersMapper.queryCount(ordersQueryDto);
        List<OrdersVO> ordersVOList = ordersMapper.query(ordersQueryDto);
        return ApiResult.success(ordersVOList, totalCount);
    }

    /**
     * 查询用户发布的商品产生的订单数据
     *
     * @param ordersQueryDto 查询参数
     * @return Result<List < OrdersVO>> 响应结果
     */
    @Override
    public Result<List<OrdersVO>> queryOrdersList(OrdersQueryDto ordersQueryDto) {
        List<Integer> productIds = productMapper.queryProductIds(LocalThreadHolder.getUserId());
        if (productIds.isEmpty()) {
            return ApiResult.success(new ArrayList<>());
        }
        ordersQueryDto.setProductIds(productIds);
        List<OrdersVO> ordersVOList = ordersMapper.queryByProductIds(ordersQueryDto);
        return ApiResult.success(ordersVOList);
    }

    /**
     * 订单确定退款
     *
     * @param ordersId 订单ID
     * @return Result<String> 响应结果
     */
    @Override
    public Result<String> returnMoney(Integer ordersId) {
        Orders orders = new Orders();
        orders.setId(ordersId);
        orders.setRefundStatus(OK_REFUND); // 已退款状态
        orders.setIsRefundConfirm(true);
        orders.setRefundTime(LocalDateTime.now());
        ordersMapper.update(orders);
        return ApiResult.success("退款成功");
    }
}
