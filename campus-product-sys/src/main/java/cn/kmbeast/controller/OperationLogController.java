package cn.kmbeast.controller;

import cn.kmbeast.aop.Pager;
import cn.kmbeast.aop.Protector;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.OperationLogQueryDto;
import cn.kmbeast.pojo.vo.OperationLogVO;
import cn.kmbeast.service.OperationLogService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 操作日志控制器
 */
@RestController
@RequestMapping("/operation-log")
public class OperationLogController {

    @Resource
    private OperationLogService operationLogService;

    /**
     * 批量删除
     */
    @Protector(role = "管理员")
    @PostMapping(value = "/batchDelete")
    @ResponseBody
    public Result<String> batchDelete(@RequestBody List<Integer> ids) {
        return operationLogService.batchDelete(ids);
    }

    /**
     * 查询
     *
     * @param operationLogQueryDto 查询参数
     * @return Result<List < OperationLogVO>> 响应结果
     */
    @Pager
    @PostMapping(value = "/query")
    @ResponseBody
    public Result<List<OperationLogVO>> query(@RequestBody OperationLogQueryDto operationLogQueryDto) {
        return operationLogService.query(operationLogQueryDto);
    }
}

