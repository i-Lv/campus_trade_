package cn.kmbeast.service;

import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.pojo.dto.query.extend.ContentQueryDto;
import cn.kmbeast.pojo.dto.query.extend.ProductQueryDto;
import cn.kmbeast.pojo.dto.update.OrdersDTO;
import cn.kmbeast.pojo.entity.Content;
import cn.kmbeast.pojo.entity.Product;
import cn.kmbeast.pojo.vo.ChartVO;
import cn.kmbeast.pojo.vo.ContentVO;
import cn.kmbeast.pojo.vo.ProductVO;

import java.util.List;

/**
 * 商品的业务逻辑接口
 */
public interface ContentService {

    Result<String> save(Content content);

    Result<String> update(Content content);

    Result<String> batchDelete(List<Integer> ids);

    Result<List<ContentVO>> query(ContentQueryDto contentQueryDto);

}
