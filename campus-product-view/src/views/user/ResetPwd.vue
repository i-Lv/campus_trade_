<template>
    <div class="password-reset-container">
      <!-- 密码修改表单 -->
      <div class="password-form">
        <!-- 原始密码 -->
        <div class="form-item">
          <label class="form-label">*原始密码</label>
          <el-input
            v-model="oldPwd"
            type="password"
            placeholder="请输入原始密码"
            show-password
            clearable
            class="password-input"
          ></el-input>
        </div>
  
        <!-- 新密码 -->
        <div class="form-item">
          <label class="form-label">*新密码</label>
          <el-input
            v-model="newPwd"
            type="password"
            placeholder="请输入新密码"
            show-password
            clearable
            class="password-input"
          ></el-input>
        </div>
  
        <!-- 确认密码 -->
        <div class="form-item">
          <label class="form-label">*确认密码</label>
          <el-input
            v-model="againPwd"
            type="password"
            placeholder="请再次输入新密码"
            show-password
            clearable
            class="password-input"
            @keyup.enter.native="postInfo"
          ></el-input>
        </div>
  
        <!-- 密码强度提示 -->
        <div class="password-tips">
          <p>密码要求：</p>
          <ul>
            <li>长度8-20个字符</li>
            <li>包含字母和数字</li>
            <li>建议使用特殊字符增加安全性</li>
          </ul>
        </div>
  
        <!-- 提交按钮 -->
        <div class="submit-btn">
          <el-button
            type="primary"
            round
            @click="postInfo"
            :loading="submitting"
            :disabled="!formValid"
          >
            立即修改
          </el-button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { clearToken } from "@/utils/storage";
  
  export default {
    name: "ResetPwd",
    data() {
      return {
        oldPwd: "",
        newPwd: "",
        againPwd: "",
        submitting: false
      };
    },
    computed: {
      formValid() {
        return (
          this.oldPwd.length >= 6 &&
          this.newPwd.length >= 8 &&
          this.againPwd.length >= 8 &&
          this.newPwd === this.againPwd
        );
      }
    },
    methods: {
      // 提交密码修改
      async postInfo() {
        if (!this.validatePassword()) {
          return;
        }
  
        this.submitting = true;
  
        try {
          const userUpdatePwdDTO = {
            oldPwd: this.$md5(this.$md5(this.oldPwd)),
            newPwd: this.$md5(this.$md5(this.newPwd)),
            againPwd: this.$md5(this.$md5(this.againPwd))
          };
  
          const { data } = await this.$axios.put("/user/updatePwd", userUpdatePwdDTO);
  
          this.$notify({
            duration: 2000,
            title: "修改密码",
            message: data.code === 200 ? "修改成功，请重新登录" : data.msg,
            type: data.code === 200 ? "success" : "error"
          });
  
          if (data.code === 200) {
            clearToken();
            this.$router.push("/login");
          }
        } catch (error) {
          console.error("密码修改失败:", error);
          this.$notify.error({
            title: "错误",
            message: "密码修改失败，请稍后重试"
          });
        } finally {
          this.submitting = false;
        }
      },
  
      // 密码验证
      validatePassword() {
  
        if (this.newPwd.length < 8) {
          this.$message.warning("新密码长度不能少于8位");
          return false;
        }
  
        if (this.newPwd !== this.againPwd) {
          this.$message.warning("两次输入的新密码不一致");
          return false;
        }
  
        // 密码强度验证
        const hasNumber = /\d/.test(this.newPwd);
        const hasLetter = /[a-zA-Z]/.test(this.newPwd);
  
        if (!hasNumber || !hasLetter) {
          this.$message.warning("密码应包含字母和数字");
          return false;
        }
  
        return true;
      }
    }
  };
  </script>
  
  <style scoped lang="scss">
  .password-reset-container {
    max-width: 500px;
    margin: 0 auto;
    padding: 30px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  }
  
  .form-label {
    display: block;
    margin-bottom: 8px;
    font-size: 14px;
    color: #606266;
    font-weight: 500;
  }
  
  .form-item {
    margin-bottom: 20px;
  }
  
  .password-input {
    width: 100%;
  }
  
  .password-tips {
    margin: 20px 0;
    padding: 10px;
    background-color: #f8f8f8;
    border-radius: 4px;
    font-size: 13px;
    color: #909399;
  
    p {
      margin-bottom: 5px;
      font-weight: 500;
    }
  
    ul {
      margin: 0;
      padding-left: 20px;
    }
  }
  
  .submit-btn {
    text-align: center;
    margin-top: 30px;
  
    .el-button {
      width: 200px;
      padding: 12px 0;
      font-size: 16px;
    }
  }
  </style>