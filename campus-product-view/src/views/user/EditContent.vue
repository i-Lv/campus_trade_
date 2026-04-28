<template>
    <div class="content-update-container">
      <!-- 主标题 -->
      <h1 class="update-title">编辑动态</h1>
  
      <!-- 两栏布局 -->
      <div class="update-layout">
        <!-- 左侧表单区域 -->
        <div class="form-section">
          <!-- 动态基本信息卡片 -->
          <div class="form-card">
            <h2 class="card-title">动态基本信息</h2>
  
            <div class="form-group">
              <label class="form-label">标题</label>
              <el-input v-model="content.name" placeholder="请输入标题" class="form-input" clearable></el-input>
            </div>
          </div>
        </div>
  
        <!-- 右侧上传和编辑区域 -->
        <div class="upload-section">
          <div class="form-card">
            <h2 class="card-title">封面图片</h2>
            <el-upload 
              class="avatar-uploader" 
              action="http://localhost:21090/api/campus-product-sys/v1.0/file/upload"
              :show-file-list="false" 
              :on-success="handleAvatarSuccess">
              <img v-if="content.cover" :src="content.cover" class="avatar">
              <i v-else class="el-icon-plus avatar-uploader-icon"></i>
            </el-upload>
          </div>
  
          <!-- 动态详情编辑器 -->
          <div class="form-card">
            <h2 class="card-title">动态详情</h2>
            <Editor height="400px" :receiveContent="content.detail" @on-receive="onReceive" />
          </div>
  
          <!-- 操作按钮组 -->
          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="updateContent" 
              class="update-button" 
              :loading="updating">
              保存修改
            </el-button>
            <el-button 
              @click="cancelUpdate" 
              class="cancel-button">
              取消
            </el-button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import Editor from "@/components/Editor"
  
  export default {
    components: { Editor },
    name: 'UpdateContent',
    data() {
      return {
        updating: false,
        content: {
          id: null,
          name: '',
          detail: '',
          cover: ''
        }
      }
    },
    created() {
      this.fetchContentData();
    },
    methods: {
      async fetchContentData() {
        try {
          const contentId = this.$route.query.id;
          if (!contentId) {
            this.$message.error('缺少内容ID');
            return this.$router.back();
          }
          
          const res = await this.$axios.post('/content/query', { id: contentId });
          if (res.data.code === 200) {
            this.content = {
              id: res.data.data[0].id,
              name: res.data.data[0].name,
              detail: res.data.data[0].detail,
              cover: res.data.data[0].cover
            };
          } else {
            this.$message.error(res.data.msg || '获取内容失败');
            this.$router.back();
          }
        } catch (error) {
          console.error("获取内容异常:", error);
          this.$message.error('获取内容失败');
          this.$router.back();
        }
      },
  
      handleAvatarSuccess(res) {
        if (res.code === 200) {
          this.content.cover = res.data;
          this.$message.success('封面图片上传成功');
        } else {
          this.$message.error('上传失败');
        }
      },
  
      async updateContent() {
        if (!this.content.name) {
          this.$message.warning('请输入标题');
          return;
        }
        
        if (!this.content.cover) {
          this.$message.warning('请上传封面图片');
          return;
        }
  
        this.updating = true;
        try {
          const res = await this.$axios.put('/content/update', this.content);
          if (res.data.code === 200) {
            this.$message.success('更新成功');
            this.$router.push('/mycontent');
          } else {
            this.$message.warning(res.data.msg || '更新失败');
          }
        } catch (error) {
          console.error("更新动态异常:", error);
          this.$message.error('更新失败');
        } finally {
          this.updating = false;
        }
      },
  
      cancelUpdate() {
        this.$router.back();
      },
  
      onReceive(detail) {
        this.content.detail = detail;
      }
    }
  }
  </script>
  
  <style scoped lang="scss">
  .content-update-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
  
    .update-title {
      font-size: 24px;
      color: #333;
      margin-bottom: 30px;
      text-align: center;
      font-weight: 600;
    }
  
    .update-layout {
      display: flex;
      gap: 20px;
  
      .form-section {
        flex: 1;
        min-width: 400px;
      }
  
      .upload-section {
        flex: 1;
        min-width: 400px;
      }
    }
  
    .form-card {
      background-color: #fff;
      border-radius: 12px;
      padding: 20px;
      margin-bottom: 20px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  
      .card-title {
        font-size: 18px;
        color: #333;
        margin-bottom: 20px;
        font-weight: 600;
        position: relative;
        padding-left: 10px;
  
        &::before {
          content: '';
          position: absolute;
          left: 0;
          top: 4px;
          height: 16px;
          width: 4px;
          background-color: #409EFF;
          border-radius: 2px;
        }
      }
    }
  
    .form-group {
      margin-bottom: 20px;
  
      .form-label {
        display: block;
        font-size: 14px;
        color: #606266;
        margin-bottom: 10px;
        font-weight: 500;
      }
  
      .form-input {
        width: 100%;
      }
    }
  
    .avatar-uploader {
      display: flex;
      justify-content: center;
      margin-bottom: 20px;
  
      .avatar {
        width: 200px;
        height: 150px;
        object-fit: cover;
        border-radius: 6px;
      }
  
      .avatar-uploader-icon {
        width: 200px;
        height: 150px;
        line-height: 150px;
        text-align: center;
        border: 1px dashed #d9d9d9;
        border-radius: 6px;
        color: #8c939d;
        font-size: 28px;
        transition: all 0.3s;
  
        &:hover {
          border-color: #409EFF;
        }
      }
    }
  
    .action-buttons {
      display: flex;
      gap: 20px;
      margin-top: 30px;
  
      .update-button {
        flex: 1;
        height: 50px;
        font-size: 16px;
        border-radius: 8px;
        background: linear-gradient(90deg, #409EFF, #66b1ff);
        border: none;
        box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
        transition: all 0.3s;
  
        &:hover {
          transform: translateY(-2px);
          box-shadow: 0 6px 16px rgba(64, 158, 255, 0.4);
        }
  
        &:active {
          transform: translateY(0);
        }
      }
  
      .cancel-button {
        flex: 1;
        height: 50px;
        font-size: 16px;
        border-radius: 8px;
        background: rgba(245, 108, 108, 0.1);
        color: #F56C6C;
        border: none;
        transition: all 0.3s;
  
        &:hover {
          background: rgba(245, 108, 108, 0.2);
        }
      }
    }
  }
  
  @media (max-width: 992px) {
    .update-layout {
      flex-direction: column;
  
      .form-section,
      .upload-section {
        min-width: 100% !important;
      }
    }
  }
  </style>