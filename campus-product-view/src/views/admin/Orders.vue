<template>
  <div class="card-container">
    <!-- 筛选卡片 -->
    <el-card class="filter-card" shadow="never">
      <div class="filter-content">
        <div class="filter-tabs">
          <el-radio-group v-model="tradeSelectedItem" @change="tradeSelected" size="small">
            <el-radio-button v-for="(trade, index) in tradeStatus" :key="index" :label="trade">
              {{ trade.name }}
            </el-radio-button>
          </el-radio-group>

          <el-radio-group v-model="refundSelectedItem" @change="refundSelected" size="small" style="margin-left: 10px;">
            <el-radio-button v-for="(refund, index) in refundStatus" :key="index" :label="refund">
              {{ refund.name }}
            </el-radio-button>
          </el-radio-group>
        </div>

        <div class="filter-controls">
          <el-date-picker class="filter-item" @change="fetchFreshData" v-model="searchTime" type="daterange"
            range-separator="至" start-placeholder="下单开始" end-placeholder="下单结束" size="small">
          </el-date-picker>

          <el-input class="filter-item" v-model="ordersQueryDto.code" placeholder="订单号" clearable
            @clear="handleFilterClear" size="small">
            <el-button slot="append" @click="handleFilter" icon="el-icon-search"></el-button>
          </el-input>
        </div>
      </div>
    </el-card>

    <!-- 订单列表卡片 -->
    <el-card class="order-card" shadow="never">
      <div v-for="order in tableData" :key="order.id" class="order-item">
        <div class="order-header">
          <div class="order-code">订单号: {{ order.code }}</div>
          <div class="order-time">{{ order.createTime }}</div>
        </div>

        <div class="order-content">
          <div class="order-user">
            <el-avatar :size="40" :src="order.userAvatar"></el-avatar>
            <div class="user-name">{{ order.userName }}</div>
          </div>

          <div class="order-product">
            <el-image v-if="order.productCover" :src="order.productCover.split(',')[0]"
              :preview-src-list="order.productCover.split(',')" fit="cover" class="product-image">
            </el-image>
            <div class="product-info">
              <div class="product-title">{{ order.productTitle }}</div>
              <div class="product-meta">
                <span class="price">单价: {{ order.buyPrice }}元</span>
                <span class="quantity">数量: {{ order.buyNumber }}</span>
              </div>
              <div class="product-remark" v-if="order.detail">备注: {{ order.detail }}</div>
            </div>
          </div>

          <div class="order-status">
            <el-tag :type="order.tradeStatus ? 'success' : 'warning'" size="small">
              {{ order.tradeStatus ? '已支付' : '未支付' }}
            </el-tag>
            <el-tag :type="order.refundStatus ? 'danger' : 'info'" size="small" style="margin-top: 5px;">
              {{ order.refundStatus ? '已退款' : '未退款' }}
            </el-tag>
          </div>

          <div class="order-actions">
            <el-button class="customer" size="mini" @click="handleEdit(order)">详情</el-button>
            <el-button class="customer" size="mini" type="danger" @click="handleDelete(order)">删除</el-button>
          </div>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange" :current-page="currentPage"
          :page-sizes="[10, 20]" :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper"
          :total="totalItems">
        </el-pagination>
      </div>
    </el-card>

    <!-- 订单详情抽屉 -->
    <el-drawer title="订单详情" :visible.sync="drawerProductOperaion" :direction="direction" size="40%">
      <div class="drawer-content">
        <el-card shadow="never">
          <div slot="header">
            <span>产品信息</span>
          </div>
          <div class="product-images">
            <el-image v-for="(cover, index) in coverList" :key="index" :src="cover" :preview-src-list="coverList"
              fit="cover" class="detail-image">
            </el-image>
          </div>
        </el-card>

        <el-card shadow="never" style="margin-top: 20px;">
          <div slot="header">
            <span>订单状态</span>
          </div>
          <div class="status-item">
            <div class="status-label">支付状态:</div>
            <div class="status-value">
              <i :class="data.tradeStatus ? 'el-icon-success' : 'el-icon-warning'"
                :style="{ color: data.tradeStatus ? '#67C23A' : '#E6A23C' }"></i>
              <span>{{ data.tradeStatus ? '已支付' : '未支付' }}</span>
              <span v-if="data.tradeStatus" class="status-time">支付时间: {{ data.tradeTime }}</span>
            </div>
          </div>

          <div class="status-item">
            <div class="status-label">退款状态:</div>
            <div class="status-value">
              <i :class="data.refundStatus ? 'el-icon-success' : 'el-icon-warning'"
                :style="{ color: data.refundStatus ? '#67C23A' : '#E6A23C' }"></i>
              <span>{{ data.refundStatus ? '已申请退款' : '未申请退款' }}</span>
              <span v-if="data.refundStatus" class="status-time">退款时间: {{ data.refundTime }}</span>
            </div>
          </div>

          <div class="status-item">
            <div class="status-label">退款审核:</div>
            <div class="status-value">
              <i :class="data.isRefundConfirm ? 'el-icon-success' : 'el-icon-warning'"
                :style="{ color: data.isRefundConfirm ? '#67C23A' : '#E6A23C' }"></i>
              <span>{{ data.isRefundConfirm ? '已审核' : '未审核' }}</span>
            </div>
          </div>
        </el-card>
      </div>
    </el-drawer>
  </div>
</template>

<script>
export default {
  data() {
    return {
      data: {},
      currentPage: 1,
      coverList: [],
      searchTime: [],
      pageSize: 10,
      totalItems: 0,
      drawerProductOperaion: false,
      tableData: [],
      delectedRows: [],
      ordersQueryDto: {},
      direction: 'rtl',
      tradeSelectedItem: {},
      refundSelectedItem: {},
      refundStatus: [
        { refundStatus: null, name: '全部' },
        { refundStatus: true, name: '已退款' },
        { refundStatus: false, name: '未退款' }
      ],
      tradeStatus: [
        { tradeStatus: null, name: '全部' },
        { tradeStatus: true, name: '已下单' },
        { tradeStatus: false, name: '未下单' }
      ]
    };
  },
  created() {
    this.fetchFreshData();
    this.tradeSelected(this.tradeStatus[0]);
  },
  methods: {
    tradeSelected(trade) {
      this.tradeSelectedItem = trade;
      if (trade.tradeStatus === null) {
        this.ordersQueryDto.tradeStatus = null;
      } else {
        this.ordersQueryDto.tradeStatus = trade.tradeStatus ? 2 : 1;
      }
      this.fetchFreshData();
    },
    refundSelected(refund) {
      this.refundSelectedItem = refund;
      if (refund.refundStatus === null) {
        this.ordersQueryDto.refundStatus = null;
      } else {
        this.ordersQueryDto.refundStatus = refund.refundStatus ? 4 : 1;
      }
      this.fetchFreshData();
    },
    cannel() {
      this.data = {};
      this.drawerProductOperaion = false;
    },
    async batchDelete() {
      if (!this.delectedRows.length) {
        this.$message(`未选中任何数据`);
        return;
      }
      const confirmed = await this.$swalConfirm({
        title: '删除订单数据',
        text: `删除后不可恢复，是否继续？`,
        icon: 'warning',
      });
      if (confirmed) {
        try {
          let ids = this.delectedRows.map(entity => entity.id);
          const response = await this.$axios.post(`/orders/batchDelete`, ids);
          if (response.data.code === 200) {
            this.$notify({
              duration: 1000,
              title: '信息删除',
              message: '删除成功',
              type: 'success'
            });
            this.fetchFreshData();
            return;
          }
        } catch (error) {
          this.$message.error("订单信息删除异常：", error);
          console.error(`订单信息删除异常：`, error);
        }
      }
    },
    async fetchFreshData() {
      let startTime = null;
      let endTime = null;
      if (this.searchTime != null && this.searchTime.length === 2) {
        const [startDate, endDate] = await Promise.all(this.searchTime.map(date => date.toISOString()));
        startTime = `${startDate.split('T')[0]}T00:00:00`;
        endTime = `${endDate.split('T')[0]}T23:59:59`;
      }
      this.ordersQueryDto.current = this.currentPage;
      this.ordersQueryDto.size = this.pageSize;
      this.ordersQueryDto.startTime = startTime;
      this.ordersQueryDto.endTime = endTime;
      this.$axios.post('/orders/query', this.ordersQueryDto).then(res => {
        const { data } = res;
        if (data.code === 200) {
          this.tableData = data.data;
          this.totalItems = data.total;
        }
      }).catch(error => {
        this.$notify.error({
          title: '查询操作',
          message: error
        });
      })
    },
    handleFilter() {
      this.currentPage = 1;
      this.fetchFreshData();
    },
    handleFilterClear() {
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
      this.data = row;
      this.coverList = row.productCover ? row.productCover.split(',') : [];
      this.drawerProductOperaion = true;
    },
    handleDelete(row) {
      this.delectedRows.push(row);
      this.batchDelete();
    }
  },
};
</script>

<style scoped lang="scss">
.card-container {
  padding: 20px 0;
}

.filter-card {
  margin-bottom: 20px;
  border-radius: 8px;

  .filter-content {
    display: flex;
    flex-direction: column;
    gap: 15px;
  }

  .filter-tabs {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-bottom: 10px;
  }

  .filter-controls {
    display: flex;
    gap: 10px;

    .filter-item {
      flex: 1;
      min-width: 200px;
    }
  }
}

.order-card {
  border-radius: 8px;

  .order-item {
    padding: 20px;
    border-bottom: 1px solid #ebeef5;

    &:last-child {
      border-bottom: none;
    }

    .order-header {
      display: flex;
      justify-content: space-between;
      margin-bottom: 15px;
      padding-bottom: 10px;
      border-bottom: 1px dashed #ebeef5;

      .order-code {
        font-weight: 500;
        color: #303133;
      }

      .order-time {
        font-size: 12px;
        color: #909399;
      }
    }

    .order-content {
      display: flex;
      gap: 20px;

      .order-user {
        flex: 0 0 100px;
        display: flex;
        flex-direction: column;
        align-items: center;

        .user-name {
          margin-top: 5px;
          font-size: 13px;
        }
      }

      .order-product {
        flex: 1;
        display: flex;
        gap: 15px;

        .product-image {
          width: 80px;
          height: 80px;
          border-radius: 4px;
        }

        .product-info {
          flex: 1;

          .product-title {
            margin: 0 0 8px 0;
            font-size: 15px;
            color: #303133;
          }

          .product-meta {
            margin-bottom: 8px;
            font-size: 13px;

            .price {
              margin-right: 15px;
              color: #f56c6c;
              font-weight: 500;
            }
          }

          .product-remark {
            font-size: 13px;
            color: #909399;
          }
        }
      }

      .order-status {
        flex: 0 0 80px;
        display: flex;
        flex-direction: column;
        align-items: center;
      }

      .order-actions {
        flex: 0 0 120px;
        display: flex;
        flex-direction: column;
        align-items: flex-end;
        justify-content: center;
        gap: 8px;
      }
    }
  }
}

.pagination-container {
  padding: 20px 0;
  text-align: center;
}

.drawer-content {
  padding: 20px;

  .product-images {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;

    .detail-image {
      width: 100px;
      height: 100px;
      border-radius: 4px;
    }
  }

  .status-item {
    display: flex;
    margin-bottom: 15px;

    .status-label {
      width: 100px;
      font-weight: 500;
      color: #606266;
    }

    .status-value {
      flex: 1;

      i {
        margin-right: 8px;
      }

      .status-time {
        margin-left: 15px;
        font-size: 13px;
        color: #909399;
      }
    }
  }
}
</style>