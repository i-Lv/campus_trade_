package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.CategoryQueryDto;
import cn.kmbeast.pojo.dto.query.extend.MessageQueryDto;
import cn.kmbeast.pojo.entity.Category;
import cn.kmbeast.pojo.entity.Message;
import cn.kmbeast.pojo.vo.MessageVO;

import java.util.List;

/**
 * 消息的业务逻辑接口
 */
public interface MessageService {

    Result<String> save(Message message);

    Result<String> setRead(Integer userId);

    Result<String> batchDelete(List<Integer> ids);

    Result<List<MessageVO>> query(MessageQueryDto messageQueryDto);

}
