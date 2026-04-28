<template>
    <div class="content-list-container">
      <!-- 筛选区 -->
      <div class="filter-section">
        <div class="filter-container">
          <el-input v-model="contentQueryDto.name" placeholder="搜索动态标题" clearable size="large"
            class="search-input" @clear="fetchFreshData" @keyup.enter="fetchFreshData">
            <template #append>
              <el-button type="primary" class="customer"  icon="el-icon-search" @click="fetchFreshData"></el-button>
            </template>
          </el-input>
        </div>
      </div>
  
      <!-- 动态列表 -->
      <div class="content-list">
        <el-empty v-if="contentList.length === 0" description="暂无动态信息"></el-empty>
  
        <transition-group v-else name="content-list" tag="div" class="content-grid">
          <div v-for="content in contentList" :key="content.id" class="content-card" @click="viewContentDetail(content)">
            <div class="content-image-container">
              <img :src="getCoverImage(content)" :alt="content.name" class="content-image">
            </div>
  
            <div class="content-info">
              <h3 class="content-title">{{ content.name }}</h3>
  
              <div class="author-info">
                <el-avatar :src="content.userAvatar" size="small"></el-avatar>
                <span class="author-name">{{ content.userName }}</span>
              </div>
            </div>
          </div>
        </transition-group>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'ContentList',
    data() {
      return {
        contentQueryDto: {
          name: ''
        },
        contentList: []
      };
    },
    created() {
      this.fetchFreshData();
    },
    methods: {
      addContent() {
        this.$router.push('/post-content');
      },
  
      viewContentDetail(content) {
        this.$router.push(`/content-detail-user?id=${content.id}`);
      },
  
      getCoverImage(content) {
        return content.cover || '';
      },
  
      async fetchFreshData() {
        try {
          const res = await this.$axios.post('/content/query', this.contentQueryDto);
          if (res.data.code === 200) {
            this.contentList = res.data.data;
          }
        } catch (error) {
          console.error("动态查询异常：", error);
          this.$message.error('获取动态列表失败');
        }
      }
    }
  };
  </script>
  
  <style scoped lang="scss">
  .content-list-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
  
    .filter-section {
      background-color: #fff;
      border-radius: 12px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
      margin-bottom: 20px;
      padding: 20px;
  
      .filter-container {
        display: flex;
        gap: 15px;
  
        .search-input {
          flex: 1;
          max-width: 400px;
        }
  
        .add-button {
          background: linear-gradient(90deg, #409EFF, #66b1ff);
          border: none;
          box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
          transition: all 0.3s;
  
          &:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(64, 158, 255, 0.4);
          }
        }
      }
    }
  
    .content-list {
      .content-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 20px;
  
        .content-list-move {
          transition: transform 0.5s;
        }
  
        .content-list-enter-active,
        .content-list-leave-active {
          transition: all 0.5s;
        }
  
        .content-list-enter,
        .content-list-leave-to {
          opacity: 0;
          transform: translateY(20px);
        }
      }
  
      .content-card {
        background-color: #fff;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        transition: all 0.3s;
        cursor: pointer;
  
        &:hover {
          transform: translateY(-5px);
          box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
  
          .content-image {
            transform: scale(1.05);
          }
        }
  
        .content-image-container {
          position: relative;
          height: 200px;
          overflow: hidden;
          background-color: #f5f7fa;
  
          .content-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
          }
  
          .like-count {
            position: absolute;
            bottom: 10px;
            right: 10px;
            background-color: rgba(0, 0, 0, 0.6);
            color: #fff;
            font-size: 12px;
            padding: 4px 10px;
            border-radius: 12px;
            display: flex;
            align-items: center;
  
            i {
              margin-right: 5px;
              color: #ffcc00;
            }
          }
        }
  
        .content-info {
          padding: 15px;
  
          .content-title {
            margin: 0 0 10px 0;
            font-size: 16px;
            color: #333;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
          }
  
          .author-info {
            display: flex;
            align-items: center;
            gap: 8px;
  
            .author-name {
              font-size: 14px;
              color: #666;
            }
          }
        }
      }
    }
  }
  
  @media (max-width: 768px) {
    .content-list-container {
      padding: 10px;
  
      .filter-section {
        padding: 15px;
  
        .filter-container {
          flex-direction: column;
  
          .search-input {
            max-width: 100%;
          }
        }
      }
  
      .content-grid {
        grid-template-columns: 1fr !important;
      }
    }
  }
  </style>