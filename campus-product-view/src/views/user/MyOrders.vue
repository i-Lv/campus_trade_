<template>
  <div class="orders-page">
    <!-- 筛选条件 -->
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
    <div v-if="ordersList.length === 0" class="empty-container">
      <el-empty description="未找到符合条件的订单"></el-empty>
    </div>

    <transition-group key="model-6" v-else name="order-list" tag="div" class="orders-container">
      <div v-for="(orderInfo, index) in ordersList" :key="orderInfo.id" class="order-card" :class="{
        'paid': orderInfo.tradeStatus,
        'unpaid': !orderInfo.tradeStatus,
        'refunded': orderInfo.refundStatus
      }">
        <!-- 订单头部 -->
        <div class="order-header">
          <div class="order-meta">
            <span class="order-number">订单状态：{{ orderInfo.tradeStatus === 1 ? '待支付' : (orderInfo.tradeStatus === 2 ?
              '已支付' : '已取消') }}</span>
            <span class="order-number">退款状态：{{ orderInfo.refundStatus === 1 ? '无退款' : (orderInfo.refundStatus === 2 ?
              '买家申请退款，请尽快审核' : (orderInfo.refundStatus === 3 ? '拒绝退款' : '已退款')) }}</span>
            <span class="order-number">订单号: {{ orderInfo.code }}</span>
            <span class="order-time">{{ orderInfo.createTime }}</span>
          </div>

          <div class="order-status">
            <!-- <el-tag :type="orderInfo.tradeStatus ? 'success' : 'warning'" size="small">
              {{ getOrderStatusText(orderInfo) }}
            </el-tag> -->
          </div>
        </div>

        <!-- 订单商品 -->
        <div class="order-body">
          <div class="product-image">
            <img :src="orderInfo.cover" :alt="orderInfo.productTitle">
          </div>

          <div class="product-info">
            <h3 class="product-title">{{ orderInfo.productTitle }}</h3>
            <div class="product-detail">
              <span class="quantity">x{{ orderInfo.buyNumber }}</span>
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

          <div class="actions">
            <el-button type="primary" v-if="orderInfo.refundStatus === 2" @click="okRefund(orderInfo)">通过退款</el-button>
            <el-button type="primary" v-if="orderInfo.refundStatus === 2"
              @click="rejectRefund(orderInfo)">拒绝退款</el-button>
            <el-button type="success" v-if="!orderInfo.isDeliver && orderInfo.tradeStatus === 2"
              @click="openDeliver(orderInfo)">前去发货</el-button>
            <el-button type="primary" v-if="orderInfo.tradeStatus === 1 && orderInfo.tradeStatus !== 3"
              @click="cannelOrder(orderInfo)">取消订单</el-button>
            <el-button type="danger" @click="del(orderInfo)">删除订单</el-button>
          </div>
        </div>
      </div>
    </transition-group>


    <el-dialog title="商品发货" :visible.sync="dialogDeliverGoods" width="600px" :close-on-click-modal="false">

      <div v-if="!deliverAdrList.length">
        <el-empty description="您名下暂无发货地址，请先去新增发货地址"></el-empty>
        <div style="display: flex;justify-content: center;align-items: center;">
          <el-button style="margin-bottom: 30px;" type="primary" @click="toAddAdr">先去新增地址</el-button>
        </div>
      </div>

      <div>
        <div v-for="adr in deliverAdrList" :key="adr.id">
          <div :style="{ border: adr.id === address.id ? '1px solid rgb(99, 101, 255)' : '' }" class="adr-item"
            @click="selectedAdr(adr)">
            <div>{{ adr.concatPerson }}</div>
            <div>{{ adr.concatPhone }}</div>
            <div>{{ adr.getAdr }}</div>
          </div>
        </div>
      </div>


      <span slot="footer" class="dialog-footer">
        <div>
          <el-button type="success" @click="goDeliver">立即发货</el-button>
          <el-button type="danger" @click="cannelDeliver">取消</el-button>
        </div>
      </span>

    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'BuyOrders',
  data() {
    return {
      address: {},
      ordersList: [],
      ordersQueryDto: {},
      orderInfo: {},
      dialogDeliverGoods: false,
      tradeStatusSelectedItem: {},
      tradeStatusList: [
        { tradeStatus: null, name: '全部' },
        { tradeStatus: true, name: '已支付' },
        { tradeStatus: false, name: '未支付' }
      ],
      deliverAdrList: [],
    }
  },
  created() {
    this.fetchOrders();
    this.tradeStatusSelected(this.tradeStatusList[0]);
  },
  methods: {
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
    async okRefund(orderInfo) {
      try {
        await this.$confirm('确定通过买家的退款申请?', '确认退款', {
          confirmButtonText: '确认',
          cancelButtonText: '取消',
          type: 'warning'
        });
        const orders = {
          id: orderInfo.id,
          refundStatus: 4, // 退款成功
          isRefundComfirm: true
        }
        await this.$axios.put(`/orders/update`, orders);
        this.$message.success('订单退款成功');
        this.fetchOrders();
      } catch (error) {
        console.log("订单退款异常");
      }
    },
    async rejectRefund(orderInfo) {
      try {
        await this.$confirm('拒绝买家的退款申请?', '确认拒绝', {
          confirmButtonText: '确认',
          cancelButtonText: '取消',
          type: 'warning'
        });
        const orders = {
          id: orderInfo.id,
          refundStatus: 3, // 退款成功
          isRefundComfirm: true
        }
        await this.$axios.put(`/orders/update`, orders);
        this.$message.success('订单拒绝退款成功');
        this.fetchOrders();
      } catch (error) {
        console.log("订单拒绝退款异常");
      }
    },
    cannelDeliver() {
      this.dialogDeliverGoods = false;
    },
    async goDeliver() {
      try {
        const ordersDeliverDto = {
          ordersId: this.orderInfo.id,
          deliverAdrId: this.address.id
        }
        const { data } = await this.$axios.post(`/product/deliverGoods`, ordersDeliverDto);
        this.$message.success(data.msg);
        this.dialogDeliverGoods = false;
        // 再去查询订单列表
        this.fetchOrders();
      } catch (error) {
        console.log("发货异常");
        this.$message.error("发货异常，发货地址查询异常");
      }
    },
    selectedAdr(adr) {
      this.address = adr;
    },
    // 前去收货地址页面
    toAddAdr() {
      this.$router.push('/address');
    },
    async openDeliver(orderInfo) {
      try {
        // 先去查询用户的收货地址
        const { data } = await this.$axios.post(`/address/queryUser`, {});
        this.deliverAdrList = data.data;
        if (this.deliverAdrList.length > 0) {
          // 先找出用户的默认地址
          const defaultAdr = this.deliverAdrList.find(adr => adr.isDefault);
          if (defaultAdr === undefined) {
            this.address = defaultAdr;
            return;
          }
          // 用户有地址，但是没有默认地址，设置第一项
          this.address = this.deliverAdrList[0];
        }
        this.orderInfo = orderInfo;
        this.dialogDeliverGoods = true;
      } catch (error) {
        console.log("发货异常");
        this.$message.error("发货异常，发货地址查询异常");
      }
    },
    /**
     * 立即发货
     * @param orderInfo 
     */
    async deliver(orderInfo) {
      try {
        const orders = {
          id: orderInfo.id,

        }
        const response = await this.$axios.put(`/orders/update`,);
        if (response.data.code === 200) {
          this.$message.success('删除成功');
          this.fetchOrders();
        }
      } catch (error) {
        console.log("发货异常");
      }
    },
    getOrderStatusText(order) {
      if (order.refundStatus && order.refundTime !== null) return '已退款';
      if (!order.refundStatus && order.refundTime === null) return '退款中';
      return order.tradeStatus ? '已支付' : '未支付';
    },

    tradeStatusSelected(tradeStatusItem) {
      console.log(tradeStatusItem);

      this.tradeStatusSelectedItem = tradeStatusItem;
      this.ordersQueryDto.tradeStatus = tradeStatusItem.tradeStatus;
      this.fetchOrders();
    },

    handleFilterClear() {
      this.ordersQueryDto.code = '';
      this.fetchOrders();
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

    async returnMoney(orders) {
      try {
        await this.$confirm('确认要退款吗?', '退款确认', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        });

        const response = await this.$axios.post(`/orders/returnMoney/${orders.id}`);
        if (response.data.code === 200) {
          this.$message.success('退款成功');
          this.fetchOrders();
        }
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error("退款异常");
          console.error("退款异常:", error);
        }
      }
    },

    coverParse(coverList) {
      if (!coverList.productCover) return '';
      return coverList.productCover.split(',')[0] || '';
    },

    fetchOrders() {
      this.$axios.post('/orders/queryOrdersList', this.ordersQueryDto).then(res => {
        const { data } = res;
        if (data.code === 200) {
          this.ordersList = data.data.map(order => ({
            id: order.id,
            code: order.code,
            productTitle: order.productTitle,
            detail: order.detail,
            buyPrice: order.buyPrice,
            buyNumber: order.buyNumber,
            tradeStatus: order.tradeStatus,
            tradeTime: order.tradeTime,
            refundStatus: order.refundStatus,
            refundTime: order.refundTime,
            isRefundConfirm: order.isRefundConfirm,
            createTime: order.createTime,
            cover: this.coverParse(order),
            isDeliver: order.isDeliver,
            deliverTime: order.deliverTime
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
.orders-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;

  .filter-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    background-color: #fff;
    padding: 15px;
    border-radius: 8px;
    // box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);

    .status-tabs {
      display: flex;
      gap: 10px;

      .status-tab {
        cursor: pointer;
        transition: all 0.3s;
        border-radius: 20px;

        &:hover {
          transform: translateY(-2px);
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
      }
    }

    .search-input {
      width: 300px;
    }
  }

  .empty-container {
    background-color: #fff;
    border-radius: 8px;
    padding: 40px 0;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  }

  .orders-container {
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

    // &:hover {
    //   // transform: translateY(-5px);
    //   box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
    // }


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

      .product-image {
        width: 120px;
        height: 120px;
        border-radius: 4px;
        overflow: hidden;
        flex-shrink: 0;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.5s;
        }

        &:hover img {
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

        .product-detail {
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

        .remark {
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

      .actions {
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


.adr-item {
  display: flex;
  gap: 10px;
  font-size: 16px;
  padding: 10px 20px;

  &:hover {
    background-color: rgb(240, 240, 240);
  }
}
</style>