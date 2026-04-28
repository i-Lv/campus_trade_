<template>
  <div class="order-container">
    <!-- 筛选区域 -->
    <div class="filter-section">
      <div class="status-tabs">
        <el-tag v-for="(tradeStatus, index) in tradeStatusList" :key="index"
          :type="tradeStatusSelectedItem.tradeStatus === tradeStatus.tradeStatus ? '' : 'info'"
          :effect="tradeStatusSelectedItem.tradeStatus === tradeStatus.tradeStatus ? 'dark' : 'plain'"
          @click="tradeStatusSelected(tradeStatus)" class="status-tab">
          {{ tradeStatus.name }}
        </el-tag>
      </div>

      <el-input v-model="ordersQueryDto.code" placeholder="搜索订单号" clearable @clear="handleFilterClear"
        @keyup.enter.native="fetchOrders" class="search-input">
        <el-button slot="append" icon="el-icon-search" @click="fetchOrders"></el-button>
      </el-input>
    </div>

    <!-- 订单列表 -->
    <div v-if="ordersList.length === 0" class="empty-state">
      <el-empty description="暂无订单数据"></el-empty>
    </div>

    <transition-group v-else name="order-list" tag="div" class="order-list">
      <div v-for="(orderInfo, index) in ordersList" :key="orderInfo.id" class="order-card"
        :class="getOrderCardClass(orderInfo)">
        <!-- 订单头部 -->
        <div class="order-header">
          <div class="order-meta">
            <span class="order-number">订单状态：{{ orderInfo.tradeStatus === 1 ? '待支付' : (orderInfo.tradeStatus === 2 ?
              '已支付' : '已取消') }}</span>
            <span class="order-number">退款状态：{{ orderInfo.refundStatus === 1 ? '无退款' : (orderInfo.refundStatus === 2 ?
              '退款中，待商家审核' : (orderInfo.refundStatus === 3 ? '拒绝退款' : '已退款')) }}</span>
            <span class="order-number">订单号: {{ orderInfo.code }}</span>
            <span class="order-time">创建时间: {{ orderInfo.createTime }}</span>
          </div>
        </div>

        <!-- 订单商品 -->
        <div class="order-body">
          <div class="product-image">
            <img :src="orderInfo.cover" style="width: 80px;height: 80px;" :alt="orderInfo.productTitle">
          </div>

          <div class="product-info">
            <h3 class="product-title">{{ orderInfo.productTitle }}</h3>
            <div class="product-detail">
              <span class="quantity">数量x{{ orderInfo.buyNumber }}</span>
              <span class="price">
                <span class="symbol">¥</span>
                <span class="value">{{ totalPrice(orderInfo) }}</span>
              </span>
            </div>
            <p class="remark" v-if="orderInfo.detail">备注: {{ orderInfo.detail }}</p>
            <div class="timeline">
              <div v-if="orderInfo.tradeTime" class="timeline-item">
                <i class="el-icon-success"></i>
                <span>支付时间: {{ orderInfo.tradeTime }}</span>
              </div>
              <div v-if="orderInfo.isDeliver" class="timeline-item">
                <i class="el-icon-refresh"></i>
                <span>卖家发货时间: {{ orderInfo.deliverTime }}</span>
              </div>
              <div v-if="orderInfo.isConfirm" class="timeline-item">
                <i class="el-icon-refresh"></i>
                <span>买家收货时间: {{ orderInfo.isConfirmTime }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 订单操作 -->
        <div class="order-footer">
          <div class="total-price">
            实付款: <span class="price">¥{{ totalPrice(orderInfo) }}</span>
          </div>
          <!-- <div>{{ orderInfo }}</div> -->
          <div class="action-buttons">
            <!-- 只有在未支付状态下，用户才能下单 -->
            <el-button type="primary" v-if="orderInfo.tradeStatus === 1"
              @click="placeAnOrder(orderInfo)">立即下单</el-button>
            <!-- 商家已经发货的情况下，可收货 -->
            <el-button type="primary" v-if="orderInfo.isDeliver && !orderInfo.isConfirm"
              @click="getGoods(orderInfo)">立即收货</el-button>
            <el-button type="primary" v-if="(orderInfo.refundStatus === 1 || orderInfo.refundStatus === 3) && orderInfo.tradeStatus === 2" @click="toRefund(orderInfo)">申请退款</el-button>
            <el-button type="primary" v-if="orderInfo.tradeStatus === 1 && orderInfo.tradeStatus !== 3"
              @click="cannelOrder(orderInfo)">取消订单</el-button>
            <el-button type="danger" @click="del(orderInfo)">删除订单</el-button>
          </div>
        </div>
      </div>
    </transition-group>

    <el-dialog title="下单" :visible.sync="dialogPay" width="400px" :close-on-click-modal="false">

      <div class="product-info-area">
        <h3 class="product-title">{{ orderPay.productTitle }}</h3>
        <div class="product-meta">
          <span class="quantity">数量x{{ orderPay.buyNumber }}，</span>
          <span class="price">
            <span class="symbol">金额¥</span>
            <span class="value">{{ totalPrice(orderPay) }}</span>
          </span>
        </div>
        <div class="product-remark" v-if="orderPay.detail">
          <span>备注: {{ orderPay.detail }}</span>
        </div>
      </div>

      <p>请支付</p>
      <div style="display: flex;align-items: center;justify-content: center;margin: 10px 0 ;">
        <img style="width: 120px;height: 120px;" src="/code.png" alt="">
      </div>

      <span slot="footer" class="dialog-footer">
        <!-- <el-button @click="cannel">取 消</el-button> -->
        <el-button type="primary" @click="comfirmPayOrder">我已完成支付</el-button>
      </span>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'BuyOrders',
  data() {
    return {
      ordersList: [],
      dialogPay: false, // 下单标识
      orderPay: {},
      ordersQueryDto: {},
      tradeStatusSelectedItem: {},
      tradeStatusList: [
        { tradeStatus: null, name: '全部' },
        { tradeStatus: 2, name: '已支付' },
        { tradeStatus: 1, name: '未支付' },
        { tradeStatus: 3, name: '已取消' }
      ]
    }
  },
  created() {
    this.fetchOrders();
    this.tradeStatusSelected(this.tradeStatusList[0]);
  },
  methods: {
    getOrderCardClass(orderInfo) {
      if (orderInfo.isRefundConfirm) return 'refunded';
      if (orderInfo.refundStatus) return 'refunding';
      if (orderInfo.isConfirm) return 'completed';
      if (orderInfo.tradeStatus) return 'paid';
      return 'unpaid';
    },

    async comfirmPayOrder() {
      try {
        await this.$confirm('该订单已支付?', '确认支付', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        });

        const response = await this.$axios.post(`/product/placeAnOrder/${this.orderPay.id}`);
        if (response.data.code === 200) {
          this.$message.success('支付成功');
          this.fetchOrders();
          this.dialogPay = false;
          this.orderPay = {};
        }
      } catch (error) {
        if (error !== 'cancel') {
          console.error("下单异常:", error);
        }
      }
    },

    getStatusTagType(orderInfo) {
      if (orderInfo.isRefundConfirm) return 'danger';
      if (orderInfo.refundStatus) return 'warning';
      if (orderInfo.isConfirm) return 'success';
      if (orderInfo.tradeStatus) return 'primary';
      return 'info';
    },

    getStatusText(orderInfo) {
      // 1. 优先判断退款相关状态
      if (orderInfo.isRefundConfirm) {
        return '已退款';
      }
      if (orderInfo.refundStatus !== null && !orderInfo.refundStatus) {
        return '退款中';
      }

      // 2. 判断订单完成状态
      if (orderInfo.isConfirm) {
        return '已完成';
      }

      // 3. 判断支付状态
      if (orderInfo.tradeStatus) {
        // 已支付但未确认收货
        return '待收货';
      }

      // 4. 默认状态
      return '待支付';
    },

    tradeStatusSelected(tradeStatusItem) {
      this.tradeStatusSelectedItem = tradeStatusItem;
      this.ordersQueryDto.tradeStatus = tradeStatusItem.tradeStatus;
      this.fetchOrders();
    },

    handleFilterClear() {
      this.ordersQueryDto.code = '';
      this.fetchOrders();
    },
    async toRefund(orderInfo) {
      try {
        await this.$confirm('确定申请退款?', '确认收货', {
          confirmButtonText: '确认',
          cancelButtonText: '取消',
          type: 'warning'
        });
        const orders = {
          id: orderInfo.id,
          refundStatus: 2, // 退款中
        }
        await this.$axios.put(`/orders/update`, orders);
        this.$message.success('订单申请退款成功，请等待商家审核');
        this.fetchOrders();
      } catch (error) {
        console.log("订单申请退款异常");
      }
    },
    async cannelOrder(orderInfo) {
      try {
        await this.$confirm('确定取消订单?', '确认收货', {
          confirmButtonText: '确认',
          cancelButtonText: '取消',
          type: 'warning'
        });
        const orders = {
          id: orderInfo.id,
          tradeStatus: 3, // 取消状态
        }
        await this.$axios.put(`/orders/update`, orders);
        this.$message.success('订单取消成功');
        this.fetchOrders();
      } catch (error) {
        console.log("取消订单异常");
      }
    },
    async getGoods(orderInfo) {
      try {
        await this.$confirm('确认收到商品了吗?', '确认收货', {
          confirmButtonText: '确认',
          cancelButtonText: '取消',
          type: 'warning'
        });

        const response = await this.$axios.post(`/product/getGoods/${orderInfo.id}`);
        if (response.data.code === 200) {
          this.$message.success(response.data.msg);
          this.fetchOrders();
        } else {
          this.$message.info(response.data.msg);
        }
      } catch (error) {
        if (error !== 'cancel') {
          console.error("收货异常:", error);
        }
      }
    },

    async del(orderInfo) {
      try {
        await this.$confirm('删除后不可恢复，是否继续?', '删除订单', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        });

        const response = await this.$axios.post(`/orders/batchDelete`, [orderInfo.id]);
        if (response.data.code === 200) {
          this.$message.success('删除成功');
          this.fetchOrders();
        }
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error("订单删除异常");
          console.error("订单删除异常:", error);
        }
      }
    },

    totalPrice(orderInfo) {
      const totalPrice = orderInfo.buyNumber * orderInfo.buyPrice;
      return parseFloat(totalPrice).toFixed(2);
    },

    async refund(orderInfo) {
      try {
        await this.$confirm('确认要申请退款吗?', '申请退款', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        });

        const response = await this.$axios.post(`/product/refund/${orderInfo.id}`);
        if (response.data.code === 200) {
          this.$message.success(response.data.msg);
          this.fetchOrders();
        } else {

          this.$message.info(response.data.msg);
        }
      } catch (error) {
        if (error !== 'cancel') {
          console.error("退款异常:", error);
        }
      }
    },

    async placeAnOrder(orderInfo) {
      this.dialogPay = true;
      this.orderPay = orderInfo;
    },

    coverParse(coverList) {
      if (!coverList.productCover) return '';
      return coverList.productCover.split(',')[0] || '';
    },

    fetchOrders() {
      this.$axios.post('/orders/queryUser', this.ordersQueryDto).then(res => {
        const { data } = res;
        if (data.code === 200) {
          this.ordersList = data.data.map(order => ({
            ...order,
            cover: this.coverParse(order)
          }));
        }
      }).catch(error => {
        console.error("订单查询异常:", error);
      });
    }
  }
}
</script>

<style scoped lang="scss">
.price {
  margin-left: 10px;

  .value {
    font-size: 30px;
    font-weight: bold;
  }

}

.product-info-area {
  h3 {
    font-size: 30px;
  }

  .product-meta {
    .price {
      .value {
        font-size: 30px;
        font-weight: bold;
      }

    }
  }

  .product-remark {
    padding: 10px;
    box-sizing: border-box;
    background-color: rgb(240, 240, 240);
  }
}

.order-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;

  .filter-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding: 15px;
    background-color: #fff;
    border-radius: 8px;
    // box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);

    .status-tabs {
      display: flex;
      gap: 10px;

      .status-tab {
        cursor: pointer;
        border-radius: 20px;
        transition: all 0.3s;

        &:hover {
          transform: translateY(-2px);
          // box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
      }
    }

    .search-input {
      width: 300px;
    }
  }

  .empty-state {
    padding: 40px 0;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  }

  .order-list {
    display: flex;
    flex-direction: column;
    gap: 20px;

    .order-list-enter-active,
    .order-list-leave-active {
      transition: all 0.5s;
    }

    .order-list-enter,
    .order-list-leave-to {
      opacity: 0;
      transform: translateY(20px);
    }

    .order-list-move {
      transition: transform 0.5s;
    }
  }

  .order-card {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    transition: all 0.3s;
    overflow: hidden;

    &:hover {
      cursor: pointer;
      // transform: translateY(-5px);
      //box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
    }


    .order-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 15px 20px;
      background-color: #f9f9f9;
      border-bottom: 1px solid #eee;

      .order-meta {
        display: flex;
        flex-direction: column;
        gap: 5px;

        .order-number {
          font-size: 16px;
          font-weight: 600;
          color: #333;
        }

        .order-time {
          font-size: 12px;
          color: #999;
        }
      }
    }

    .order-body {
      display: flex;
      padding: 20px;
      gap: 20px;

      .product-image-container {
        width: 180px;
        height: 180px;
        border-radius: 8px;
        overflow: hidden;
        flex-shrink: 0;

        .product-image {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.5s;
        }

        &:hover .product-image {
          transform: scale(1.05);
        }
      }

      .product-info {
        flex: 1;

        .product-title {
          margin: 0 0 10px 0;
          font-size: 18px;
          color: #333;
        }

        .product-meta {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 10px;

          .quantity {
            font-size: 14px;
            color: #666;
          }

          .price {
            .symbol {
              font-size: 14px;
              color: #ff4f24;
            }

            .value {
              font-size: 20px;
              font-weight: bold;
              color: #ff4f24;
            }
          }
        }

        .product-remark {
          margin: 10px 0;
          font-size: 14px;
          color: #666;
          padding: 8px;
          background-color: #f5f7fa;
          border-radius: 4px;
        }

        .timeline {
          margin-top: 15px;
          padding-left: 20px;
          position: relative;

          &::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 2px;
            background-color: #e4e7ed;
          }

          .timeline-item {
            position: relative;
            padding-bottom: 15px;

            &:last-child {
              padding-bottom: 0;
            }

            i {
              position: absolute;
              left: -26px;
              top: 2px;
              font-size: 16px;
              color: #67c23a;
              background-color: #fff;
            }

            span {
              font-size: 13px;
              color: #666;
            }
          }
        }
      }
    }

    .order-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 15px 20px;
      border-top: 1px solid #eee;
      background-color: #f9f9f9;

      .total-price {
        font-size: 16px;

        .price {
          font-weight: bold;
          color: #ff4f24;
        }
      }

      .action-buttons {
        display: flex;
        gap: 10px;

        .action-button {
          transition: all 0.3s;

          &:hover {
            transform: translateY(-2px);
          }
        }
      }
    }
  }
}
</style>