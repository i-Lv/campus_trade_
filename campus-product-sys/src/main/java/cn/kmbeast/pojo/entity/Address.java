package cn.kmbeast.pojo.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 地址信息实体类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Address {
    /**
     * 主键ID
     */
    private Integer id;

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
     * 0-非默认 1-默认
     */
    private Boolean isDefault;
}
