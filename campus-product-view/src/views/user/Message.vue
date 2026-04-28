<template>
  <div class="notification-container">
    <!-- 顶部操作栏 -->
    <div class="notification-header">
      <h2 class="title">我的消息</h2>
      <el-button type="text" @click="messageIsRead" class="clear-btn">
        <i class="el-icon-s-open"></i>
        <span>全部标记为已读</span>
      </el-button>
    </div>

    <!-- 消息列表 -->
    <div class="notification-list">
      <transition-group name="notification" tag="div">
        <div v-for="(message, index) in messageList" :key="message.id" class="notification-card"
          :class="{ 'unread': !message.isRead }" @click="toggleRead(message)">
          <div class="notification-badge">
            <div class="badge-icon" :class="{ 'unread': !message.isRead }">
              <i class="el-icon-message-solid"></i>
            </div>
          </div>

          <div class="notification-content">
            <div class="message-text">{{ message.content }}</div>
            <div class="message-meta">
              <span class="message-time">{{ message.createTime }}</span>
              <span class="message-status">
                {{ message.isRead ? '已读' : '未读' }}
              </span>
            </div>
          </div>

          <div class="notification-actions">
            <el-button type="text" icon="el-icon-delete" @click.stop="deleteMessage(message, index)"
              class="delete-btn"></el-button>
          </div>
        </div>
      </transition-group>

      <div v-if="messageList.length === 0" class="empty-state">
        <el-empty description="暂无消息通知"></el-empty>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Message',
  data() {
    return {
      messageList: []
    }
  },
  created() {
    this.fetchMessage();
  },
  methods: {
    async messageIsRead() {
      try {
        const response = await this.$axios.post(`/message/setRead`);
        if (response.data.code === 200) {
          this.$message.success(response.data.msg);
          this.fetchMessage();
        }
      } catch (error) {
        console.error("消息已读设置异常：", error);
      }
    },

    async fetchMessage() {
      try {
        const response = await this.$axios.post(`/message/queryUser`, {});
        if (response.data.code === 200) {
          this.messageList = response.data.data;
        }
      } catch (error) {
        console.error("查询消息异常：", error);
      }
    },

    async toggleRead(message) {
      if (!message.isRead) {
        try {
          await this.$axios.post(`/message/setSingleRead/${message.id}`);
          message.isRead = true;
        } catch (error) {
          console.error("标记已读异常：", error);
        }
      }
    },

    async deleteMessage(message, index) {
      try {
        await this.$confirm('确定要删除这条消息吗?', '删除确认', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        });
        const ids = [message.id];
        const response = await this.$axios.post(`/message/batchDelete`, ids);
        if (response.data.code === 200) {
          this.messageList.splice(index, 1);
          this.$message.success('删除成功');
        }
      } catch (error) {
        if (error !== 'cancel') {
          console.error("删除消息异常：", error);
        }
      }
    }
  }
};
</script>

<style scoped lang="scss">
.notification-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  background-color: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);

  .notification-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px solid #f0f0f0;

    .title {
      font-size: 22px;
      color: #333;
      margin: 0;
    }

    .clear-btn {
      color: #909399;
      transition: all 0.3s;

      &:hover {
        color: #409EFF;
        transform: translateY(-2px);
      }

      i {
        margin-right: 5px;
      }
    }
  }

  .notification-list {
    .notification-move {
      transition: transform 0.5s;
    }

    .notification-enter-active,
    .notification-leave-active {
      transition: all 0.5s;
    }

    .notification-enter,
    .notification-leave-to {
      opacity: 0;
      transform: translateX(30px);
    }
  }

  .notification-card {
    display: flex;
    align-items: center;
    padding: 16px;
    margin-bottom: 12px;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    transition: all 0.3s;
    cursor: pointer;
    position: relative;
    overflow: hidden;

    &:hover {
      transform: translateY(-3px);
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);

      .notification-actions {
        opacity: 1;
      }
    }

    &.unread {
      background-color: rgba(64, 158, 255, 0.05);
      border-left: 4px solid #409EFF;

      &::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 3px;
        height: 100%;
        background-color: #409EFF;
      }
    }

    .notification-badge {
      margin-right: 16px;

      .badge-icon {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #f0f2f5;
        color: #909399;
        transition: all 0.3s;

        i {
          font-size: 18px;
        }

        &.unread {
          background-color: #409EFF;
          color: #fff;
          animation: pulse 1.5s infinite;
        }
      }
    }

    .notification-content {
      flex: 1;

      .message-text {
        font-size: 16px;
        color: #333;
        margin-bottom: 6px;
        line-height: 1.5;
      }

      .message-meta {
        display: flex;
        align-items: center;

        .message-time {
          font-size: 12px;
          color: #909399;
          margin-right: 10px;
        }

        .message-status {
          font-size: 12px;
          padding: 2px 6px;
          border-radius: 10px;
          background-color: #f0f2f5;
          color: #909399;

          .unread & {
            background-color: rgba(64, 158, 255, 0.1);
            color: #409EFF;
          }
        }
      }
    }

    .notification-actions {
      opacity: 0;
      transition: opacity 0.3s;

      .delete-btn {
        color: #f56c6c;
        font-size: 16px;

        &:hover {
          transform: scale(1.2);
        }
      }
    }
  }

  .empty-state {
    padding: 40px 0;
  }
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(64, 158, 255, 0.4);
  }

  70% {
    box-shadow: 0 0 0 10px rgba(64, 158, 255, 0);
  }

  100% {
    box-shadow: 0 0 0 0 rgba(64, 158, 255, 0);
  }
}

@media (max-width: 768px) {
  .notification-container {
    padding: 15px;

    .notification-card {
      padding: 12px;

      .notification-badge {
        margin-right: 12px;

        .badge-icon {
          width: 36px;
          height: 36px;

          i {
            font-size: 16px;
          }
        }
      }

      .notification-content {
        .message-text {
          font-size: 14px;
        }
      }
    }
  }
}
</style>