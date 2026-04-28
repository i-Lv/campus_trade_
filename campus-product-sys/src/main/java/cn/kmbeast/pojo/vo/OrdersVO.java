package cn.kmbeast.pojo.vo;

import cn.kmbeast.pojo.entity.Orders;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 订单的出参类VO
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class OrdersVO extends Orders {
    /**
     * 用户名
     */
    private String userName;
    /**
     * 用户头像
     */
    private String userAvatar;
    /**
     * 商品标题
     */
    private String productTitle;
    /**
     * 商品图
     */
    private String productCover;

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

    private String adrName;

    private String adrPhone;

    private String adr;

}
