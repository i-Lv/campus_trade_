package cn.kmbeast.pojo.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 内容实体
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Content {
    /**
     * ID
     */
    private Integer id;
    /**
     * 标题
     */
    private String name;
    /**
     * 内容
     */
    private String detail;
    /**
     * 封面
     */
    private String cover;
    /**
     * 用户ID
     */
    private Integer userId;
    /**
     * 创建时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
