package cn.kmbeast.pojo.vo;

import lombok.Data;

/**
 * 商品发货信息参数Dto
 */
@Data
public class OrdersDeliverDto {
    /**
     * 订单ID
     */
    private Integer ordersId;
    /**
     * 商家发货地址ID
     */
    private Integer deliverAdrId;
}
