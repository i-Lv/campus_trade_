<template>
  <div class="user-management-container">
    <!-- 搜索卡片 -->
    <el-card class="search-card" shadow="never">
      <div class="search-content">
        <el-select v-model="userQueryDto.isLogin" placeholder="登录状态" size="medium"
          style="width: 120px; margin-right: 12px;" @change="fetchFreshData" clearable>
          <el-option v-for="item in loginStatuList" :key="item.value" :label="item.label"
            :value="item.value"></el-option>
        </el-select>

        <el-select v-model="userQueryDto.isWord" placeholder="禁言状态" size="medium"
          style="width: 120px; margin-right: 12px;" @change="fetchFreshData" clearable>
          <el-option v-for="item in wordStatuList" :key="item.value" :label="item.label"
            :value="item.value"></el-option>
        </el-select>

        <el-date-picker v-model="searchTime" type="daterange" range-separator="至" start-placeholder="注册开始日期"
          end-placeholder="注册结束日期" size="medium" style="width: 360px; margin-right: 12px;" @change="fetchFreshData"
          value-format="yyyy-MM-dd" :picker-options="pickerOptions"></el-date-picker>

        <el-input v-model="userQueryDto.userName" placeholder="请输入用户名" clearable size="medium" style="width: 220px;"
          @clear="handleFilterClear" @keyup.enter="handleFilter">
          <template #append>
            <el-button type="primary" icon="el-icon-search" @click="handleFilter"></el-button>
          </template>
        </el-input>

        <el-button type="primary" class="customer" icon="el-icon-plus" style="margin-left: 12px;"
          @click="add">新增用户</el-button>
      </div>
    </el-card>

    <!-- 用户卡片容器 -->
    <div class="user-cards-container">
      <el-card v-for="(user, index) in tableData" :key="index" class="user-card" shadow="hover">
        <div class="user-header">
          <el-avatar :src="user.userAvatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'"
            size="medium"></el-avatar>
          <div class="user-info">
            <div class="user-name">{{ user.userName }}</div>
            <div class="user-account">{{ user.userAccount }}</div>
          </div>
        </div>

        <div class="user-details">
          <div class="detail-item">
            <i class="el-icon-message"></i>
            <span>{{ user.userEmail || '未设置' }}</span>
          </div>
          <div class="detail-item">
            <i class="el-icon-time"></i>
            <span>{{ formatTime(user.createTime) }}</span>
          </div>
        </div>

        <div class="user-status">
          <el-tag :type="user.userRole === 1 ? 'danger' : 'success'" size="small">
            {{ user.userRole === 1 ? '管理员' : '用户' }}
          </el-tag>

          <el-tag :type="user.isLogin ? 'danger' : 'success'" size="small">
            {{ user.isLogin ? '已封号' : '账号状态正常' }}
          </el-tag>

          <el-tag :type="user.isWord ? 'warning' : 'success'" size="small">
            {{ user.isWord ? '已禁言' : '留言状态正常' }}
          </el-tag>
        </div>

        <div class="user-actions">
          <el-tooltip content="修改状态" placement="top">
            <el-button type="primary" icon="el-icon-setting" circle size="mini" @click="handleStatus(user)"></el-button>
          </el-tooltip>

          <el-tooltip content="编辑用户" placement="top">
            <el-button type="warning" icon="el-icon-edit" circle size="mini" @click="handleEdit(user)"></el-button>
          </el-tooltip>

          <el-tooltip content="删除用户" placement="top">
            <el-button type="danger" icon="el-icon-delete" circle size="mini" @click="handleDelete(user)"></el-button>
          </el-tooltip>
        </div>
      </el-card>
    </div>

    <!-- 分页区域 -->
    <div class="pagination-area">
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange" :current-page="currentPage"
        :page-sizes="[12, 24, 48, 96]" :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper"
        :total="totalItems"></el-pagination>
    </div>

    <!-- 用户操作对话框 -->
    <el-dialog :title="isOperation ? '编辑用户' : '新增用户'" :visible.sync="dialogUserOperaion" width="500px"
      :close-on-click-modal="false">
      <el-form label-width="80px">
        <el-form-item label="用户头像">
          <el-upload class="avatar-uploader" action="http://localhost:21090/api/campus-product-sys/v1.0/file/upload"
            :show-file-list="false" :on-success="handleAvatarSuccess">
            <img v-if="userAvatar" :src="userAvatar" class="avatar">
            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>

        <el-form-item label="用户名">
          <el-input style="width: 90%;" v-model="data.userName" placeholder="请输入用户名"></el-input>
        </el-form-item>

        <el-form-item label="账号">
          <el-input style="width: 90%;" v-model="data.userAccount" placeholder="请输入账号"></el-input>
        </el-form-item>

        <el-form-item label="邮箱">
          <el-input style="width: 90%;" v-model="data.userEmail" placeholder="请输入邮箱"></el-input>
        </el-form-item>

        <el-form-item label="密码">
          <el-input style="width: 90%;" v-model="userPwd" type="password" placeholder="请输入密码"></el-input>
        </el-form-item>
      </el-form>

      <span slot="footer" class="dialog-footer">
        <el-button class="customer" @click="cannel">取 消</el-button>
        <el-button class="customer" type="primary" @click="isOperation ? updateOperation() : addOperation()">
          确 定
        </el-button>
      </span>
    </el-dialog>

    <!-- 状态设置对话框 -->
    <el-dialog title="用户状态设置" :visible.sync="dialogStatusOperation" width="400px" :close-on-click-modal="false">
      <el-form label-width="120px">
        <el-form-item label="封号状态">
          <el-switch v-model="data.isLogin" active-text="封号" inactive-text="正常"></el-switch>
        </el-form-item>

        <el-form-item label="禁言状态">
          <el-switch v-model="data.isWord" active-text="禁言" inactive-text="正常"></el-switch>
        </el-form-item>

        <el-form-item label="管理员设置">
          <el-switch v-model="isAdmin" active-text="管理员" inactive-text="普通用户"></el-switch>
        </el-form-item>
      </el-form>

      <span slot="footer" class="dialog-footer">
        <el-button @click="cannel">取 消</el-button>
        <el-button type="primary" @click="comfirmStatus">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  data() {
    return {
      userPwd: '',
      userAvatar: '',
      data: {},
      filterText: '',
      isAdmin: false,
      currentPage: 1,
      pageSize: 12,
      totalItems: 0,
      dialogStatusOperation: false,
      dialogUserOperaion: false,
      isOperation: false,
      tableData: [],
      searchTime: [],
      selectedRows: [],
      status: null,
      userQueryDto: {},
      loginStatuList: [
        { value: null, label: '全部' },
        { value: 0, label: '正常' },
        { value: 1, label: '封号' }
      ],
      wordStatuList: [
        { value: null, label: '全部' },
        { value: 0, label: '正常' },
        { value: 1, label: '禁言' }
      ],
      rolesList: [
        { value: null, label: '全部' },
        { value: 2, label: '用户' },
        { value: 1, label: '管理员' }
      ],
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() > Date.now();
        },
        shortcuts: [
          {
            text: '最近一周',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit('pick', [start, end]);
            }
          },
          {
            text: '最近一个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
              picker.$emit('pick', [start, end]);
            }
          },
          {
            text: '最近三个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
              picker.$emit('pick', [start, end]);
            }
          }
        ]
      }
    };
  },
  created() {
    this.fetchFreshData();
  },
  methods: {
    formatTime(time) {
      if (!time) return '';
      const date = new Date(time);
      return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
    },

    cannel() {
      this.data = {};
      this.userAvatar = '';
      this.userPwd = '';
      this.dialogUserOperaion = false;
      this.dialogStatusOperation = false;
      this.isOperation = false;
    },

    comfirmStatus() {
      const userUpdateDto = {
        id: this.data.id,
        isLogin: this.data.isLogin,
        userRole: this.isAdmin ? 1 : 2,
        isWord: this.data.isWord
      };

      this.$axios.put(`/user/backUpdate`, userUpdateDto)
        .then(res => {
          if (res.data.code === 200) {
            this.$message.success('状态修改成功');
            this.cannel();
            this.fetchFreshData();
          } else {
            this.$message.error(res.data.msg || '状态修改失败');
          }
        })
        .catch(error => {
          console.error("修改状态异常:", error);
          this.$message.error('状态修改异常');
        });
    },

    handleStatus(data) {
      this.isAdmin = data.userRole === 1;
      this.dialogStatusOperation = true;
      this.data = { ...data };
    },

    handleAvatarSuccess(res, file) {
      if (res.code === 200) {
        this.userAvatar = res.data;
        this.$message.success('头像上传成功');
      } else {
        this.$message.error('头像上传失败');
      }
    },

    async batchDelete() {
      if (!this.selectedRows.length) {
        this.$message.warning('请至少选择一条数据');
        return;
      }

      try {
        const confirmed = await this.$confirm(
          `确认删除选中的${this.selectedRows.length}条用户数据吗？删除后不可恢复！`,
          '删除确认',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }
        );

        if (confirmed) {
          const ids = this.selectedRows.map(item => item.id);
          const response = await this.$axios.post(`/user/batchDelete`, ids);

          if (response.data.code === 200) {
            this.$message.success('删除成功');
            this.fetchFreshData();
            this.selectedRows = [];
          } else {
            this.$message.error(response.data.msg || '删除失败');
          }
        }
      } catch (error) {
        console.error('删除用户异常:', error);
        this.$message.error('删除操作异常');
      }
    },

    async updateOperation() {
      if (this.userPwd !== '') {
        const pwd = this.$md5(this.$md5(this.userPwd));
        this.data.userPwd = pwd;
      } else {
        this.data.userPwd = null;
      }
      this.data.userAvatar = this.userAvatar;

      try {
        const response = await this.$axios.put('/user/backUpdate', this.data);
        if (response.data.code === 200) {
          this.$message.success('用户信息修改成功');
          this.cannel();
          this.fetchFreshData();
        } else {
          this.$message.error(response.data.msg || '修改失败');
        }
      } catch (error) {
        console.error('修改出错:', error);
        this.$message.error('修改异常');
      }
    },

    async addOperation() {
      if (this.userPwd !== '') {
        this.data.userPwd = this.$md5(this.$md5(this.userPwd));
      } else {
        this.data.userPwd = null;
      }
      this.data.userAvatar = this.userAvatar;

      try {
        const response = await this.$axios.post('/user/insert', this.data);
        if (response.data.code === 200) {
          this.$message.success('用户新增成功');
          this.cannel();
          this.fetchFreshData();
        } else {
          this.$message.error(response.data.msg || '新增失败');
        }
      } catch (error) {
        console.error('信息新增出错:', error);
        this.$message.error('提交失败，请稍后再试！');
      }
    },

    async fetchFreshData() {
      try {
        let startTime = '';
        let endTime = '';
        if (this.searchTime && this.searchTime.length === 2) {
          startTime = `${this.searchTime[0]}T00:00:00`;
          endTime = `${this.searchTime[1]}T23:59:59`;
        }

        const params = {
          current: this.currentPage,
          size: this.pageSize,
          key: this.filterText,
          startTime: startTime,
          endTime: endTime,
          ...this.userQueryDto
        };

        const response = await this.$axios.post('/user/query', params);
        const { data } = response;

        if (data.code === 200) {
          this.tableData = data.data;
          this.totalItems = data.total;
        } else {
          this.$message.error(data.msg || '查询失败');
        }
      } catch (error) {
        console.error('查询用户信息异常:', error);
        this.$message.error('查询操作异常');
      }
    },

    add() {
      this.dialogUserOperaion = true;
      this.isOperation = false;
      this.data = {};
      this.userAvatar = '';
      this.userPwd = '';
    },

    handleFilter() {
      this.currentPage = 1;
      this.fetchFreshData();
    },

    handleFilterClear() {
      this.filterText = '';
      this.handleFilter();
    },

    handleSizeChange(val) {
      this.pageSize = val;
      this.currentPage = 1;
      this.fetchFreshData();
    },

    handleCurrentChange(val) {
      this.currentPage = val;
      this.fetchFreshData();
    },

    handleEdit(row) {
      this.dialogUserOperaion = true;
      this.isOperation = true;
      this.userAvatar = row.userAvatar;
      this.data = { ...row };
      this.userPwd = '';
    },

    handleDelete(row) {
      this.selectedRows = [row];
      this.batchDelete();
    }
  }
};
</script>

<style scoped lang="scss">
.user-management-container {
  padding: 20px 0;

  .search-card {
    margin-bottom: 20px;
    border-radius: 8px;
    border: 1px solid #ebeef5;

    .search-content {
      display: flex;
      align-items: center;
    }
  }

  .user-cards-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 16px;
    margin-bottom: 20px;

    .user-card {
      border-radius: 8px;
      transition: all 0.3s ease;

      &:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      }

      .user-header {
        display: flex;
        align-items: center;
        margin-bottom: 12px;

        .user-info {
          margin-left: 12px;

          .user-name {
            font-weight: 500;
            font-size: 16px;
          }

          .user-account {
            font-size: 12px;
            color: #909399;
          }
        }
      }

      .user-details {
        margin-bottom: 12px;

        .detail-item {
          display: flex;
          align-items: center;
          margin-bottom: 6px;
          font-size: 13px;
          color: #606266;

          i {
            margin-right: 8px;
            color: #909399;
          }
        }
      }

      .user-status {
        display: flex;
        flex-wrap: wrap;
        gap: 6px;
        margin-bottom: 12px;
      }

      .user-actions {
        display: flex;
        justify-content: flex-end;
        gap: 6px;
      }
    }
  }

  .pagination-area {
    display: flex;
    justify-content: center;
  }

  .avatar-uploader {
    ::v-deep .el-upload {
      border: 1px dashed #d9d9d9;
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;

      &:hover {
        border-color: #409EFF;
      }
    }

    .avatar-uploader-icon {
      font-size: 28px;
      color: #8c939d;
      width: 120px;
      height: 120px;
      line-height: 120px;
      text-align: center;
    }

    .avatar {
      width: 120px;
      height: 120px;
      display: block;
    }
  }
}
</style>