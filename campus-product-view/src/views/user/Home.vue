<template>
  <div class="ecommerce-platform">
    <!-- 顶部导航栏 -->
    <header class="header">
      <div class="header-container">
        <!-- Logo和主导航 -->
        <div class="main-nav">
          <div class="logo-container">
            <Logo name="校园交易" bag="rgb(51,51,51)" />
          </div>
          <nav class="nav-menu">
            <router-link v-for="(item, index) in navItems" :key="index" :to="item.path" class="nav-item"
              active-class="active" v-if="item.show">
              {{ item.name }}
            </router-link>
          </nav>
        </div>

        <!-- 搜索和用户操作 -->
        <div class="user-actions">
          <div class="search-box">
            <input type="text" placeholder="搜索商品..." v-model="key" @keyup.enter="fetch">
            <button class="search-btn" @click="fetch">
              <i class="el-icon-search"></i>
            </button>
          </div>

          <template v-if="loginStatus">
            <div class="action-item" @click="handleRouteSelect('/orders')">
              <i class="el-icon-document"></i>
              <span>订单</span>
            </div>
            <div class="action-item" @click="handleRouteSelect('/message')">
              <i class="el-icon-bell"></i>
              <span>通知</span>
            </div>
            <div class="action-item" @click="handleRouteSelect('/myContent')">
              <i class="el-icon-document-copy"></i>
              <span>我的动态</span>
            </div>
            <div class="action-item highlight" @click="handleRouteSelect('/post-product')">
              <i class="el-icon-plus"></i>
              <span>发布商品</span>
            </div>
            <el-dropdown trigger="click" class="user-dropdown">
              <div class="user-avatar">
                <img :src="userInfo.userAvatar || '/logo.png'" alt="用户头像">
              </div>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item @click.native="handleRouteSelect('/myself')">个人中心</el-dropdown-item>
                <el-dropdown-item @click.native="handleRouteSelect('/address')">收货地址/发货地址</el-dropdown-item>
                <el-dropdown-item @click.native="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </template>
          <template v-else>
            <button class="login-btn" @click="loginOperation">登录 / 注册</button>
          </template>
        </div>
      </div>
    </header>

    <!-- 用户信息面板 -->
    <div class="user-panel" v-if="loginStatus">
      <div class="user-container">
        <div class="user-avatar-large">
          <img :src="userInfo.userAvatar || '/logo.png'" alt="用户头像">
        </div>
        <div class="user-info">
          <div class="user-name">
            <h2>{{ userInfo.userName }}</h2>
            <div class="user-stats">
              <span v-for="(info, index) in productInfoList" :key="index" class="stat-item">
                {{ info.name }}·{{ info.count }}
              </span>
            </div>
          </div>
          <div class="user-meta">
            <p><i class="el-icon-time"></i> 上次登录: {{ formatDate(userInfo.lastLoginTime) }}</p>
            <p><i class="el-icon-user"></i> 注册于: {{ formatDate(userInfo.createTime) }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 主内容区 -->
    <main class="main-content">
      <router-view></router-view>
    </main>
  </div>
</template>

<script>
import Logo from "@/components/Logo";
import { getToken, setUserInfo, setSearchKey, removeToken } from "@/utils/storage";

export default {
  name: "EcommercePlatform",
  components: {
    Logo,
  },
  data() {
    return {
      key: null,
      loginStatus: false,
      userInfo: {},
      productInfoList: [],
      searchPath: '/search',
      navItems: [
        { name: '商品', path: '/product', show: true },
        { name: '我的商品', path: '/myProduct', show: false },
        { name: '我的收藏', path: '/mySave', show: false },
        { name: '足迹', path: '/myView', show: false },
        { name: '用户动态', path: '/content', show: false }
      ]
    };
  },
  created() {
    this.loadLoginStatus();
    this.handleRouteSelect('/product');
  },
  methods: {
    formatDate(date) {
      if (!date) return '--';
      return new Date(date).toLocaleString();
    },

    queryProductInfo() {
      this.$axios.post(`/product/queryProductInfo`, {}).then(res => {
        const { data } = res;
        if (data.code === 200) {
          this.productInfoList = data.data;
        }
        this.loginStatus = data.code === 200;
      }).catch(error => {
        console.error("商品指标查询异常：", error);
      });
    },

    loginOperation() {
      this.$router.push('/login');
    },

    logout() {
      sessionStorage.setItem('token', '');
      this.loginStatus = false;
      this.$router.push('/login');
    },

    fetch() {
      if (!this.key) return;
      setSearchKey(this.key);
      this.handleRouteSelect(this.searchPath);
    },

    handleRouteSelect(path) {
      if (this.$router.currentRoute.fullPath !== path) {
        this.$router.push(path);
      }
    },

    loadLoginStatus() {
      const token = getToken();
      if (!token) {
        this.loginStatus = false;
        return;
      }
      this.auth();
    },

    auth() {
      this.$axios.get(`/user/auth`).then(res => {
        const { data } = res;
        if (data.code === 200) {
          setUserInfo(data.data);
          this.userInfo = data.data;
          this.queryProductInfo();
          // 更新导航显示状态
          this.navItems = this.navItems.map(item => ({
            ...item,
            show: item.path === '/product' || true // 根据实际需求调整
          }));
        }
        this.loginStatus = data.code === 200;
      }).catch(error => {
        console.error("token检验异常：", error);
      });
    }
  }
};
</script>

<style scoped lang="scss">
.ecommerce-platform {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #fff;

  .header {
    background-color: #fff;
    // box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    position: sticky;
    top: 0;
    z-index: 1000;

    .header-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 20px;
      height: 70px;
      display: flex;
      justify-content: space-between;
      align-items: center;

      .main-nav {
        display: flex;
        align-items: center;

        .logo-container {
          margin-right: 40px;
        }

        .nav-menu {
          display: flex;
          gap: 30px;

          .nav-item {
            color: #333;
            font-size: 16px;
            font-weight: 500;
            text-decoration: none;
            padding: 10px 0;
            position: relative;
            transition: color 0.3s;

            &:hover {
              color: #ff6b6b;
            }

            &.active {
              color: #ff6b6b;

              &::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 2px;
                background-color: #ff6b6b;
              }
            }
          }
        }
      }

      .user-actions {
        display: flex;
        align-items: center;
        gap: 20px;

        .search-box {
          display: flex;
          align-items: center;
          background-color: #f5f7fa;
          border-radius: 20px;
          padding: 5px 15px;
          transition: all 0.3s;

          &:focus-within {
            box-shadow: 0 0 0 2px rgba(255, 107, 107, 0.2);
          }

          input {
            border: none;
            background: transparent;
            outline: none;
            width: 180px;
            font-size: 14px;
            color: #333;

            &::placeholder {
              color: #999;
            }
          }

          .search-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: #666;
            font-size: 16px;
            transition: color 0.3s;

            &:hover {
              color: #ff6b6b;
            }
          }
        }

        .action-item {
          display: flex;
          flex-direction: column;
          align-items: center;
          cursor: pointer;
          padding: 5px 10px;
          border-radius: 4px;
          transition: all 0.3s;

          i {
            font-size: 20px;
            color: #666;
            margin-bottom: 2px;
          }

          span {
            font-size: 12px;
            color: #666;
          }

          &:hover {
            background-color: #f5f7fa;

            i,
            span {
              color: #ff6b6b;
            }
          }
        }

        .highlight {
          background-color: #ff6b6b;
          color: white;
          border-radius: 20px;
          padding: 8px 15px;

          i,
          span {
            color: white !important;
          }

          &:hover {
            background-color: #ff5252;
          }
        }

        .login-btn {
          background-color: #ff6b6b;
          color: white;
          border: none;
          border-radius: 20px;
          padding: 8px 20px;
          font-size: 14px;
          cursor: pointer;
          transition: background-color 0.3s;

          &:hover {
            background-color: #ff5252;
          }
        }

        .user-dropdown {
          cursor: pointer;

          .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            overflow: hidden;
            border: 2px solid #eee;
            transition: border-color 0.3s;

            img {
              width: 100%;
              height: 100%;
              object-fit: cover;
            }

            &:hover {
              border-color: #ff6b6b;
            }
          }
        }
      }
    }
  }

  .user-panel {
    background: linear-gradient(135deg, #ff6b6b 0%, #ff8e8e 100%);
    color: white;
    padding: 30px 0;

    .user-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 20px;
      display: flex;
      align-items: center;

      .user-avatar-large {
        width: 100px;
        height: 100px;
        border-radius: 50%;
        overflow: hidden;
        border: 3px solid rgba(255, 255, 255, 0.3);

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }

      .user-info {
        margin-left: 30px;

        .user-name {
          display: flex;
          align-items: center;
          margin-bottom: 10px;

          h2 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
          }

          .user-stats {
            margin-left: 20px;
            display: flex;
            gap: 10px;

            .stat-item {
              background-color: rgba(255, 255, 255, 0.2);
              border-radius: 12px;
              padding: 3px 10px;
              font-size: 12px;
            }
          }
        }

        .user-meta {
          p {
            margin: 5px 0;
            font-size: 14px;
            opacity: 0.9;

            i {
              margin-right: 5px;
            }
          }
        }
      }
    }
  }

  .main-content {
    flex: 1;
    max-width: 1100px;
    width: 100%;
    margin: 30px auto;
    padding: 0 20px;
  }
}
</style>