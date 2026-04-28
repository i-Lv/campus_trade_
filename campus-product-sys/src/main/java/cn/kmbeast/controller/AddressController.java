package cn.kmbeast.controller;

import cn.kmbeast.aop.Pager;
import cn.kmbeast.aop.Protector;
import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.AddressQueryDto;
import cn.kmbeast.pojo.entity.Address;
import cn.kmbeast.service.AddressService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 收件地址控制器
 */
@RestController
@RequestMapping("/address")
public class AddressController {

    @Resource
    private AddressService addressService;

    /**
     * 新增
     *
     * @param address 参数
     * @return Result<String> 响应结果
     */
    @PostMapping(value = "/save")
    @ResponseBody
    public Result<String> save(@RequestBody Address address) {
        return addressService.save(address);
    }

    /**
     * 修改
     *
     * @param address 参数
     * @return Result<String> 响应结果
     */
    @PutMapping(value = "/update")
    @ResponseBody
    public Result<String> update(@RequestBody Address address) {
        return addressService.update(address);
    }

    /**
     * 设置为默认地址
     *
     * @param address 参数
     * @return Result<String> 响应结果
     */
    @PutMapping(value = "/isDefault")
    @ResponseBody
    public Result<String> isDefault(@RequestBody Address address) {
        return addressService.isDefault(address);
    }

    /**
     * 批量删除
     */
    @PostMapping(value = "/batchDelete")
    @ResponseBody
    public Result<String> batchDelete(@RequestBody List<Integer> ids) {
        return addressService.batchDelete(ids);
    }

    /**
     * 查询
     *
     * @param addressQueryDto 查询参数
     * @return Result<List < Address>> 响应结果
     */
    @Pager
    @PostMapping(value = "/query")
    @ResponseBody
    public Result<List<Address>> query(@RequestBody AddressQueryDto addressQueryDto) {
        return addressService.query(addressQueryDto);
    }

    /**
     * 查询用户自己的收货地址列表
     *
     * @param addressQueryDto 查询参数
     * @return Result<List < Address>> 响应结果
     */
    @Pager
    @PostMapping(value = "/queryUser")
    @ResponseBody
    public Result<List<Address>> queryUser(@RequestBody AddressQueryDto addressQueryDto) {
        addressQueryDto.setUserId(LocalThreadHolder.getUserId());
        return addressService.query(addressQueryDto);
    }

}

