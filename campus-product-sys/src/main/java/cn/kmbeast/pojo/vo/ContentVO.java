package cn.kmbeast.pojo.vo;

import cn.kmbeast.pojo.entity.Content;
import cn.kmbeast.pojo.entity.Product;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 内容的出参VO类
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class ContentVO extends Content {
    /**
     * 用户名
     */
    private String userName;
    /**
     * 用户头像
     */
    private String userAvatar;
}
