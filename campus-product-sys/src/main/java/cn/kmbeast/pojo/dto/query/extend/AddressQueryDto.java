package cn.kmbeast.pojo.dto.query.extend;

import cn.kmbeast.pojo.dto.query.base.QueryDto;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 收货地址的查询条件类
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class AddressQueryDto extends QueryDto {
    /**
     * 用户ID
     */
    private Integer userId;

    /**
     * 收件人
     */
    private String concatPerson;

    /**
     * 收货地址
     */
    private String getAdr;

    /**
     * 联系电话
     */
    private String concatPhone;
    /**
     * 是否是默认地址
     */
    private Boolean isDefault;
}
