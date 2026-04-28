package cn.kmbeast.service.impl;

import cn.kmbeast.context.LocalThreadHolder;
import cn.kmbeast.mapper.ContentMapper;
import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.ContentQueryDto;
import cn.kmbeast.pojo.entity.Content;
import cn.kmbeast.pojo.vo.ContentVO;
import cn.kmbeast.service.ContentService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 内容业务逻辑接口实现类
 */
@Service
public class ContentServiceImpl implements ContentService {

    @Resource
    private ContentMapper contentMapper;

    /**
     * 新增
     *
     * @param content 参数
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> save(Content content) {
        if (!StringUtils.hasText(content.getName())) {
            return ApiResult.error("标题不能为空");
        }
        if (!StringUtils.hasText(content.getCover())) {
            return ApiResult.error("请上传封面");
        }
        content.setUserId(LocalThreadHolder.getUserId());
        content.setCreateTime(LocalDateTime.now());
        contentMapper.save(content);
        return ApiResult.success("动态新增成功");
    }

    /**
     * 修改
     *
     * @param content 参数
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> update(Content content) {
        if (!StringUtils.hasText(content.getName())) {
            return ApiResult.error("标题不能为空");
        }
        if (!StringUtils.hasText(content.getCover())) {
            return ApiResult.error("请上传封面");
        }
        contentMapper.update(content);
        return ApiResult.success("动态修改成功");
    }

    /**
     * 删除
     *
     * @param ids 待删除ID集合
     * @return Result<String> 后台通用返回封装类
     */
    @Override
    public Result<String> batchDelete(List<Integer> ids) {
        contentMapper.batchDelete(ids);
        return ApiResult.success("动态删除成功");
    }

    /**
     * 查询
     *
     * @param contentQueryDto 查询参数
     * @return Result<List < ContentVO>> 后台通用返回封装类
     */
    @Override
    public Result<List<ContentVO>> query(ContentQueryDto contentQueryDto) {
        int totalCount = contentMapper.queryCount(contentQueryDto);
        List<ContentVO> contentVOS = contentMapper.query(contentQueryDto);
        return ApiResult.success(contentVOS, totalCount);
    }
}
