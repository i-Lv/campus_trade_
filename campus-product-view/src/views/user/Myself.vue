<template>
    <div class="user-center">
        <!-- 用户信息头部 -->
        <div class="user-header">
            <div class="user-avatar">
                <img :src="userInfo.userAvatar || defaultAvatar" alt="用户头像">
                <el-upload class="avatar-uploader"
                    action="http://localhost:21090/api/campus-product-sys/v1.0/file/upload" :show-file-list="false"
                    :on-success="handleAvatarSuccess" :before-upload="beforeAvatarUpload">
                    <i class="el-icon-camera-solid"></i>
                </el-upload>
            </div>
        </div>

        <!-- 主内容区 -->
        <div class="user-main">
            <!-- 左侧导航 -->
            <div class="user-nav">
                <div v-for="(item, index) in navItems" :key="index" class="nav-item"
                    :class="{ 'active': activeNav === item.key }" @click="switchNav(item.key)">
                    <i :class="item.icon"></i>
                    <span>{{ item.title }}</span>
                    <i class="el-icon-arrow-right"></i>
                </div>
            </div>

            <!-- 右侧内容 -->
            <div class="user-content">
                <transition name="fade" mode="out-in">
                    <keep-alive>
                        <component :is="currentComponent"></component>
                    </keep-alive>
                </transition>
            </div>
        </div>
    </div>
</template>

<script>
import ResetPwd from '@/views/user/ResetPwd'
import Self from '@/views/user/Self'

export default {
    components: { ResetPwd, Self },
    data() {
        return {
            defaultAvatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png', // 使用Element UI提供的默认头像
            userInfo: {},
            activeGoods: {},
            activeNav: 'profile',
            navItems: [
                { key: 'profile', title: '个人资料', icon: 'el-icon-user', component: 'Self' },
                { key: 'security', title: '账户安全', icon: 'el-icon-lock', component: 'ResetPwd' },
                { key: 'logout', title: '退出登录', icon: 'el-icon-switch-button', component: null }
            ]
        }
    },
    computed: {
        currentComponent() {
            const item = this.navItems.find(item => item.key === this.activeNav);
            return item ? item.component : null;
        }
    },
    created() {
        this.fetchUserInfo()
    },
    methods: {
        async fetchUserInfo() {
            try {
                const res = await this.$axios.get('/user/auth')
                if (res.data.code === 200) {
                    this.userInfo = res.data.data;

                }
            } catch (error) {
                console.error('获取用户信息失败:', error)
            }
        },

        async updateUserInfo() {
            try {
                const res = await this.$axios.put('/user/update',this.userInfo)
                if (res.data.code === 200) {
                    
                }
            } catch (error) {
                console.error('获取用户信息失败:', error)
            }
        },

        switchNav(navKey) {
            if (navKey === 'logout') {
                this.logout()
                return
            }
            this.activeNav = navKey
        },

        logout() {
            this.$confirm('确定要退出登录吗?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                sessionStorage.clear()
                this.$router.push('/login')
                this.$message.success('已退出登录')
            })
        },

        handleAvatarSuccess(res) {
            if (res.code === 200) {
                this.userInfo.userAvatar = res.data
                this.$notify.success({
                    duration: 1000,
                    title: '头像上传',
                    message: '上传成功'
                });
                this.updateUserInfo();
                this.fetchUserInfo();
            }
        },

        beforeAvatarUpload(file) {
            const isJPG = file.type === 'image/jpeg' || file.type === 'image/png'
            const isLt2M = file.size / 1024 / 1024 < 2

            if (!isJPG) {
                this.$message.error('上传头像图片只能是 JPG/PNG 格式!')
            }
            if (!isLt2M) {
                this.$message.error('上传头像图片大小不能超过 2MB!')
            }
            return isJPG && isLt2M
        }
    }
}
</script>

<style lang="scss" scoped>
.user-center {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.user-header {
    display: flex;
    align-items: center;
    padding: 30px;
    background: linear-gradient(135deg, #409EFF, #66b1ff);
    border-radius: 12px;
    color: #fff;
    margin-bottom: 30px;
    position: relative;
    overflow: hidden;

    &::before {
        content: '';
        position: absolute;
        top: -50px;
        right: -50px;
        width: 200px;
        height: 200px;
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 50%;
    }
}

.user-avatar {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    border: 4px solid rgba(255, 255, 255, 0.3);
    position: relative;
    margin-right: 30px;

    img {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        object-fit: cover;
    }

    .avatar-uploader {
        position: absolute;
        bottom: 0;
        right: 0;
        background-color: #fff;
        width: 32px;
        height: 32px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        cursor: pointer;

        i {
            color: #409EFF;
            font-size: 16px;
        }
    }
}

.user-info {
    flex: 1;

    h2 {
        font-size: 24px;
        margin: 0 0 5px;
        font-weight: 600;
    }

    .user-id {
        font-size: 14px;
        opacity: 0.8;
        margin: 0 0 15px;
    }
}

.user-stats {
    display: flex;
    gap: 30px;

    .stat-item {
        display: flex;
        flex-direction: column;
        align-items: center;

        .stat-value {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 14px;
            opacity: 0.9;
        }
    }
}

.user-main {
    display: flex;
    gap: 20px;
}

.user-nav {
    width: 240px;
    background-color: #fff;
    border-radius: 8px;
    padding: 10px 0;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);

    .nav-item {
        display: flex;
        align-items: center;
        padding: 15px 20px;
        cursor: pointer;
        transition: all 0.3s;
        border-left: 3px solid transparent;

        i:first-child {
            margin-right: 10px;
            font-size: 18px;
            color: #606266;
        }

        span {
            flex: 1;
            font-size: 16px;
            color: #303133;
        }

        i:last-child {
            color: #909399;
            font-size: 14px;
        }

        &:hover {
            background-color: #f5f7fa;
            border-left-color: #409EFF;

            i:first-child,
            span {
                color: #409EFF;
            }
        }

        &.active {
            background-color: #ecf5ff;
            border-left-color: #409EFF;

            i:first-child,
            span {
                color: #409EFF;
            }
        }
    }
}

.user-content {
    flex: 1;
    min-height: 600px;
    background-color: #fff;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.3s;
}

.fade-enter,
.fade-leave-to {
    opacity: 0;
}

@media (max-width: 768px) {
    .user-header {
        flex-direction: column;
        text-align: center;
        padding: 20px;

        .user-avatar {
            margin-right: 0;
            margin-bottom: 15px;
        }
    }

    .user-stats {
        justify-content: center;
        gap: 15px;
    }

    .user-main {
        flex-direction: column;
    }

    .user-nav {
        width: 100%;
        margin-bottom: 15px;
    }
}
</style>