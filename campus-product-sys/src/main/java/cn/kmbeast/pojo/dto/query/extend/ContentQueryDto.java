package cn.kmbeast.pojo.dto.query.extend;

import cn.kmbeast.pojo.dto.query.base.QueryDto;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 内容的查询条件类
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class ContentQueryDto extends QueryDto {
    /**
     * 标题
     */
    private String name;
    /**
     * 用户ID
     */
    private Integer userId;
}
