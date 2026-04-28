package cn.kmbeast.controller;

import cn.kmbeast.pojo.api.ApiResult;
import cn.kmbeast.pojo.api.Result;
import cn.kmbeast.utils.RedisUtil;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

/**
 * Redis 测试控制器
 * 用于验证 Redis 连接是否正常工作
 */
@RestController
@RequestMapping(value = "/redis-test")
public class RedisTestController {

    private static final String TEST_KEY = "redis:test:ping";
    private static final String TEST_VALUE = "pong";
    private static final long TEST_TTL = 10; // 10秒过期

    @Resource
    private RedisUtil redisUtil;

    /**
     * Redis 连接测试
     * GET /api/campus-product-sys/v1.0/redis-test/ping
     * 
     * 返回说明:
     * - code=200: Redis连接正常
     * - code=500: Redis连接失败
     * 
     * 成功示例:
     * {"code": 200, "msg": "Redis连接成功"}
     * 
     * 失败示例:
     * {"code": 500, "msg": "Redis连接失败: 连接被拒绝"}
     */
    @GetMapping(value = "/ping")
    @ResponseBody
    public Result<String> ping() {
        try {
            // 1. 写入测试数据
            redisUtil.set(TEST_KEY, TEST_VALUE, TEST_TTL);
            
            // 2. 读取测试数据
            Object value = redisUtil.get(TEST_KEY);
            boolean readSuccess = TEST_VALUE.equals(value);
            
            // 3. 检查key是否存在
            boolean exists = redisUtil.hasKey(TEST_KEY);
            
            // 4. 删除测试数据
            redisUtil.delete(TEST_KEY);
            
            // 5. 验证删除
            boolean deleted = !redisUtil.hasKey(TEST_KEY);
            
            // 判断是否全部通过
            if (readSuccess && exists && deleted) {
                return ApiResult.success("Redis连接成功");
            } else {
                return ApiResult.error("Redis部分操作失败: read=" + readSuccess 
                    + ", exists=" + exists + ", verifyDelete=" + deleted);
            }
        } catch (Exception e) {
            return ApiResult.error("Redis连接失败: " + e.getMessage());
        }
    }

    /**
     * 获取 Redis 配置信息
     * GET /api/campus-product-sys/v1.0/redis-test/config
     */
    @GetMapping(value = "/config")
    @ResponseBody
    public Result<String> getConfig() {
        return ApiResult.success("host=localhost, port=6379, database=0, timeout=3000ms");
    }
}
