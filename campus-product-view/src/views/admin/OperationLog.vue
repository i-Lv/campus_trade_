<template>
    <div class="log-management-container">
      <!-- 搜索卡片 -->
      <el-card class="search-card" shadow="hover">
        <div class="search-content">
          <el-input
            v-model="operationLogQueryDto.detail"
            placeholder="请输入操作行为关键词"
            clearable
            size="medium"
            style="width: 320px;"
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
      </el-card>
  
      <!-- 日志列表卡片 -->
      <el-card class="log-list-card" shadow="hover">
        <!-- 表格区域 -->
        <el-table
          :data="tableData"
          stripe
          style="width: 100%"
          :header-cell-style="{background: '#f5f7fa', color: '#606266'}"
        >
          <el-table-column prop="userAccount" label="用户账号" width="180"></el-table-column>
          <el-table-column prop="userName" label="用户名" width="240"></el-table-column>
          <el-table-column prop="detail" label="操作详情" min-width="300">
            <template #default="{row}">
              <div class="log-detail">
                <i class="el-icon-document" style="margin-right: 8px; color: #409EFF;"></i>
                {{ row.detail }}
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="操作时间" width="220" sortable>
            <template #default="{row}">
              <div class="time-display">
                <i class="el-icon-time" style="margin-right: 5px;"></i>
                {{ formatTime(row.createTime) }}
              </div>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" align="left">
            <template #default="{row}">
              <el-tooltip content="删除日志" placement="top">
                <el-button
                  type="danger"
                  icon="el-icon-delete"
                  circle
                  size="mini"
                  @click="handleDelete(row)"
                ></el-button>
              </el-tooltip>
            </template>
          </el-table-column>
        </el-table>
  
        <!-- 分页区域 -->
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
      </el-card>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        data: {},
        currentPage: 1,
        pageSize: 10,
        totalItems: 0,
        tableData: [],
        selectedRows: [],
        operationLogQueryDto: {}
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
            `确认删除选中的${this.selectedRows.length}条操作日志吗？删除后不可恢复！`,
            '删除确认',
            {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }
          );
          
          if (confirmed) {
            const ids = this.selectedRows.map(item => item.id);
            const response = await this.$axios.post('/operation-log/batchDelete', ids);
            
            if (response.data.code === 200) {
              this.$message.success('删除成功');
              this.fetchFreshData();
              this.selectedRows = [];
            } else {
              this.$message.error(response.data.msg || '删除失败');
            }
          }
        } catch (error) {
          console.error('删除操作日志异常:', error);
          ;
        }
      },
      
      fetchFreshData() {
        this.operationLogQueryDto.current = this.currentPage;
        this.operationLogQueryDto.size = this.pageSize;
        
        this.$axios.post('/operation-log/query', this.operationLogQueryDto)
          .then(res => {
            const { data } = res;
            if (data.code === 200) {
              this.tableData = data.data;
              this.totalItems = data.total;
            } else {
              this.$message.error(data.msg || '查询失败');
            }
          })
          .catch(error => {
            console.error('查询操作日志异常:', error);
            this.$message.error('查询操作异常');
          });
      },
      
      handleFilter() {
        this.currentPage = 1;
        this.fetchFreshData();
      },
      
      handleFilterClear() {
        this.operationLogQueryDto.detail = '';
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
  .log-management-container {
    padding: 20px 0;
    
    .search-card {
      margin-bottom: 20px;
      border-radius: 6px;
      border: 1px solid #ebeef5;
      
      .search-content {
        display: flex;
        align-items: center;
      }
    }
    
    .log-list-card {
      border-radius: 6px;
      border: 1px solid #ebeef5;
      
      .log-detail {
        display: flex;
        align-items: center;
        color: #606266;
      }
      
      .time-display {
        color: #909399;
        font-size: 13px;
        display: flex;
        align-items: center;
      }
      
      .pagination-area {
        margin-top: 20px;
        display: flex;
        justify-content: flex-end;
      }
    }
  }
  </style>