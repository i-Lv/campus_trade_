<template>
    <div class="register-container">
        <div class="register-card">
            <!-- Left Banner Section -->
            <div class="banner-section">
                <img src="/bag.png" alt="Seat Reservation System" class="banner-image">
                <div class="banner-overlay">
                    <h3 class="welcome-text">加入我们</h3>
                    <h1 class="system-title">校园二手交易平台</h1>
                    <p class="system-description">立即注册 · 享受便捷交易服务</p>
                </div>
            </div>

            <!-- Right Registration Form -->
            <div class="form-section">
                <div class="form-header">
                    <h2 class="register-title">用户注册</h2>
                    <p class="register-subtitle">创建您的账户开始交易</p>
                </div>

                <div class="form-body">
                    <div class="input-group">
                        <input 
                            v-model="act" 
                            class="form-input" 
                            placeholder="请输入账号" 
                            type="text"
                            @keyup.enter="registerFunc"
                        >
                        <span class="input-icon"><i class="el-icon-user"></i></span>
                    </div>

                    <div class="input-group">
                        <input 
                            v-model="name" 
                            class="form-input" 
                            placeholder="请输入用户名" 
                            type="text"
                            @keyup.enter="registerFunc"
                        >
                        <span class="input-icon"><i class="el-icon-edit"></i></span>
                    </div>

                    <div class="input-group">
                        <input 
                            v-model="pwd" 
                            class="form-input" 
                            placeholder="请输入密码" 
                            type="password"
                            @keyup.enter="registerFunc"
                        >
                        <span class="input-icon"><i class="el-icon-lock"></i></span>
                    </div>

                    <div class="input-group">
                        <input 
                            v-model="pwdConfirm" 
                            class="form-input" 
                            placeholder="请确认密码" 
                            type="password"
                            @keyup.enter="registerFunc"
                        >
                        <span class="input-icon"><i class="el-icon-check"></i></span>
                    </div>

                    <button class="register-button" @click="registerFunc">
                        注 册
                    </button>

                    <div class="form-footer">
                        <span class="login-text">
                            已有账户？
                            <span class="login-link" @click="toDoLogin">立即登录</span>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
const DELAY_TIME = 1300;
import request from "@/utils/request.js";
import md5 from 'js-md5';

export default {
    name: "Register",
    data() {
        return {
            act: '', // 账号
            pwd: '', // 密码
            pwdConfirm: '', // 确认密码
            name: '' // 用户名
        }
    },
    methods: {
        toDoLogin() {
            this.$router.push('/login');
        },
        async registerFunc() {
            if (!this.act || !this.pwd || !this.pwdConfirm || !this.name) {
                this.$notify.info({
                    title: '填写校验',
                    message: '账号、密码和用户名不能为空',
                    duration: 1000,
                });
                return;
            }
            if (this.pwd !== this.pwdConfirm) {
                this.$swal.fire({
                    title: '填写校验',
                    text: '两次输入的密码不一致',
                    icon: 'error',
                    showConfirmButton: false,
                    timer: DELAY_TIME,
                });
                return;
            }
            const hashedPwd = md5(md5(this.pwd));
            const paramDTO = { 
                userAccount: this.act, 
                userPwd: hashedPwd, 
                userName: this.name 
            };
            try {
                const { data } = await request.post(`user/register`, paramDTO);
                if (data.code !== 200) {
                    this.$swal.fire({
                        title: '注册失败',
                        text: data.msg,
                        icon: 'error',
                        showConfirmButton: false,
                        timer: DELAY_TIME,
                    });
                    return;
                }
                this.$swal.fire({
                    title: '注册成功',
                    text: '即将跳转到登录页面...',
                    icon: 'success',
                    showConfirmButton: false,
                    timer: DELAY_TIME,
                });
                setTimeout(() => {
                    this.$router.push('/login');
                }, DELAY_TIME);
            } catch (error) {
                console.error('注册请求错误:', error);
                this.$notify.error({
                    title: '注册错误',
                    message: '注册过程中出现错误，请稍后重试',
                    duration: 2000,
                });
            }
        }
    }
};
</script>

<style lang="scss" scoped>
.register-container {
    display: flex;
    justify-content: center;
    align-items: center;
    box-sizing: border-box;
    min-height: 100vh;
    background-color: #f5f7fa;
    background-image: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
    padding: 20px;
}

.register-card {
    display: flex;
    width: 900px;
    height: 600px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    overflow: hidden;
}

.banner-section {
    flex: 1;
    position: relative;
    background: linear-gradient(135deg, #e9d787 0%, #90de3c 100%);
}

.banner-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    opacity: 0.8;
}

.banner-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: white;
    padding: 40px;
    text-align: center;
    background: rgba(0, 0, 0, 0.3);
}

.welcome-text {
    font-size: 24px;
    margin-bottom: 10px;
    font-weight: 300;
}

.system-title {
    font-size: 36px;
    margin: 0 0 15px 0;
    font-weight: 600;
}

.system-description {
    font-size: 16px;
    opacity: 0.9;
}

.form-section {
    flex: 1;
    padding: 60px 50px;
    display: flex;
    flex-direction: column;
}

.form-header {
    margin-bottom: 40px;
    text-align: center;
}

.register-title {
    font-size: 28px;
    color: #303133;
    margin-bottom: 10px;
    font-weight: 600;
}

.register-subtitle {
    font-size: 14px;
    color: #909399;
    margin: 0;
}

.form-body {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.input-group {
    position: relative;
    margin-bottom: 20px;
}

.form-input {
    width: 100%;
    box-sizing: border-box;
    height: 50px;
    padding: 0 20px 0 45px;
    border: 1px solid #dcdfe6;
    border-radius: 6px;
    font-size: 14px;
    color: #606266;
    transition: border-color 0.3s;
    
    &:focus {
        outline: none;
        border-color: #409eff;
        box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.1);
    }
    
    &::placeholder {
        color: #c0c4cc;
    }
}

.input-icon {
    position: absolute;
    left: 15px;
    top: 50%;
    transform: translateY(-50%);
    color: #c0c4cc;
    font-size: 16px;
}

.register-button {
    width: 100%;
    height: 50px;
    background: linear-gradient(135deg, #3a7bd5 0%, #00d2ff 100%);
    color: white;
    border: none;
    border-radius: 6px;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s;
    margin-top: 10px;
    
    &:hover {
        opacity: 0.9;
        box-shadow: 0 5px 15px rgba(58, 123, 213, 0.3);
    }
    
    &:active {
        transform: translateY(1px);
    }
}

.form-footer {
    margin-top: auto;
    text-align: center;
    padding-top: 20px;
}

.login-text {
    font-size: 14px;
    color: #909399;
}

.login-link {
    color: #3a7bd5;
    cursor: pointer;
    font-weight: 500;
    transition: color 0.3s;
    
    &:hover {
        color: #00d2ff;
        text-decoration: underline;
    }
}

@media (max-width: 768px) {
    .register-card {
        flex-direction: column;
        height: auto;
        width: 100%;
    }
    
    .banner-section {
        height: 200px;
    }
    
    .form-section {
        padding: 40px 30px;
    }
}
</style>