/*
 Navicat Premium Dump SQL

 Source Server         : local_dev_01
 Source Server Type    : MySQL
 Source Server Version : 50743 (5.7.43-log)
 Source Host           : localhost:3306
 Source Schema         : campus-2

 Target Server Type    : MySQL
 Target Server Version : 50743 (5.7.43-log)
 File Encoding         : 65001

 Date: 09/09/2025 13:58:24
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `concat_person` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '收件人',
  `get_adr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '收货地址',
  `concat_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '联系电话',
  `is_default` tinyint(255) NULL DEFAULT NULL COMMENT '是否是默认地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, 2, '陈大力', '北京市海淀区中关村南大街5号院1号楼3单元502室', '14354652312', 1);
INSERT INTO `address` VALUES (2, 2, '刘珍珍', '北京市海淀区中关村南大街5号院1号楼3单元502室', '14560607123', 0);
INSERT INTO `address` VALUES (5, 8, '张三丰', '栗子街道230', '15647633013', 1);
INSERT INTO `address` VALUES (6, 12, '测试12', '栗子街道111号', '13465673013', 1);
INSERT INTO `address` VALUES (7, 16, '小李', '广东省广州市', '13123224343', 1);
INSERT INTO `address` VALUES (8, 17, '张三', '广东省珠海市中南街道12仓库', '14523231000', 1);
INSERT INTO `address` VALUES (9, 17, '张三', '广东省广州市中南街道12仓库', '13454542424', 0);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品类别ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '类别名',
  `is_use` tinyint(1) NULL DEFAULT NULL COMMENT '是否启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品类别表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '手机', 1);
INSERT INTO `category` VALUES (2, '衣服', 1);
INSERT INTO `category` VALUES (5, '书籍', 0);
INSERT INTO `category` VALUES (6, '手表', 1);
INSERT INTO `category` VALUES (7, '零食', 1);

-- ----------------------------
-- Table structure for content
-- ----------------------------
DROP TABLE IF EXISTS `content`;
CREATE TABLE `content`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '标题',
  `detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '内容',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '封面',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of content
-- ----------------------------
INSERT INTO `content` VALUES (1, 2, '夏日清凉特辑 | 便携小风扇限时秒杀​', '<p style=\"text-align: start;\">炎炎夏日，随身清凉必备！【冰爽系列】迷你手持风扇全新上市，三档风力调节，USB充电续航12小时，重量仅200g，随身携带无压力。本周限时特惠89元起（原价129元），前50名下单赠送防尘收纳袋！同步上架的还有桌面静音款，宿舍办公两相宜，评论区晒单抽3人免单。点击领取10元新人券，满199减30专区同步开启，夏日消暑装备一站购齐！</p><p style=\"text-align: start;\"><em>小贴士：搭配购买冰凉坐垫+小风扇套餐立省40元，学生党专属福利码「COOL2023」额外享9折～</em></p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=7a60541Snipaste_2025-04-21_16-57-23.png', '2025-05-10 15:26:29');
INSERT INTO `content` VALUES (2, 7, '厨房神器上新 | 智能空气炸锅预售开启​', '<p style=\"text-align: start;\">【厨神Pro】第三代可视化空气炸锅开启预售！360°热风循环+5L大容量，手机APP控制200+云菜谱，7.5英寸触屏显示实时烹饪进度。早鸟价直降200元，预付50元抵150元，8月15日发货即赠烘焙大礼包（含油纸/模具/食谱）。老用户回购凭订单号额外领取硅胶夹套装，晒视频测评赢千元厨房改造基金！</p><p style=\"text-align: start;\"><em>技术亮点：双螺旋加热管受热更均匀，噪音降低至40dB，薯条鸡翅外酥里嫩不翻车～</em></p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=7703accSnipaste_2025-04-21_16-58-10.png', '2025-05-10 15:26:51');
INSERT INTO `content` VALUES (3, 7, '家居焕新 | 智能感应垃圾桶促销​', '<p style=\"text-align: start;\">【净享家】挥手感应垃圾桶直降百元！12L大容量自动打包换袋，IPX6级防水浴室可用，充一次电续航60天。今日爆款价159元（原价259），白/粉/黑三色可选，买二件再打9折适合全家配置。叠加家居品类满300减50活动，搭配推荐智能香薰机组合省更多！</p><p style=\"text-align: start;\"><em>用户好评：\"再也不用碰脏垃圾盖\"、\"宠物无法打翻\"，直播间1元秒杀替换袋套装进行中...</em></p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=0cb29bbSnipaste_2025-04-21_16-57-46.png', '2025-05-10 15:27:23');
INSERT INTO `content` VALUES (4, 8, '数码潮电 | 联名款蓝牙耳机首发111', '<p style=\"text-align: start;\">【音浪×故宫】国风限定TWS耳机明日开售！青花瓷纹样充电仓+宫廷雅乐专属音效，主动降噪+30小时续航，首发价299元（限量1000套）。前100名下单赠故宫文创书签，1元预约抽10人免单！同系列手机壳/支架套装立减80元，晒单带话题#听见故宫#再抽万元数码大奖。</p><p style=\"text-align: start;\"><em>功能亮点：通透模式可听环境音，游戏模式延迟低至60ms，支持无线充电～<br></em></p><p style=\"text-align: start;\">【音浪×故宫】国风限定TWS耳机明日开售！青花瓷纹样充电仓+宫廷雅乐专属音效，主动降噪+30小时续航，首发价299元（限量1000套）。前100名下单赠故宫文创书签，1元预约抽10人免单！同系列手机壳/支架套装立减80元，晒单带话题#听见故宫#再抽万元数码大奖。</p><p style=\"text-align: start;\"><em>功能亮点：通透模式可听环境音，游戏模式延迟低至60ms，支持无线充电～<br></em></p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=adf7b1bSnipaste_2025-04-21_16-57-58.png', '2025-05-10 15:27:37');
INSERT INTO `content` VALUES (5, 9, '户外露营季 | 全自动帐篷闪购专场​', '<p style=\"text-align: start;\">【探险者】黑科技一键开合帐篷3秒速开！防暴雨级面料+全铝支架，侧边拓展天幕设计，买即送防潮垫+收纳包。今日10点/20点两场闪购价458元（日常价699），库存仅300顶！同步推荐折叠桌椅套装，满999减150叠加平台券更划算。评论区留言「最想露营的地点」抽3套免费装备，资深驴友直播演示搭建技巧中→</p><p style=\"text-align: start;\"><em>用户实测：上周暴雨中保持内部干燥，自重仅3.2kg女生也能轻松背负！</em></p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=3826442Snipaste_2025-04-21_16-57-58.png', '2025-05-10 15:30:46');

-- ----------------------------
-- Table structure for evaluations
-- ----------------------------
DROP TABLE IF EXISTS `evaluations`;
CREATE TABLE `evaluations`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '父级评论ID',
  `commenter_id` int(11) NULL DEFAULT NULL COMMENT '评论者ID',
  `replier_id` int(11) NULL DEFAULT NULL COMMENT '回复者ID',
  `content_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '内容类型',
  `content_id` int(11) NULL DEFAULT NULL COMMENT '内容ID',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '评论内容',
  `create_time` datetime NULL DEFAULT NULL COMMENT '评论时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of evaluations
-- ----------------------------
INSERT INTO `evaluations` VALUES (5, NULL, 2, NULL, 'PRODUCT', 20, '5435345', '2025-06-03 18:45:37');
INSERT INTO `evaluations` VALUES (6, NULL, 2, NULL, 'PRODUCT', 20, '432423432', '2025-06-03 18:45:41');
INSERT INTO `evaluations` VALUES (7, NULL, 2, NULL, 'PRODUCT', 1, '测试', '2025-06-03 18:45:50');
INSERT INTO `evaluations` VALUES (8, NULL, 2, NULL, 'CONTENT_TYPE', 5, '日10点/20点两场闪购价458元（日', '2025-06-25 21:12:47');

-- ----------------------------
-- Table structure for evaluations_upvote
-- ----------------------------
DROP TABLE IF EXISTS `evaluations_upvote`;
CREATE TABLE `evaluations_upvote`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '评论点赞表ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `evaluations_id` int(11) NULL DEFAULT NULL COMMENT '点赞ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of evaluations_upvote
-- ----------------------------
INSERT INTO `evaluations_upvote` VALUES (55, 2, 5);
INSERT INTO `evaluations_upvote` VALUES (56, 2, 7);
INSERT INTO `evaluations_upvote` VALUES (57, 8, 5);
INSERT INTO `evaluations_upvote` VALUES (58, 8, 6);
INSERT INTO `evaluations_upvote` VALUES (59, 2, 6);
INSERT INTO `evaluations_upvote` VALUES (60, 2, 8);
INSERT INTO `evaluations_upvote` VALUES (61, 2, 9);

-- ----------------------------
-- Table structure for interaction
-- ----------------------------
DROP TABLE IF EXISTS `interaction`;
CREATE TABLE `interaction`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '互动行为主键ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '商品ID',
  `type` int(2) NULL DEFAULT NULL COMMENT '行为类型（1：收藏；2：浏览；3： 想要）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '行为互动时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '互动行为信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of interaction
-- ----------------------------
INSERT INTO `interaction` VALUES (18, 2, 6, 1, '2024-12-20 14:28:01');
INSERT INTO `interaction` VALUES (19, 1, 20, 2, '2024-12-21 20:17:54');
INSERT INTO `interaction` VALUES (22, 1, 16, 2, '2024-12-22 10:54:52');
INSERT INTO `interaction` VALUES (23, 1, 19, 2, '2024-12-22 10:55:45');
INSERT INTO `interaction` VALUES (25, 2, 18, 1, '2024-12-22 12:25:09');
INSERT INTO `interaction` VALUES (31, 21, 20, 2, '2025-05-10 17:17:12');
INSERT INTO `interaction` VALUES (33, 2, 12, 3, '2025-06-02 14:23:45');
INSERT INTO `interaction` VALUES (37, 8, 20, 2, '2025-06-02 15:34:22');
INSERT INTO `interaction` VALUES (38, 8, 1, 2, '2025-06-02 15:45:09');
INSERT INTO `interaction` VALUES (40, 8, 17, 2, '2025-06-02 15:45:15');
INSERT INTO `interaction` VALUES (41, 8, 21, 2, '2025-06-02 17:37:08');
INSERT INTO `interaction` VALUES (42, 12, 21, 2, '2025-06-02 17:37:20');
INSERT INTO `interaction` VALUES (47, 9, 21, 2, '2025-06-25 20:56:09');
INSERT INTO `interaction` VALUES (48, 9, 21, 1, '2025-06-25 20:56:10');
INSERT INTO `interaction` VALUES (49, 1, 21, 2, '2025-06-25 21:01:02');
INSERT INTO `interaction` VALUES (50, 2, 20, 1, '2025-06-25 21:07:11');
INSERT INTO `interaction` VALUES (51, 2, 1, 3, '2025-06-25 21:07:52');
INSERT INTO `interaction` VALUES (54, 2, 20, 2, '2025-06-25 21:12:18');
INSERT INTO `interaction` VALUES (55, 2, 21, 2, '2025-06-25 21:13:37');
INSERT INTO `interaction` VALUES (56, 17, 23, 2, '2025-09-08 19:56:48');
INSERT INTO `interaction` VALUES (57, 16, 23, 2, '2025-09-08 19:57:04');
INSERT INTO `interaction` VALUES (58, 16, 21, 2, '2025-09-09 13:49:16');

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '消息表主键ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '接收者用户ID',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '消息体',
  `is_read` tinyint(1) NULL DEFAULT NULL COMMENT '是否已经阅读',
  `create_time` datetime NULL DEFAULT NULL COMMENT '发送时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '消息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of message
-- ----------------------------
INSERT INTO `message` VALUES (2, 12, '用户【B站【程序员辰星】原创出品】对你的【vivoX100】感兴趣!', 0, '2024-12-20 14:18:08');
INSERT INTO `message` VALUES (3, 12, '用户【B站【程序员辰星】原创出品】对你的【vivoX100】感兴趣!', 0, '2024-12-20 14:18:52');
INSERT INTO `message` VALUES (4, 12, '用户【B站【程序员辰星】原创出品】对你的【vivoX100】感兴趣!', 0, '2024-12-20 14:19:40');
INSERT INTO `message` VALUES (5, 10, '用户【张三】对你的【测试12】感兴趣!', 0, '2025-06-02 14:23:45');
INSERT INTO `message` VALUES (6, 12, '用户【B站【程序员辰星】原创出品】对你的【vivoX100】感兴趣!', 0, '2025-06-25 21:07:52');

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '行为日志主键ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '描述',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 93 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (2, 2, '商品申请退款', '2024-12-21 15:02:11');
INSERT INTO `operation_log` VALUES (3, 2, '商品上架', '2024-12-21 17:33:16');
INSERT INTO `operation_log` VALUES (4, 2, '商品上架', '2024-12-21 17:33:22');
INSERT INTO `operation_log` VALUES (5, 2, '商品上架', '2024-12-21 17:33:25');
INSERT INTO `operation_log` VALUES (6, 2, '商品上架', '2024-12-21 17:33:29');
INSERT INTO `operation_log` VALUES (7, 2, '商品上架', '2024-12-21 17:33:32');
INSERT INTO `operation_log` VALUES (8, 2, '商品上架', '2024-12-21 17:33:34');
INSERT INTO `operation_log` VALUES (9, 2, '商品上架', '2024-12-21 17:33:36');
INSERT INTO `operation_log` VALUES (10, 2, '商品上架', '2024-12-21 17:33:37');
INSERT INTO `operation_log` VALUES (11, 2, '商品上架', '2024-12-21 17:33:37');
INSERT INTO `operation_log` VALUES (12, 2, '商品上架', '2024-12-21 17:33:38');
INSERT INTO `operation_log` VALUES (13, 2, '商品上架', '2024-12-21 17:33:38');
INSERT INTO `operation_log` VALUES (14, 2, '商品上架', '2024-12-21 17:33:38');
INSERT INTO `operation_log` VALUES (15, 2, '商品上架', '2024-12-21 17:33:38');
INSERT INTO `operation_log` VALUES (16, 2, '商品修改', '2024-12-22 10:47:47');
INSERT INTO `operation_log` VALUES (17, 2, '商品下单', '2024-12-22 11:11:39');
INSERT INTO `operation_log` VALUES (18, 2, '商品修改', '2024-12-22 12:25:47');
INSERT INTO `operation_log` VALUES (19, 2, '商品修改', '2024-12-22 12:26:07');
INSERT INTO `operation_log` VALUES (20, 2, '商品申请退款', '2024-12-22 12:27:37');
INSERT INTO `operation_log` VALUES (21, 2, '确定收货', '2025-06-02 13:36:50');
INSERT INTO `operation_log` VALUES (22, 2, '确定收货', '2025-06-02 13:36:53');
INSERT INTO `operation_log` VALUES (23, 2, '确定收货', '2025-06-02 13:36:56');
INSERT INTO `operation_log` VALUES (24, 2, '确定收货', '2025-06-02 13:38:10');
INSERT INTO `operation_log` VALUES (25, 2, '确定收货', '2025-06-02 13:38:42');
INSERT INTO `operation_log` VALUES (26, 2, '确定收货', '2025-06-02 13:39:22');
INSERT INTO `operation_log` VALUES (27, 2, '商品申请退款', '2025-06-02 15:30:59');
INSERT INTO `operation_log` VALUES (28, 8, '商品申请退款', '2025-06-02 15:52:11');
INSERT INTO `operation_log` VALUES (29, 8, '确定收货', '2025-06-02 15:54:37');
INSERT INTO `operation_log` VALUES (30, 8, '商品申请退款', '2025-06-02 16:01:41');
INSERT INTO `operation_log` VALUES (31, 8, '商品申请退款', '2025-06-02 16:09:19');
INSERT INTO `operation_log` VALUES (32, 8, '确定收货', '2025-06-02 16:12:39');
INSERT INTO `operation_log` VALUES (33, 8, '商品申请退款', '2025-06-02 16:18:09');
INSERT INTO `operation_log` VALUES (34, 8, '商品申请退款', '2025-06-02 16:18:12');
INSERT INTO `operation_log` VALUES (35, 8, '商品申请退款', '2025-06-02 16:18:14');
INSERT INTO `operation_log` VALUES (36, 8, '商品申请退款', '2025-06-02 16:18:47');
INSERT INTO `operation_log` VALUES (37, 8, '确定收货', '2025-06-02 16:20:59');
INSERT INTO `operation_log` VALUES (38, 8, '商品申请退款', '2025-06-02 16:29:06');
INSERT INTO `operation_log` VALUES (39, 8, '商品申请退款', '2025-06-02 16:33:44');
INSERT INTO `operation_log` VALUES (40, 8, '商品申请退款', '2025-06-02 16:33:50');
INSERT INTO `operation_log` VALUES (41, 8, '商品申请退款', '2025-06-02 16:34:13');
INSERT INTO `operation_log` VALUES (42, 8, '商品申请退款', '2025-06-02 16:34:25');
INSERT INTO `operation_log` VALUES (43, 8, '商品申请退款', '2025-06-02 16:34:42');
INSERT INTO `operation_log` VALUES (44, 8, '商品申请退款', '2025-06-02 16:34:58');
INSERT INTO `operation_log` VALUES (45, 8, '商品申请退款', '2025-06-02 16:35:19');
INSERT INTO `operation_log` VALUES (46, 8, '商品申请退款', '2025-06-02 16:44:14');
INSERT INTO `operation_log` VALUES (47, 8, '确定收货', '2025-06-02 16:48:50');
INSERT INTO `operation_log` VALUES (48, 8, '确定收货', '2025-06-02 16:51:33');
INSERT INTO `operation_log` VALUES (49, 8, '确定收货', '2025-06-02 16:53:05');
INSERT INTO `operation_log` VALUES (50, 8, '确定收货', '2025-06-02 16:55:41');
INSERT INTO `operation_log` VALUES (51, 8, '确定收货', '2025-06-02 16:57:39');
INSERT INTO `operation_log` VALUES (52, 8, '确定收货', '2025-06-02 16:57:41');
INSERT INTO `operation_log` VALUES (53, 8, '确定收货', '2025-06-02 16:57:46');
INSERT INTO `operation_log` VALUES (54, 8, '确定收货', '2025-06-02 16:59:12');
INSERT INTO `operation_log` VALUES (55, 8, '商品申请退款', '2025-06-02 16:59:17');
INSERT INTO `operation_log` VALUES (56, 8, '商品申请退款', '2025-06-02 16:59:20');
INSERT INTO `operation_log` VALUES (57, 8, '确定收货', '2025-06-02 16:59:38');
INSERT INTO `operation_log` VALUES (58, 8, '确定收货', '2025-06-02 16:59:46');
INSERT INTO `operation_log` VALUES (59, 8, '确定收货', '2025-06-02 17:00:21');
INSERT INTO `operation_log` VALUES (60, 8, '商品上架', '2025-06-02 17:36:45');
INSERT INTO `operation_log` VALUES (61, 8, '商品修改', '2025-06-02 17:37:04');
INSERT INTO `operation_log` VALUES (62, 8, '确定收货', '2025-06-02 17:39:12');
INSERT INTO `operation_log` VALUES (63, 8, '商品申请退款', '2025-06-02 17:39:14');
INSERT INTO `operation_log` VALUES (64, 2, '商品申请退款', '2025-06-25 18:02:16');
INSERT INTO `operation_log` VALUES (65, 2, '确定收货', '2025-06-25 18:02:19');
INSERT INTO `operation_log` VALUES (66, 2, '商品申请退款', '2025-06-25 18:02:21');
INSERT INTO `operation_log` VALUES (67, 2, '确定收货', '2025-06-25 21:09:05');
INSERT INTO `operation_log` VALUES (68, 2, '商品上架', '2025-06-25 21:11:33');
INSERT INTO `operation_log` VALUES (69, 2, '商品修改', '2025-06-25 21:11:47');
INSERT INTO `operation_log` VALUES (70, 17, '商品上架', '2025-09-08 19:56:45');
INSERT INTO `operation_log` VALUES (71, 17, '商品发货', '2025-09-08 21:34:09');
INSERT INTO `operation_log` VALUES (72, 17, '商品发货', '2025-09-08 21:34:13');
INSERT INTO `operation_log` VALUES (73, 17, '商品发货', '2025-09-08 21:34:35');
INSERT INTO `operation_log` VALUES (74, 17, '商品发货', '2025-09-08 21:34:49');
INSERT INTO `operation_log` VALUES (75, 17, '商品发货', '2025-09-08 21:34:53');
INSERT INTO `operation_log` VALUES (76, 17, '商品发货', '2025-09-08 21:35:25');
INSERT INTO `operation_log` VALUES (77, 17, '商品发货', '2025-09-08 21:35:54');
INSERT INTO `operation_log` VALUES (78, 17, '商品发货', '2025-09-08 21:36:36');
INSERT INTO `operation_log` VALUES (79, 17, '商品发货', '2025-09-08 21:36:44');
INSERT INTO `operation_log` VALUES (80, 17, '商品发货', '2025-09-08 21:38:12');
INSERT INTO `operation_log` VALUES (81, 17, '商品发货', '2025-09-08 21:38:25');
INSERT INTO `operation_log` VALUES (82, 17, '商品发货', '2025-09-08 21:39:09');
INSERT INTO `operation_log` VALUES (83, 17, '商品发货', '2025-09-08 21:42:17');
INSERT INTO `operation_log` VALUES (84, 16, '确定收货', '2025-09-08 21:53:02');
INSERT INTO `operation_log` VALUES (85, 16, '确定收货', '2025-09-08 21:55:20');
INSERT INTO `operation_log` VALUES (86, 16, '确定收货', '2025-09-08 21:56:17');
INSERT INTO `operation_log` VALUES (87, 17, '商品发货', '2025-09-08 22:18:39');
INSERT INTO `operation_log` VALUES (88, 16, '确定收货', '2025-09-08 22:18:45');
INSERT INTO `operation_log` VALUES (89, 17, '商品发货', '2025-09-09 13:52:54');
INSERT INTO `operation_log` VALUES (90, 16, '确定收货', '2025-09-09 13:53:25');
INSERT INTO `operation_log` VALUES (91, 17, '商品发货', '2025-09-09 13:56:15');
INSERT INTO `operation_log` VALUES (92, 16, '确定收货', '2025-09-09 13:56:25');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单主键',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '订单号',
  `detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '备注',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `product_id` int(11) NULL DEFAULT NULL COMMENT '商品ID',
  `buy_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '购买时的价格',
  `buy_number` int(11) NULL DEFAULT NULL COMMENT '购买数量',
  `trade_status` tinyint(1) NULL DEFAULT NULL COMMENT '交易状态（1：待支付；2：已支付；3：已取消）',
  `trade_time` datetime NULL DEFAULT NULL COMMENT '交易时间',
  `refund_status` tinyint(1) NULL DEFAULT NULL COMMENT '退款状态（1: 无退款；2：申请退款；3：拒绝退款；4：已退款）',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `is_refund_confirm` tinyint(1) NULL DEFAULT NULL COMMENT '退款是否已经确认(卖家进行的确认)',
  `is_confirm_time` datetime NULL DEFAULT NULL COMMENT '确认收货时间',
  `is_confirm` tinyint(1) NULL DEFAULT NULL COMMENT '是否确认收货',
  `address_id` int(11) NULL DEFAULT NULL COMMENT '收货地址ID',
  `is_deliver` tinyint(1) NULL DEFAULT NULL COMMENT '卖家是否已经发货',
  `deliver_time` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `deliver_adr_id` int(11) NULL DEFAULT NULL COMMENT '商家发货地址ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (19, '1757397359543', '', 16, 23, 2798.00, 2, 2, '2025-09-09 13:56:04', 3, NULL, NULL, '2025-09-09 13:56:25', 1, 7, 1, '2025-09-09 13:56:15', 9, '2025-09-09 13:56:00');

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品的ID，主键自增',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '商品名',
  `detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '商品的简介',
  `cover_list` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '商品封面的列表',
  `old_level` int(2) NULL DEFAULT NULL COMMENT '新旧程度',
  `category_id` int(11) NULL DEFAULT NULL COMMENT '所属商品分类的ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '发布者用户ID',
  `inventory` int(11) NULL DEFAULT NULL COMMENT '库存',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `is_bargain` tinyint(1) NULL DEFAULT NULL COMMENT '是否支持砍价',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (1, 'vivoX100', '<p>保真</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=9fd561f3.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=0be94df5.png', 7, 1, 12, 20, 1699.00, 1, '2024-12-10 19:47:27');
INSERT INTO `product` VALUES (4, '苹果11', '<p>零食</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=5eb81a84.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=15d04683.png', 10, 1, 8, 20, 1999.90, 1, '2024-12-14 16:12:47');
INSERT INTO `product` VALUES (6, '咖啡糖', '<p>零食</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=67b7ba410.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=0c3e5d16.png', 9, 7, 8, 0, 19.90, 1, '2024-12-14 17:54:36');
INSERT INTO `product` VALUES (7, '洗衣机', '<p>零食</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=4b0513a11.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=b3554a24.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=4d108755.png', 9, 7, 8, 20, 129.90, 1, '2024-12-14 17:54:43');
INSERT INTO `product` VALUES (8, '测试1', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png', 8, 6, 9, 6, 23.00, 1, '2024-12-18 17:33:16');
INSERT INTO `product` VALUES (9, '测试1', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png', 8, 6, 9, 6, 23.10, 1, '2024-12-18 17:33:22');
INSERT INTO `product` VALUES (11, '测试4', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png', 8, 6, 9, 6, 23.00, 1, '2024-12-19 17:33:29');
INSERT INTO `product` VALUES (12, '测试12', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png', 8, 6, 10, 6, 23.00, 1, '2024-12-21 17:33:32');
INSERT INTO `product` VALUES (13, '测试12', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png', 8, 6, 10, 0, 23.10, 1, '2024-12-19 17:33:34');
INSERT INTO `product` VALUES (14, '测试12', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png', 10, 6, 10, 3, 23.10, 1, '2024-12-21 17:33:36');
INSERT INTO `product` VALUES (15, '测试12', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png', 10, 6, 11, 3, 23.10, 1, '2024-12-01 17:33:37');
INSERT INTO `product` VALUES (16, '测试12', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png', 10, 6, 11, 3, 23.10, 1, '2024-12-21 17:33:37');
INSERT INTO `product` VALUES (17, '测试12', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png', 10, 6, 12, 7, 23.10, 1, '2024-12-20 17:33:38');
INSERT INTO `product` VALUES (18, '测试12', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png', 10, 7, 12, 7, 23.10, 1, '2024-12-21 17:33:38');
INSERT INTO `product` VALUES (20, '自热火锅', '<p>测试</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=081cc8e6.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=103c0f411.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=ab1d46f8.png', 9, 7, 12, 7, 23.10, 1, '2024-12-21 17:33:38');
INSERT INTO `product` VALUES (21, '测试商品发布', '<p>商品描述</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=23543efSnipaste_2025-04-20_13-22-25.png', 9, 6, 8, 15, 12.40, 1, '2025-06-02 17:36:46');
INSERT INTO `product` VALUES (22, '智能手表1', '<p>手表</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=fda4fb5Snipaste_2025-04-20_13-22-25.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=8ab6e7cSnipaste_2025-04-20_16-30-21.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=b04aaf9Snipaste_2025-04-20_16-30-02.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=b6d203eSnipaste_2025-04-20_13-21-25.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=7815726Snipaste_2025-04-20_13-25-58.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=edfb7c0Snipaste_2025-04-20_16-30-13.png', 9, 5, 2, 1, 222.00, 1, '2025-06-25 21:11:33');
INSERT INTO `product` VALUES (23, 'vivox100测试商品', '<p>自用手机，成色良好</p>', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=43f7141Snipaste_2025-09-08_19-56-07.png,http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=1d73bc6Snipaste_2025-09-08_19-56-20.png', 9, 1, 17, 7, 1399.00, 1, '2025-09-08 19:56:45');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户编号',
  `user_account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户账号',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `user_pwd` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户密码',
  `user_avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户头像',
  `user_email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户邮箱',
  `user_role` int(11) NULL DEFAULT NULL COMMENT '用户角色',
  `is_login` tinyint(1) NULL DEFAULT NULL COMMENT '可登录状态(0：可用，1：不可用)',
  `is_word` tinyint(1) NULL DEFAULT NULL COMMENT '禁言状态(0：可用，1：不可用)',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '上一次登录时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '用户注册时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'B站【程序员辰星】原创出品', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=49bf8cepic_6.jpg', '1343243@qq.com', 1, 0, 0, '2025-06-25 21:00:37', '2024-12-04 12:53:05');
INSERT INTO `user` VALUES (2, 'zhangfan', 'B站【程序员辰星】原创出品', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=0e61962pic_8.jpg', '12311323@qq.com', 2, 0, 0, '2025-06-25 21:06:18', '2024-08-16 16:12:12');
INSERT INTO `user` VALUES (7, 'liran', '李冉1', '14e1b600b1fd579f47433b88e8d85291', '/api/campus-product-sys/v1.0/file/getFile?fileName=1288932pic_8.jpg', '12434@qq.com', 1, 1, 1, NULL, '2024-10-19 06:39:12');
INSERT INTO `user` VALUES (8, 'lichen', '李琛', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=45aebe6pic_7.jpg', '12345@qq.com', 2, 0, 0, '2025-06-03 18:46:25', '2024-12-05 15:44:45');
INSERT INTO `user` VALUES (9, 'wangfangfang', '王芳芳', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=0b7a9e86.png', '1234@qq.com', 2, 0, 1, '2025-06-25 20:55:01', '2024-12-05 15:45:12');
INSERT INTO `user` VALUES (10, 'yuelang', '月朗', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=08ff6d6Snipaste_2025-04-21_16-56-22.png', '4532432@qq.com', 2, 0, 0, '2025-05-10 17:19:37', '2024-12-05 15:46:46');
INSERT INTO `user` VALUES (11, 'chenxin', '陈芯', '14e1b600b1fd579f47433b88e8d85291', '/api/campus-product-sys/v1.0/file/getFile?fileName=1288932pic_8.jpg', '123432@qq.com', 2, 0, 0, NULL, '2024-12-05 15:47:08');
INSERT INTO `user` VALUES (12, 'hututu', '胡图图', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=e042009pic_8.jpg', '4343@qq.com', 2, 0, 0, '2025-06-02 15:51:22', '2024-12-05 15:47:26');
INSERT INTO `user` VALUES (13, 'fanggui', '方贵', '14e1b600b1fd579f47433b88e8d85291', '/api/campus-product-sys/v1.0/file/getFile?fileName=1288932pic_8.jpg', '43423@qq.com', 2, 0, 0, NULL, '2024-12-05 15:51:13');
INSERT INTO `user` VALUES (14, 'jiangxin', '江心', '14e1b600b1fd579f47433b88e8d85291', '/api/campus-product-sys/v1.0/file/getFile?fileName=1288932pic_8.jpg', '124343@qq.com', 2, 0, 0, NULL, '2024-12-05 15:54:50');
INSERT INTO `user` VALUES (15, 'moxin', '陌心', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=b3e3d35pic_7.jpg', '654456@qq.com', 2, 1, 0, NULL, '2024-12-05 15:55:12');
INSERT INTO `user` VALUES (16, 'user1', '测试用户1', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=5868b252.png', NULL, 2, 0, 0, '2025-09-08 19:53:04', '2025-09-08 19:52:56');
INSERT INTO `user` VALUES (17, 'user2', '测试卖家1', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/campus-product-sys/v1.0/file/getFile?fileName=248d1e7Snipaste_2025-04-25_15-25-57.png', NULL, 2, 0, 0, '2025-09-08 19:54:13', '2025-09-08 19:54:04');

SET FOREIGN_KEY_CHECKS = 1;
