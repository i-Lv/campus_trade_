<template>
    <div class="message-container">
      <!-- 搜索区域 -->
      <div class="search-area">
        <div class="search-filters">
          <el-date-picker
            v-model="searchTime"
            type="daterange"
            range-separator="至"
            start-placeholder="发送开始日期"
            end-placeholder="发送结束日期"
            size="medium"
            style="width: 360px; margin-right: 12px;"
            @change="fetchFreshData"
            value-format="yyyy-MM-dd"
            :picker-options="pickerOptions"
          ></el-date-picker>
          
          <el-input
            v-model="messageQueryDto.content"
            placeholder="请输入消息内容"
            clearable
            size="medium"
            style="width: 300px;"
            @clear="handleFilterClear"
            @keyup.enter="handleFilter"
          >
            <template #append>
              <el-button
                type="primary"
                icon="el-icon-search"
                @click="handleFilter"
              ></el-button>
            </template>
          </el-input>
        </div>
      </div>
  
      <!-- 消息列表 -->
      <div class="message-list">
        <el-table
          :data="tableData"
          stripe
          style="width: 100%"
          :header-cell-style="{background: '#f5f7fa', color: '#606266'}"
        >
          <el-table-column prop="userAvatar" label="头像" width="80" align="center">
            <template #default="{row}">
              <el-avatar
                :size="40"
                :src="row.userAvatar || 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'"
                shape="square"
              ></el-avatar>
            </template>
          </el-table-column>
          
          <el-table-column prop="userName" label="接收者" width="150"></el-table-column>
          
          <el-table-column prop="content" label="消息内容" min-width="200">
            <template #default="{row}">
              <div class="message-content" :class="{'unread-message': !row.isRead}">
                {{ row.content }}
              </div>
            </template>
          </el-table-column>
          
          <el-table-column prop="isRead" label="状态" width="120" align="left">
            <template #default="{row}">
              <el-tag
                :type="row.isRead ? 'success' : 'warning'"
                effect="plain"
                size="medium"
              >
                {{ row.isRead ? '已读' : '未读' }}
              </el-tag>
            </template>
          </el-table-column>
          
          <el-table-column prop="createTime" label="发送时间" width="200" align="center">
            <template #default="{row}">
              <div class="time-display">
                <i class="el-icon-time" style="margin-right: 5px;"></i>
                {{ row.createTime }}
              </div>
            </template>
          </el-table-column>
          
          <el-table-column label="操作" width="100" align="left">
            <template #default="{row}">
              <el-button
                type="danger"
                icon="el-icon-delete"
                circle
                size="mini"
                @click="handleDelete(row)"
              ></el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
  
      <!-- 分页 -->
      <div class="pagination-area">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="currentPage"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="totalItems"
        ></el-pagination>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        currentPage: 1,
        pageSize: 10,
        totalItems: 0,
        tableData: [],
        selectedRows: [],
        searchTime: [],
        messageQueryDto: {},
        pickerOptions: {
          disabledDate(time) {
            return time.getTime() > Date.now();
          },
          shortcuts: [{
            text: '最近一周',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近一个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近三个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
              picker.$emit('pick', [start, end]);
            }
          }]
        }
      };
    },
    created() {
      this.fetchFreshData();
    },
    methods: {
      formatTime(time) {
        if (!time) return '';
        return new Date(time).toLocaleString();
      },
      
      async batchDelete() {
        if (!this.selectedRows.length) {
          this.$message.warning('请至少选择一条数据');
          return;
        }
        
        try {
          const confirmed = await this.$confirm(
            `确认删除选中的${this.selectedRows.length}条消息数据吗？删除后不可恢复！`,
            '删除确认',
            {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }
          );
          
          if (confirmed) {
            const ids = this.selectedRows.map(item => item.id);
            const response = await this.$axios.post('/message/batchDelete', ids);
            
            if (response.data.code === 200) {
              this.$message.success('删除成功');
              this.fetchFreshData();
              this.selectedRows = [];
            } else {
              this.$message.error(response.data.msg || '删除失败');
            }
          }
        } catch (error) {
          console.error('删除消息异常:', error);
          ;
        }
      },
      
      async fetchFreshData() {
        let startTime = null;
        let endTime = null;
        
        if (this.searchTime && this.searchTime.length === 2) {
          startTime = `${this.searchTime[0]}T00:00:00`;
          endTime = `${this.searchTime[1]}T23:59:59`;
        }
        
        this.messageQueryDto.current = this.currentPage;
        this.messageQueryDto.size = this.pageSize;
        this.messageQueryDto.startTime = startTime;
        this.messageQueryDto.endTime = endTime;
        
        try {
          const res = await this.$axios.post('/message/query', this.messageQueryDto);
          const { data } = res;
          
          if (data.code === 200) {
            this.tableData = data.data;
            this.totalItems = data.total;
          } else {
            this.$message.error(data.msg || '查询失败');
          }
        } catch (error) {
          console.error('查询消息异常:', error);
          this.$message.error('查询操作异常');
        }
      },
      
      handleFilter() {
        this.currentPage = 1;
        this.fetchFreshData();
      },
      
      handleFilterClear() {
        this.messageQueryDto.content = '';
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
      
      handleDelete(row) {
        this.selectedRows = [row];
        this.batchDelete();
      }
    }
  };
  </script>
  
  <style scoped lang="scss">
  .message-container {
    padding: 20px;
    border-radius: 4px;
    
    .search-area {
      margin-bottom: 20px;
      
      .search-filters {
        display: flex;
        align-items: center;
      }
    }
    
    .message-list {
      margin-bottom: 20px;
      
      .message-content {
        padding: 8px 0;
        line-height: 1.5;
        
        &.unread-message {
          font-weight: 600;
        }
      }
      
      .time-display {
        color: #909399;
        font-size: 13px;
        display: flex;
        align-items: center;
      }
    }
    
    .pagination-area {
      display: flex;
      justify-content: flex-end;
    }
  }
  </style>