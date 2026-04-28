package cn.kmbeast.pojo.dto.query.extend;

import cn.kmbeast.pojo.dto.query.base.QueryDto;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 消息的查询条件Dto类
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class MessageQueryDto extends QueryDto {
    /**
     * 用户ID
     */
    private Integer userId;
    /**
     * 消息体
     */
    private String content;
}
