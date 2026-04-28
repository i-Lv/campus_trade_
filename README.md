# 🎓 Campus Trade — 校园二手交易平台

> 一个面向在校学生的二手商品交易系统，支持商品发布、在线交易、动态广场、退款处理等完整电商闭环。

[![Java](https://img.shields.io/badge/Java-1.8-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.2.4-green.svg)](https://spring.io/projects/spring-boot)
[![Vue](https://img.shields.io/badge/Vue-2.6.11-brightgreen.svg)](https://vuejs.org/)
[![MySQL](https://img.shields.io/badge/MySQL-5.7-blue.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)

---

## 📖 项目简介

**Campus Trade** 是一款基于 **Spring Boot + Vue 2** 前后端分离架构构建的校园二手交易平台。学生用户可以在平台上发布闲置物品、浏览购买商品、发表动态帖子、进行评论互动，平台管理员可以通过专属后台对用户、商品、订单、内容等数据进行全面管控。

---

## ✨ 核心功能

### 👤 用户端

| 功能模块 | 描述 |
|:---|:---|
| 账号系统 | 注册、登录（JWT 鉴权）、修改密码、头像上传、个人信息编辑 |
| 商品市场 | 商品列表浏览、关键词搜索、分类筛选、商品详情查看 |
| 发布商品 | 支持多图上传、新旧程度标注、砍价标记，可编辑和管理我的商品 |
| 交易系统 | 下单购买、填写收货地址、订单管理（待支付/已支付）、申请退款、确认收货 |
| 物流追踪 | 卖家发货操作，买家查看发货状态 |
| 互动系统 | 收藏商品、浏览足迹（自动记录）、"我想要"意向表达（触发站内消息通知） |
| 动态广场 | 发布 / 编辑 / 查看图文动态（富文本），评论 / 回复 / 点赞 |
| 消息中心 | 查看系统通知消息 |
| 地址管理 | 多收货地址管理、设置默认地址 |
| 个人主页 | 查看他人主页及其发布的商品 |

### 🛠️ 管理员端

| 功能模块 | 描述 |
|:---|:---|
| 仪表盘 | 用户数 / 商品数 / 订单数 / 消息数 / 互动数 / 评论数统计；商品上架趋势折线图 |
| 用户管理 | 用户列表查询、新增 / 修改、禁用账号 / 禁言、批量删除 |
| 商品管理 | 全平台商品列表、商品详情查看、批量操作 |
| 订单管理 | 全平台订单查询、退款审核处理 |
| 分类管理 | 商品分类的增删改查、启用 / 禁用分类 |
| 动态管理 | 内容审核查看、批量删除 |
| 评论管理 | 平台评论列表、批量删除 |
| 互动管理 | 用户互动行为数据查看 |
| 消息管理 | 系统消息列表 |
| 日志管理 | 用户操作日志记录查询 |

---

## 🏗️ 技术栈

### 后端（campus-product-sys）

| 技术 | 版本 | 用途 |
|:---|:---|:---|
| Spring Boot | 2.2.4.RELEASE | 主框架 |
| Java | 1.8 | 开发语言 |
| MyBatis | 2.1.2 | ORM 持久层 |
| MySQL | 5.7.43 | 关系型数据库 |
| JWT（java-jwt + jjwt） | 3.4.0 / 0.9.0 | 身份认证 |
| Lombok | — | 简化实体类开发 |
| FastJSON2 | 2.0.33 | JSON 解析 |
| EasyExcel | 3.2.1 | Excel 数据处理 |
| Jsoup | 1.14.3 | HTML 解析 |
| Apache Commons Lang3 | 3.12.0 | 工具类库 |
| Spring AOP | — | 切面编程（日志 / 鉴权 / 分页） |

### 前端（campus-product-view）

| 技术 | 版本 | 用途 |
|:---|:---|:---|
| Vue 2 | 2.6.11 | 前端主框架 |
| Vue Router | 3.2.0 | 路由管理 |
| Element UI | 2.15.14 | UI 组件库 |
| Axios | 0.21.1 | HTTP 请求封装 |
| ECharts | 4.8.0 | 数据可视化图表 |
| WangEditor | 5.x | 富文本编辑器 |
| crypto-js / js-md5 | 4.2.0 / 0.8.3 | 密码加密 |
| jwt-decode | 3.1.2 | 前端 JWT 解析 |
| sm4util | 1.0.5 | 国密 SM4 加密 |
| element-china-area-data | 6.1.0 | 中国省市区级联 |
| sweetalert2 | 5.0.10 | 弹窗提示 |
| SASS | 1.32.0 | CSS 预处理器 |

---

## 📁 项目结构

```
campus_trade/
├── campus-product-sys/          # 后端 Spring Boot 项目
│   ├── src/main/java/cn/kmbeast/
│   │   ├── CampusProductApplication.java   # 启动类
│   │   ├── aop/                             # AOP 切面（日志/分页/鉴权）
│   │   ├── config/                          # Web 及拦截器配置
│   │   ├── Interceptor/                     # JWT 全局拦截器
│   │   ├── context/                         # ThreadLocal 用户上下文
│   │   ├── controller/                      # 控制器层（14 个）
│   │   ├── service/                         # 业务逻辑层
│   │   ├── mapper/                          # MyBatis Mapper 接口
│   │   ├── pojo/
│   │   │   ├── entity/                      # 数据库实体类
│   │   │   ├── dto/                         # 请求参数 DTO
│   │   │   ├── vo/                          # 响应视图 VO
│   │   │   ├── api/                         # 统一响应封装
│   │   │   └── em/                          # 枚举类（角色/状态等）
│   │   └── utils/                           # 工具类（JWT/日期/文件路径等）
│   └── src/main/resources/
│       ├── application.yml                  # 项目配置
│       └── mapper/                          # MyBatis XML 映射文件（11 个）
│
├── campus-product-view/         # 前端 Vue2 项目
│   └── src/
│       ├── router/index.js                  # 路由配置（含路由守卫）
│       ├── utils/                           # axios 封装、sessionStorage 工具等
│       ├── components/                      # 公共组件（富文本、图表、菜单等）
│       └── views/
│           ├── login/                       # 登录页
│           ├── register/                    # 注册页
│           ├── admin/                       # 管理员端（11 个页面）
│           └── user/                        # 普通用户端（22 个页面）
│
└── sql/
    ├── campus-product.sql       # 数据库初始化脚本（旧版）
    └── campus-2.sql             # 数据库初始化脚本（最新版，推荐使用）
```

---

## 🗄️ 数据库设计

数据库名：`campus-2`，共 **11 张表**。

| 表名 | 说明 |
|:---|:---|
| `user` | 用户信息（账号、昵称、密码MD5、头像、角色、禁用/禁言状态） |
| `product` | 商品信息（名称、描述富文本、多图、新旧程度、分类、价格、库存、是否支持砍价） |
| `orders` | 订单信息（订单号、买卖双方、价格快照、交易状态、退款状态、发货状态、收货地址） |
| `category` | 商品分类（手机、衣服、书籍、手表、零食等） |
| `address` | 收货地址（收件人、地址、电话、是否默认） |
| `content` | 动态帖子（标题、富文本内容、封面图） |
| `evaluations` | 评论信息（支持商品/动态两种类型，支持嵌套回复） |
| `evaluations_upvote` | 评论点赞记录 |
| `interaction` | 用户互动行为（1:收藏，2:浏览，3:想要） |
| `message` | 系统消息通知 |
| `operation_log` | 用户操作日志（上架/修改/下单/发货/退款/确认收货等） |

---

## 🚀 快速开始

### 环境要求

- JDK 1.8+
- Maven 3.6+
- MySQL 5.7+
- Node.js 14+ / npm
- Redis（可选，用于缓存加速）

---

### 1. 数据库初始化

```sql
-- 创建数据库
CREATE DATABASE `campus-2` CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- 导入最新数据（推荐）
source /path/to/sql/campus-2.sql;
```

---

### 2. 配置修改

编辑 `campus-product-sys/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    username: root          # 修改为你的数据库用户名
    password: root          # 修改为你的数据库密码
```

---

### 3. 启动后端

```bash
cd campus-product-sys

# 编译并启动
mvn spring-boot:run
```

后端默认运行在 `http://localhost:21090`，接口前缀：`/api/campus-product-sys/v1.0`

> **注意：** 首次启动需确保 `pic/` 目录存在于项目根路径（用于存储上传的图片），或系统会自动创建。

---

### 4. 启动前端

```bash
cd campus-product-view

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

前端默认运行在 `http://localhost:21091`，已配置代理将 `/api` 请求转发至后端。

---

### 5. 访问系统

| 角色 | 访问地址 | 默认账号 | 默认密码 |
|:---|:---|:---|:---|
| 管理员 | `http://localhost:21091/#/login` | `admin` | `123456` |
| 普通用户 | `http://localhost:21091/#/login` | `zhangfan` | `123456` |

> 密码在数据库中以 **MD5** 方式存储，初始密码对应 MD5 值为 `14e1b600b1fd579f47433b88e8d85291`（即 `123456`）。

---

## 🔐 鉴权机制

本项目采用 **JWT + AOP + 全局拦截器** 三层鉴权体系：

1. **全局拦截器 `JwtInterceptor`**：拦截所有请求，放行登录 `/login`、注册 `/register`、文件访问 `/file` 以及公开查询接口
2. **AOP 注解 `@Protector`**：精细化接口权限控制，`@Protector(role="管理员")` 限制管理员专属接口
3. **前端路由守卫**：根据 `role=1/2` 严格区分管理员（`/admin`）与普通用户（`/user`）访问路径
4. **TokenLocalThread**：JWT 解析后将用户 ID 和角色信息存入 `ThreadLocal`，在整个请求链路中透传

---

## ⚙️ 配置说明

### 后端配置（`application.yml`）

```yaml
server:
  port: 21090
  servlet:
    context-path: /api/campus-product-sys/v1.0

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/campus-2?characterEncoding=utf8&useSSL=false&serverTimezone=GMT%2B8
    username: root          # 修改为你的数据库用户名
    password: root          # 修改为你的数据库密码
  servlet:
    multipart:
      max-file-size: 10MB   # 文件上传大小限制
      max-request-size: 10MB
```

### 前端配置（`vue.config.js`）

```javascript
devServer: {
  port: 21091,
  proxy: {
    '/api': {
      target: 'http://localhost:21090',  // 后端地址
      changeOrigin: true,
      pathRewrite: { '^/api': '' }
    }
  }
}
```

---

## 📡 API 接口概览

**Base URL：** `http://localhost:21090/api/campus-product-sys/v1.0`

| 模块 | 路径前缀 | 主要接口 |
|:---|:---|:---|
| 用户 | `/user` | 登录、注册、Token 校验、用户查询、修改信息、修改密码 |
| 商品 | `/product` | 发布、编辑、查询、下单、申请退款、确认收货、发货 |
| 订单 | `/orders` | 查询订单（买家/卖家视角）、退款处理 |
| 分类 | `/category` | 查询分类、新增/修改/删除分类（管理员） |
| 地址 | `/address` | 新增/修改/删除地址、设置默认地址 |
| 互动 | `/interaction` | 收藏、取消收藏、浏览记录、"我想要" |
| 评论 | `/evaluations` | 发表评论、点赞/取消点赞、查询评论列表、删除评论 |
| 动态 | `/content` | 发布/编辑/查询动态、删除动态 |
| 消息 | `/message` | 查询消息通知 |
| 文件 | `/file` | 图片/视频上传、文件访问 |
| 仪表盘 | `/dashboard` | 数据统计、商品上架趋势 |
| 日志 | `/operationLog` | 查询操作日志 |

---

## 🌟 设计亮点

- **AOP 三重切面**：`@Log`（操作日志自动记录）、`@Pager`（分页参数自动注入）、`@Protector`（JWT 鉴权 + 角色验证），实现关注点分离
- **ThreadLocal 用户上下文**：`LocalThreadHolder` 在整个请求链路中透传用户 ID 与角色，无需层层传参
- **双角色路由守卫**：前端严格区分管理员 `/admin` 与用户 `/user` 路由，非法访问自动跳转登录页
- **消息触发机制**：用户"想要"操作自动向商品卖家发送站内消息通知
- **富文本支持**：商品详情和动态内容均采用 WangEditor 5 富文本编辑器
- **文件本地化存储**：图片/视频存储于服务端 `pic/` 目录，通过 `/file/getFile` 接口回显

---

## 📸 页面截图

> 可在启动项目后自行截图，建议添加以下页面截图以增强 README 展示效果：
> - 用户首页 / 商品列表
> - 商品详情页
> - 动态广场
> - 订单管理页
> - 管理员仪表盘

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📄 许可证

本项目基于 [MIT License](LICENSE) 开源。

---

<div align="center">
  <p>Made with ❤️ for Campus Students</p>
</div>
