package cn.kmbeast.pojo.vo;

import cn.kmbeast.pojo.entity.OperationLog;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 操作日志出参类
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class OperationLogVO extends OperationLog {
    /**
     * 用户名
     */
    private String userName;
    /**
     * 用户账号
     */
    private String userAccount;
}
