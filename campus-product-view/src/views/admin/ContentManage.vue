<template>
    <div class="content-list-container">
      <!-- 筛选区 -->
      <div class="filter-section">
        <div class="filter-container">
          <el-input 
            v-model="contentQueryDto.name" 
            placeholder="搜索动态标题" 
            clearable 
            size="large"
            class="search-input" 
            @clear="fetchFreshData" 
            @keyup.enter="fetchFreshData">
            <template #append>
              <el-button type="primary" class="customer" icon="el-icon-search" @click="fetchFreshData"></el-button>
            </template>
          </el-input>
        </div>
      </div>
  
      <!-- 动态列表 -->
      <div class="content-list">
        <el-empty v-if="contentList.length === 0" description="暂无动态信息"></el-empty>
  
        <transition-group key="model-1" v-else name="content-list" tag="div" class="content-grid">
          <div 
            v-for="content in contentList" 
            :key="content.id" 
            class="content-card">
            <div class="content-image-container" @click="viewContentDetail(content)">
              <img :src="getCoverImage(content)" :alt="content.name" class="content-image">
            </div>
  
            <div class="content-info">
              <h3 class="content-title" @click="viewContentDetail(content)">{{ content.name }}</h3>
  
              <div class="author-info">
                <el-avatar :src="content.userAvatar" size="small"></el-avatar>
                <span class="author-name">{{ content.userName }}</span>
              </div>
  
              <!-- 操作按钮组 -->
              <div class="action-buttons">
                <el-button 
                  size="mini" 
                  type="danger" 
                  @click.stop="confirmDelete(content)">
                  删除
                </el-button>
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
        this.$router.push(`/content-detail?id=${content.id}`);
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
      },
  
      confirmDelete(content) {
        this.$confirm('确定要删除这条动态吗？删除后无法恢复', '删除确认', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.deleteContent(content.id);
        }).catch(() => {
  
        });
      },
  
      async deleteContent(contentId) {
        try {
          const res = await this.$axios.post('/content/batchDelete', [contentId]);
          if (res.data.code === 200) {
            this.$message.success('删除成功');
            this.fetchFreshData();
          } else {
            this.$message.error(res.data.msg || '删除失败');
          }
        } catch (error) {
          console.error("删除动态异常：", error);
          this.$message.error('删除失败');
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
          cursor: pointer;
  
          .content-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
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
            cursor: pointer;
            transition: color 0.3s;
  
            &:hover {
              color: #409EFF;
            }
          }
  
          .author-info {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 15px;
  
            .author-name {
              font-size: 14px;
              color: #666;
            }
          }
  
          .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            padding-top: 10px;
            border-top: 1px dashed #ebeef5;
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