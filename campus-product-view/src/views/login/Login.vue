<template>
    <div class="login-container">
        <div class="login-card">
            <!-- Left Banner Section -->
            <div class="banner-section">
                <img src="/bag.png" alt="Seat Reservation System" class="banner-image">
                <div class="banner-overlay">
                    <h3 class="welcome-text">欢迎使用</h3>
                    <h1 class="system-title">校园二手交易平台</h1>
                    <p class="system-description">高效管理 · 便捷预约 · 智能分配</p>
                </div>
            </div>

            <!-- Right Login Form -->
            <div class="form-section">
                <div class="form-header">
                    <h2 class="login-title">用户登录</h2>
                    <p class="login-subtitle">请输入您的账号密码登录系统</p>
                </div>

                <div class="form-body">
                    <div class="input-group">
                        <input 
                            v-model="act" 
                            class="form-input" 
                            placeholder="请输入账号" 
                            type="text"
                            @keyup.enter="login"
                        >
                        <span class="input-icon"><i class="el-icon-user"></i></span>
                    </div>

                    <div class="input-group">
                        <input 
                            v-model="pwd" 
                            class="form-input" 
                            placeholder="请输入密码" 
                            type="password"
                            @keyup.enter="login"
                        >
                        <span class="input-icon"><i class="el-icon-lock"></i></span>
                    </div>

                    <button class="login-button" @click="login">
                        登 录
                    </button>

                    <div class="form-footer">
                        <span class="register-text">
                            还没有账号？
                            <span class="register-link" @click="toDoRegister">立即注册</span>
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
import { setToken } from "@/utils/storage.js";
import md5 from 'js-md5';

export default {
    name: "Login",
    data() {
        return {
            act: '',
            pwd: ''
        }
    },
    methods: {
        toDoRegister() {
            this.$router.push('/register');
        },
        async login() {
            if (!this.act || !this.pwd) {
                this.$swal.fire({
                    title: '填写校验',
                    text: '账号或密码不能为空',
                    icon: 'error',
                    showConfirmButton: false,
                    timer: DELAY_TIME,
                });
                return;
            }
            const hashedPwd = md5(md5(this.pwd));
            const paramDTO = { userAccount: this.act, userPwd: hashedPwd };
            try {
                const { data } = await request.post(`user/login`, paramDTO);
                if (data.code !== 200) {
                    this.$swal.fire({
                        title: '登录失败',
                        text: data.msg,
                        icon: 'error',
                        showConfirmButton: false,
                        timer: DELAY_TIME,
                    });
                    return;
                }
                setToken(data.data.token);
                setTimeout(() => {
                    const { role } = data.data;
                    sessionStorage.setItem('role', role);
                    this.navigateToRole(role);
                }, DELAY_TIME);
            } catch (error) {
                console.error('登录请求错误:', error);
                this.$message.error('登录请求出错，请重试！');
            }
        },
        navigateToRole(role) {
            switch (role) {
                case 1:
                    this.$router.push('/admin');
                    break;
                case 2:
                    this.$router.push('/user');
                    break;
                default:
                    console.warn('未知的角色类型:', role);
                    break;
            }
        },
    }
};
</script>

<style lang="scss" scoped>
.login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background-color: #f5f7fa;
    background-image: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
    padding: 20px;
}

.login-card {
    display: flex;
    width: 900px;
    height: 550px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    overflow: hidden;
}

.banner-section {
    flex: 1;
    position: relative;
    background: linear-gradient(135deg, #3a7bd5 0%, #00d2ff 100%);
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

.login-title {
    font-size: 28px;
    color: #303133;
    margin-bottom: 10px;
    font-weight: 600;
}

.login-subtitle {
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
    margin-bottom: 25px;
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

.login-button {
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

.register-text {
    font-size: 14px;
    color: #909399;
}

.register-link {
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
    .login-card {
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