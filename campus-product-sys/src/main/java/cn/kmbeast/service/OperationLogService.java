package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.CategoryQueryDto;
import cn.kmbeast.pojo.dto.query.extend.OperationLogQueryDto;
import cn.kmbeast.pojo.entity.Category;
import cn.kmbeast.pojo.entity.OperationLog;
import cn.kmbeast.pojo.vo.OperationLogVO;

import java.util.List;

/**
 * 操作日志的业务逻辑接口
 */
public interface OperationLogService {

    Result<String> save(OperationLog operationLog);

    Result<String> batchDelete(List<Integer> ids);

    Result<List<OperationLogVO>> query(OperationLogQueryDto operationLogQueryDto);

}
