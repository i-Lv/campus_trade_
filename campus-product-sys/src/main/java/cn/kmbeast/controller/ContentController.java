package cn.kmbeast.controller;

import cn.kmbeast.aop.Pager;
import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.ContentQueryDto;
import cn.kmbeast.pojo.entity.Content;
import cn.kmbeast.pojo.vo.ContentVO;
import cn.kmbeast.service.ContentService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 动态控制器
 */
@RestController
@RequestMapping("/content")
public class ContentController {

    @Resource
    private ContentService contentService;

    /**
     * 新增
     *
     * @param content 参数
     * @return Result<String> 响应结果
     */
    @PostMapping(value = "/save")
    @ResponseBody
    public Result<String> save(@RequestBody Content content) {
        return contentService.save(content);
    }

    /**
     * 修改
     *
     * @param content 参数
     * @return Result<String> 响应结果
     */
    @PutMapping(value = "/update")
    @ResponseBody
    public Result<String> update(@RequestBody Content content) {
        return contentService.update(content);
    }

    /**
     * 删除
     */
    @PostMapping(value = "/batchDelete")
    @ResponseBody
    public Result<String> batchDelete(@RequestBody List<Integer> ids) {
        return contentService.batchDelete(ids);
    }

    /**
     * 查询
     *
     * @param contentQueryDto 查询参数
     * @return Result<List < ContentVO>> 响应结果
     */
    @Pager
    @PostMapping(value = "/queryUser")
    @ResponseBody
    public Result<List<ContentVO>> queryUser(@RequestBody ContentQueryDto contentQueryDto) {
        contentQueryDto.setUserId(LocalThreadHolder.getUserId());
        return contentService.query(contentQueryDto);
    }

    /**
     * 查询
     *
     * @param contentQueryDto 查询参数
     * @return Result<List < ContentVO>> 响应结果
     */
    @Pager
    @PostMapping(value = "/query")
    @ResponseBody
    public Result<List<ContentVO>> query(@RequestBody ContentQueryDto contentQueryDto) {
        return contentService.query(contentQueryDto);
    }
}

