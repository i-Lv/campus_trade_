package cn.kmbeast.mapper;

import cn.kmbeast.pojo.dto.query.extend.AddressQueryDto;
import cn.kmbeast.pojo.dto.query.extend.CategoryQueryDto;
import cn.kmbeast.pojo.entity.Address;
import cn.kmbeast.pojo.entity.Category;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 地址持久化接口
 */
public interface AddressMapper {

    /**
     * 新增
     *
     * @param address 实体信息
     * @return int 受影响行数
     */
    int save(Address address);

    /**
     * 分页查询商品类别信息
     *
     * @param addressQueryDto 分页查询参数
     * @return List<Address>
     */
    List<Address> query(AddressQueryDto addressQueryDto);

    /**
     * 查询满足分页查询的记录总数
     *
     * @param addressQueryDto 分页查询参数
     * @return int 数据总数
     */
    int queryCount(AddressQueryDto addressQueryDto);

    /**
     * 修改
     *
     * @param address 商品类别信息
     * @return int 受影响行数
     */
    int update(Address address);

    /**
     * 批量删除信息
     *
     * @param ids ID集合
     */
    void batchDelete(@Param(value = "ids") List<Integer> ids);

}
