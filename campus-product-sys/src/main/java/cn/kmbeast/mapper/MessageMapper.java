package cn.kmbeast.mapper;

import cn.kmbeast.pojo.dto.query.extend.MessageQueryDto;
import cn.kmbeast.pojo.entity.Message;
import cn.kmbeast.pojo.vo.MessageVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 消息持久化接口
 */
public interface MessageMapper {

    /**
     * 新增
     *
     * @param message 实体信息
     * @return int 受影响行数
     */
    int save(Message message);

    /**
     * 消息设置为已读
     *
     * @param userId 用户ID
     * @return int 受影响行数
     */
    int setRead(@Param(value = "userId") Integer userId);

    /**
     * 分页查询消息信息
     *
     * @param messageQueryDto 分页查询参数
     * @return List<MessageVO>
     */
    List<MessageVO> query(MessageQueryDto messageQueryDto);

    /**
     * 查询满足分页查询的记录总数
     *
     * @param messageQueryDto 分页查询参数
     * @return int 数据总数
     */
    int queryCount(MessageQueryDto messageQueryDto);

    /**
     * 批量删除用户信息
     *
     * @param ids 用户ID集合
     */
    void batchDelete(@Param(value = "ids") List<Integer> ids);

}
