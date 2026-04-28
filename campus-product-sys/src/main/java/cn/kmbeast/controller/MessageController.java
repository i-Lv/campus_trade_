package cn.kmbeast.controller;

import cn.kmbeast.aop.Pager;
import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.MessageQueryDto;
import cn.kmbeast.pojo.vo.MessageVO;
import cn.kmbeast.service.MessageService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 消息控制器
 */
@RestController
@RequestMapping("/message")
public class MessageController {

    @Resource
    private MessageService messageService;

    /**
     * 批量删除
     */
    @PostMapping(value = "/batchDelete")
    @ResponseBody
    public Result<String> batchDelete(@RequestBody List<Integer> ids) {
        return messageService.batchDelete(ids);
    }

    /**
     * 消息设为已读
     */
    @PostMapping(value = "/setRead")
    @ResponseBody
    public Result<String> setRead() {
        return messageService.setRead(LocalThreadHolder.getUserId());
    }

    /**
     * 查询
     *
     * @param messageQueryDto 查询参数
     * @return Result<List < MessageVO>> 响应结果
     */
    @Pager
    @PostMapping(value = "/query")
    @ResponseBody
    public Result<List<MessageVO>> query(@RequestBody MessageQueryDto messageQueryDto) {
        return messageService.query(messageQueryDto);
    }

    /**
     * 查询用户自己需要接收的消息数据
     *
     * @param messageQueryDto 查询参数
     * @return Result<List < MessageVO>> 响应结果
     */
    @PostMapping(value = "/queryUser")
    @ResponseBody
    public Result<List<MessageVO>> queryUser(@RequestBody MessageQueryDto messageQueryDto) {
        messageQueryDto.setUserId(LocalThreadHolder.getUserId());
        return messageService.query(messageQueryDto);
    }

}

