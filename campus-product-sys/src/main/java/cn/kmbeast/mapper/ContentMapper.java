package cn.kmbeast.mapper;

import cn.kmbeast.pojo.dto.query.extend.ContentQueryDto;
import cn.kmbeast.pojo.dto.query.extend.ProductQueryDto;
import cn.kmbeast.pojo.entity.Content;
import cn.kmbeast.pojo.entity.Product;
import cn.kmbeast.pojo.vo.ContentVO;
import cn.kmbeast.pojo.vo.ProductVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 内容持久化接口
 */
public interface ContentMapper {

    int save(Content content);

    List<ContentVO> query(ContentQueryDto contentQueryDto);

    int queryCount(ContentQueryDto contentQueryDto);

    int update(Content content);

    void batchDelete(@Param(value = "ids") List<Integer> ids);

}
