package cn.kmbeast.pojo.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;

/**
 * 订单实体
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Orders {
    /**
     * ID
     */
    private Integer id;
    /**
     * 订单号
     */
    private String code;
    /**
     * 备注
     */
    private String detail;
    /**
     * 用户ID
     */
    private Integer userId;
    /**
     * 商品ID
     */
    private Integer productId;
    /**
     * 购买时价格
     */
    private BigDecimal buyPrice;
    /**
     * 购买数量
     */
    private Integer buyNumber;
    /**
     * 交易状态（1：待支付；2：已支付；3：已取消）
     */
    private Integer tradeStatus;
    /**
     * 退款状态（1: 无退款；2：申请退款；3：拒绝退款；4：已退款）
     */
    private Integer refundStatus;
    /**
     * 退款时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime refundTime;
    /**
     * 交易时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime tradeTime;
    /**
     * 退款是否已经确认(卖家进行的确认)
     */
    private Boolean isRefundConfirm;
    /**
     * 创建时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    /**
     * 收货地址ID
     */
    private Integer addressId;
    /**
     * 是否已确认收货（0：未确认；1：已确认）
     */
    private Boolean isConfirm;
    /**
     * 确认收货时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime isConfirmTime;

    // 以下是发货相关参数
    /**
     * 是否已发货（0：未发货；1：已发货）
     */
    private Boolean isDeliver;
    /**
     * 发货地址ID
     */
    private Integer deliverAdrId;
    /**
     * 发货时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime deliverTime;


    /**
     * 计算订单总价（购买数量 × 单价）
     * @return 总价（BigDecimal类型，保留2位小数）
     */
    public BigDecimal calculateTotalPrice() {
        if (buyPrice == null || buyNumber == null) {
            return BigDecimal.ZERO;
        }
        return buyPrice.multiply(BigDecimal.valueOf(buyNumber))
                .setScale(2, RoundingMode.HALF_UP); // 四舍五入保留2位小数
    }

}
