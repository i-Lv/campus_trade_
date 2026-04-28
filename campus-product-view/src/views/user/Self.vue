<template>
    <div class="user-profile-container">
      <!-- 头像上传区域 -->
      <div class="avatar-section">
        <label class="section-label">*头像</label>
        <el-upload 
          class="avatar-uploader" 
          action="http://localhost:21090/api/campus-product-sys/v1.0/file/upload" 
          :show-file-list="false"
          :on-success="handleAvatarSuccess">
          <img v-if="userAvatar" :src="userAvatar" class="avatar-image">
          <i v-else class="el-icon-plus avatar-uploader-icon"></i>
        </el-upload>
      </div>
  
      <!-- 基本信息区域 -->
      <div class="info-section">
        <div class="form-item">
          <label class="section-label">*昵称</label>
          <el-input 
            v-model="userInfo.userName" 
            placeholder="请输入昵称"
            class="info-input"
            clearable>
          </el-input>
        </div>
  
        <div class="form-item">
          <label class="section-label">*邮箱</label>
          <el-input 
            v-model="userInfo.userEmail" 
            placeholder="请输入邮箱"
            class="info-input"
            clearable>
          </el-input>
        </div>
      </div>
  
      <!-- 账号状态区域 -->
      <div class="status-section">
        <div class="status-item">
          <div class="status-header">
            <label class="section-label">*账号状态</label>
            <el-tooltip effect="dark" content="一经封号，不可登录，不可使用系统功能" placement="right">
              <i class="el-icon-info info-icon"></i>
            </el-tooltip>
          </div>
          <div class="status-value" :class="{'banned': userInfo.isLogin}">
            <i :class="userInfo.isLogin ? 'el-icon-warning-outline' : 'el-icon-circle-check'"></i>
            {{ userInfo.isLogin ? '已被封禁' : '正常' }}
          </div>
        </div>
  
        <div class="status-item">
          <div class="status-header">
            <label class="section-label">*留言状态</label>
            <el-tooltip effect="dark" content="禁言后，互动功能受限" placement="right">
              <i class="el-icon-info info-icon"></i>
            </el-tooltip>
          </div>
          <div class="status-value" :class="{'banned': userInfo.isWord}">
            <i :class="userInfo.isWord ? 'el-icon-warning-outline' : 'el-icon-circle-check'"></i>
            {{ userInfo.isWord ? '已被封禁' : '正常' }}
          </div>
        </div>
      </div>
  
      <!-- 提交按钮 -->
      <div class="submit-section">
        <el-button 
          type="primary" 
          @click="postInfo" 
          class="submit-button"
          :loading="submitting">
          立即修改
        </el-button>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "Self",
    data() {
      return {
        userInfo: {
          userName: '',
          userEmail: '',
          isLogin: false,
          isWord: false
        },
        userAvatar: '',
        submitting: false
      }
    },
    created() {
      this.auth();
    },
    methods: {
      // 提交个人信息修改
      async postInfo() {
        this.submitting = true;
        
        try {
          const userUpdateDTO = {
            userAvatar: this.userAvatar,
            userName: this.userInfo.userName,
            userEmail: this.userInfo.userEmail
          }
          
          const { data } = await this.$axios.put('/user/update', userUpdateDTO);
          
          this.$notify({
            position: 'bottom-right',
            duration: 1000,
            title: '编辑个人信息',
            message: data.code === 200 ? '编辑成功' : '编辑失败',
            type: data.code === 200 ? 'success' : 'error'
          });
          
          if (data.code === 200) {
            await this.auth();
          }
        } catch (error) {
          console.error('修改信息失败:', error);
        } finally {
          this.submitting = false;
        }
      },
      
      // 头像上传
      handleAvatarSuccess(res) {
        this.$notify({
          duration: 1500,
          title: '头像上传',
          message: res.code === 200 ? '上传成功' : '上传失败',
          type: res.code === 200 ? 'success' : 'error'
        });
        
        if (res.code === 200) {
          this.userAvatar = res.data;
        }
      },
      
      // 获取用户信息
      async auth() {
        try {
          const { data } = await this.$axios.get('/user/auth');
          
          if (data.code !== 200) {
            this.$router.push('/');
          } else {
            this.userInfo = data.data;
            this.userAvatar = data.data.userAvatar;
          }
        } catch (error) {
          console.error('获取用户信息失败:', error);
          this.$router.push('/');
        }
      }
    }
  };
  </script>
  
  <style scoped lang="scss">
  .user-profile-container {
    max-width: 500px;
    margin: 0 auto;
    padding: 20px;
  }
  
  .section-label {
    display: block;
    margin-bottom: 8px;
    font-size: 14px;
    color: #606266;
    font-weight: 500;
  }
  
  .avatar-section {
    margin-bottom: 20px;
    text-align: center;
    
    .avatar-uploader {
      display: inline-block;
      
      .avatar-image {
        width: 88px;
        height: 88px;
        border-radius: 50%;
        object-fit: cover;
      }
      
      .avatar-uploader-icon {
        font-size: 28px;
        color: #8c939d;
        width: 88px;
        height: 88px;
        line-height: 88px;
        text-align: center;
        border: 1px dashed #d9d9d9;
        border-radius: 50%;
      }
    }
  }
  
  .info-section {
    margin-bottom: 20px;
    
    .form-item {
      margin-bottom: 20px;
      
      .info-input {
        width: 100%;
      }
    }
  }
  
  .status-section {
    margin-bottom: 30px;
    
    .status-item {
      margin-bottom: 20px;
      
      .status-header {
        display: flex;
        align-items: center;
        margin-bottom: 8px;
        
        .info-icon {
          margin-left: 5px;
          color: #909399;
          cursor: pointer;
        }
      }
      
      .status-value {
        font-size: 14px;
        color: #67C23A;
        
        i {
          margin-right: 6px;
        }
        
        &.banned {
          color: #F56C6C;
          text-decoration: underline;
          text-decoration-style: dashed;
        }
      }
    }
  }
  
  .submit-section {
    text-align: center;
    
    .submit-button {
      width: 200px;
      padding: 12px 0;
      font-size: 16px;
      border-radius: 20px;
    }
  }
  </style>