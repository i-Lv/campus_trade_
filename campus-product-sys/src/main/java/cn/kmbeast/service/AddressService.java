package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.AddressQueryDto;
import cn.kmbeast.pojo.dto.query.extend.CategoryQueryDto;
import cn.kmbeast.pojo.entity.Address;
import cn.kmbeast.pojo.entity.Category;

import java.util.List;

/**
 * 地址的业务逻辑接口
 */
public interface AddressService {

    Result<String> save(Address address);

    Result<String> update(Address address);

    Result<String> batchDelete(List<Integer> ids);

    Result<List<Address>> query(AddressQueryDto addressQueryDto);

    Result<String> isDefault(Address address);

}
