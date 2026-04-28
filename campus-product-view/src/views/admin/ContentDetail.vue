<template>
    <div class="content-detail-container">
      <!-- 返回按钮 -->
      <el-button 
        type="text" 
        icon="el-icon-arrow-left" 
        class="back-button customer"
        @click="$router.back()">
        返回上一页
      </el-button>
  
      <!-- 内容主体 -->
      <div class="content-main">
        <!-- 内容标题区 -->
        <div class="content-header">
          <h1 class="content-title">{{ content.name }}</h1>
          <div class="meta-info">
            <el-avatar :src="content.userAvatar" size="small" class="author-avatar"></el-avatar>
            <span class="author-name">{{ content.userName }}</span>
            <span class="create-time">{{ formatTime(content.createTime) }}</span>
          </div>
        </div>
  
        <!-- 内容封面 -->
        <div class="content-cover">
          <img :src="content.cover" :alt="content.name" class="cover-image">
        </div>
  
        <!-- 内容详情 -->
        <div class="content-body" v-html="content.detail"></div>
  
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'ContentDetail',
    data() {
      return {
        content: {
          id: null,
          name: '',
          detail: '',
          cover: '',
          userAvatar: '',
          userName: '',
          createTime: '',
          likeNumber: 0
        },
        isLiked: false,
        likeCount: 0
      }
    },
    created() {
      this.fetchContentDetail();
    },
    methods: {
      async fetchContentDetail() {
        const contentId = this.$route.query.id;
        if (!contentId) {
          this.$message.error('缺少内容ID');
          return this.$router.back();
        }
  
        try {
          const res = await this.$axios.post('/content/query', { id: contentId });
          if (res.data.code === 200) {
            this.content = res.data.data[0];
          } else {
            this.$message.error(res.data.msg || '获取内容详情失败');
            this.$router.back();
          }
        } catch (error) {
          console.error("获取内容详情异常:", error);
          this.$message.error('获取内容详情失败');
          this.$router.back();
        }
      },
  
      formatTime(time) {
        if (!time) return '';
        const date = new Date(time);
        return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`;
      },
  
      async toggleLike() {
        try {
          const res = await this.$axios.post('/content/like', { 
            id: this.content.id,
            action: this.isLiked ? 'unlike' : 'like'
          });
          
          if (res.data.code === 200) {
            this.isLiked = !this.isLiked;
            this.likeCount = this.isLiked ? this.likeCount + 1 : this.likeCount - 1;
          } else {
            this.$message.warning(res.data.msg || '操作失败');
          }
        } catch (error) {
          console.error("点赞操作异常:", error);
          this.$message.error('操作失败');
        }
      }
    }
  }
  </script>
  
  <style scoped lang="scss">
  .content-detail-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
  
    .back-button {
      margin-bottom: 20px;
      color: #606266;
      transition: all 0.3s;
  
      &:hover {
        color: #409EFF;
        transform: translateX(-3px);
      }
    }
  
    .content-main {
      background-color: #fff;
      border-radius: 12px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
      padding: 30px;
    }
  
    .content-header {
      margin-bottom: 30px;
  
      .content-title {
        font-size: 24px;
        color: #333;
        margin-bottom: 15px;
        font-weight: 600;
      }
  
      .meta-info {
        display: flex;
        align-items: center;
        gap: 15px;
        color: #909399;
        font-size: 14px;
  
        .author-avatar {
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
  
        .author-name {
          color: #606266;
          font-weight: 500;
        }
      }
    }
  
    .content-cover {
      margin-bottom: 30px;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  
      .cover-image {
        width: 100%;
        max-height: 400px;
        object-fit: cover;
      }
    }
  
    .content-body {
      line-height: 1.8;
      color: #333;
      margin-bottom: 40px;
  
      ::v-deep img {
        max-width: 100%;
        border-radius: 6px;
        margin: 10px 0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      }
  
      ::v-deep p {
        margin-bottom: 1.5em;
      }
    }
  
    .interaction-section {
      border-top: 1px solid #ebeef5;
      padding-top: 20px;
      display: flex;
      justify-content: center;
  
      .like-button {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 20px;
        border-radius: 20px;
        background-color: #f5f7fa;
        cursor: pointer;
        transition: all 0.3s;
        user-select: none;
  
        i {
          font-size: 18px;
          color: #909399;
          transition: all 0.3s;
  
          &.liked {
            color: #F56C6C;
          }
        }
  
        span {
          font-size: 14px;
          color: #606266;
        }
  
        &:hover {
          background-color: #f0f2f5;
          transform: translateY(-2px);
  
          i:not(.liked) {
            color: #F56C6C;
          }
        }
      }
    }
  }
  
  @media (max-width: 768px) {
    .content-detail-container {
      padding: 10px;
  
      .content-main {
        padding: 20px;
      }
  
      .content-header {
        .content-title {
          font-size: 20px;
        }
      }
  
      .content-cover {
        margin-bottom: 20px;
      }
    }
  }
  </style>