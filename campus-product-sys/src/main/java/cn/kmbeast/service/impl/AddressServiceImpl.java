package cn.kmbeast.service.impl;

import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.mapper.AddressMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.AddressQueryDto;
import cn.kmbeast.pojo.entity.Address;
import cn.kmbeast.service.AddressService;
import cn.kmbeast.utils.PhoneNumberValidator;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import javax.annotation.Resource;
import java.util.List;

/**
 * 地址业务逻辑接口实现类
 */
@Service
public class AddressServiceImpl implements AddressService {

    @Resource
    private AddressMapper addressMapper;

    /**
     * 新增
     *
     * @param address 参数
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> save(Address address) {
        if (!StringUtils.hasText(address.getConcatPerson())) {
            return ApiResult.error("收件人不能为空");
        }
        if (!StringUtils.hasText(address.getConcatPhone())) {
            return ApiResult.error("收件电话不能为空");
        }
        if (!StringUtils.hasText(address.getGetAdr())) {
            return ApiResult.error("收件地址不能为空");
        }
        // 检验手机号是否合理
        if (!PhoneNumberValidator.isValidChinesePhoneNumber(address.getConcatPhone())) {
            return ApiResult.error("收件电话不符合要求");
        }
        address.setUserId(LocalThreadHolder.getUserId());
        dealDefaultAddress(address);
        addressMapper.save(address);
        return ApiResult.success("收件地址新增成功");
    }

    /**
     * 修改
     *
     * @param address 参数
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> update(Address address) {
        if (!StringUtils.hasText(address.getConcatPerson())) {
            return ApiResult.error("收件人不能为空");
        }
        if (!StringUtils.hasText(address.getConcatPhone())) {
            return ApiResult.error("收件电话不能为空");
        }
        if (!StringUtils.hasText(address.getGetAdr())) {
            return ApiResult.error("收件地址不能为空");
        }
        // 检验手机号是否合理
        if (!PhoneNumberValidator.isValidChinesePhoneNumber(address.getConcatPhone())) {
            return ApiResult.error("收件电话不符合要求");
        }
        dealDefaultAddress(address);
        addressMapper.update(address);
        return ApiResult.success("收件地址修改成功");
    }

    private void dealDefaultAddress(Address address) {
        if (address.getIsDefault()) { // 是默认收货地址，则先去修改别的默认收货地址，因为只能有一个默认收货地址
            AddressQueryDto addressQueryDto = new AddressQueryDto();
            addressQueryDto.setIsDefault(true); // 设置为默认收货地址
            addressQueryDto.setUserId(LocalThreadHolder.getUserId()); // 设置用户ID
            List<Address> addressList = addressMapper.query(addressQueryDto);
            if (!addressList.isEmpty()) { // 有默认收货地址则处理
                Address addressSave = addressList.get(0);
                addressSave.setIsDefault(false); // 设置成非默认收货地址
                addressMapper.update(addressSave);
            }
        }
    }

    /**
     * 删除
     *
     * @param ids 待删除ID集合
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> batchDelete(List<Integer> ids) {
        addressMapper.batchDelete(ids);
        return ApiResult.success("收件地址删除成功");
    }

    /**
     * 查询
     *
     * @param addressQueryDto 查询参数
     * @return Result<List < Address>> 后台通用返回封装类
     */
    @Override
    public Result<List<Address>> query(AddressQueryDto addressQueryDto) {
        int totalCount = addressMapper.queryCount(addressQueryDto);
        List<Address> addressList = addressMapper.query(addressQueryDto);
        return ApiResult.success(addressList, totalCount);
    }

    /**
     * 设置为默认地址
     *
     * @param address 收货地址
     * @return Result<String>
     */
    @Override
    public Result<String> isDefault(Address address) {
        dealDefaultAddress(address);
        addressMapper.update(address);
        return ApiResult.success("设置为默认地址成功");
    }
}
