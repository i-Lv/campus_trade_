<template>
    <div class="interaction-container">
      <!-- 搜索卡片 -->
      <el-card class="search-card" shadow="never">
        <div class="search-content">
          <el-input
            v-model="interactionQueryDto.productId"
            placeholder="请输入商品ID"
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
      </el-card>
  
      <!-- 数据展示卡片 -->
      <el-card class="data-card" shadow="never">
        <!-- 表格区域 -->
        <el-table
          :data="tableData"
          stripe
          style="width: 100%"
          :header-cell-style="{background: '#f5f7fa', color: '#606266'}"
        >
          <el-table-column prop="userAccount" label="账号" width="120"></el-table-column>
          <el-table-column prop="userName" label="用户名" width="160"></el-table-column>
          <el-table-column prop="productId" label="商品ID" width="100" sortable></el-table-column>
          <el-table-column prop="type" label="行为类型" width="140">
            <template #default="{row}">
              <el-tag
                :type="getActionTypeTag(row.type)"
                effect="plain"
                size="medium"
              >
                {{ getActionTypeText(row.type) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="productTitle" label="商品名称" min-width="200"></el-table-column>
          <el-table-column prop="createTime" label="互动时间" width="160" sortable>
            <template #default="{row}">
              <div class="time-display">
                <i class="el-icon-time" style="margin-right: 5px;"></i>
                {{ formatTime(row.createTime) }}
              </div>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" align="center">
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
        interactionQueryDto: {}
      };
    },
    created() {
      this.fetchFreshData();
    },
    methods: {
      getActionTypeTag(type) {
        const map = {
          1: 'success',  // 收藏
          2: 'info',     // 浏览
          3: 'warning'   // 想要
        };
        return map[type] || '';
      },
      
      getActionTypeText(type) {
        const map = {
          1: '收藏操作',
          2: '浏览操作',
          3: '想要操作'
        };
        return map[type] || '未知操作';
      },
      
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
            `确认删除选中的${this.selectedRows.length}条互动数据吗？删除后不可恢复！`,
            '删除确认',
            {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }
          );
          
          if (confirmed) {
            const ids = this.selectedRows.map(item => item.id);
            const response = await this.$axios.post('/interaction/batchDelete', ids);
            
            if (response.data.code === 200) {
              this.$message.success('删除成功');
              this.fetchFreshData();
              this.selectedRows = [];
            } else {
              this.$message.error(response.data.msg || '删除失败');
            }
          }
        } catch (error) {
          console.error('删除互动记录异常:', error);
          ;
        }
      },
      
      fetchFreshData() {
        this.interactionQueryDto.current = this.currentPage;
        this.interactionQueryDto.size = this.pageSize;
        
        this.$axios.post('/interaction/query', this.interactionQueryDto)
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
            console.error('查询互动记录异常:', error);
            this.$message.error('查询操作异常');
          });
      },
      
      handleFilter() {
        this.currentPage = 1;
        this.fetchFreshData();
      },
      
      handleFilterClear() {
        this.interactionQueryDto.productId = '';
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
  .interaction-container {
    padding: 20px 0;
    
    .search-card {
      margin-bottom: 20px;
      border-radius: 4px;
      
      .search-content {
        display: flex;
        align-items: center;
      }
    }
    
    .data-card {
      border-radius: 4px;
      
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