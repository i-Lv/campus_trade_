package cn.kmbeast.service.impl;

import cn.kmbeast.mapper.MessageMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.MessageQueryDto;
import cn.kmbeast.pojo.entity.Message;
import cn.kmbeast.pojo.vo.MessageVO;
import cn.kmbeast.service.MessageService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 消息业务逻辑接口实现类
 */
@Service
public class MessageServiceImpl implements MessageService {

    @Resource
    private MessageMapper messageMapper;

    /**
     * 新增
     *
     * @param message 参数
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> save(Message message) {
        messageMapper.save(message);
        return ApiResult.success("消息新增成功");
    }

    /**
     * 消息设置未已读
     *
     * @param userId 用户ID
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> setRead(Integer userId) {
        messageMapper.setRead(userId);
        return ApiResult.success("消息已读");
    }

    /**
     * 删除
     *
     * @param ids 待删除ID集合
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> batchDelete(List<Integer> ids) {
        messageMapper.batchDelete(ids);
        return ApiResult.success("消息删除成功");
    }

    /**
     * 查询
     *
     * @param messageQueryDto 查询参数
     * @return Result<List < MessageVO>> 后台通用返回封装类
     */
    @Override
    public Result<List<MessageVO>> query(MessageQueryDto messageQueryDto) {
        int totalCount = messageMapper.queryCount(messageQueryDto);
        List<MessageVO> messageVOList = messageMapper.query(messageQueryDto);
        return ApiResult.success(messageVOList, totalCount);
    }
}
