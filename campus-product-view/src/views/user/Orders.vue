<template>
    <div class="orders-container">
      <!-- 自定义导航标签 -->
      <div class="custom-tabs">
        <div 
          class="tab-item"
          :class="{ 'active': activeName === 'first' }"
          @click="activeName = 'first'"
        >
          <span class="tab-icon">
            <i class="el-icon-shopping-cart-2"></i>
          </span>
          <span class="tab-label">购物订单</span>
          <div class="tab-indicator"></div>
        </div>
        
        <div 
          class="tab-item"
          :class="{ 'active': activeName === 'second' }"
          @click="activeName = 'second'"
        >
          <span class="tab-icon">
            <i class="el-icon-tickets"></i>
          </span>
          <span class="tab-label">我的订单</span>
          <div class="tab-indicator"></div>
        </div>
        
        <div class="tab-highlight" :style="highlightStyle"></div>
      </div>
      
      <!-- 内容区域 -->
      <div class="tab-content">
        <transition name="fade" mode="out-in">
          <keep-alive>
            <component :is="activeComponent"></component>
          </keep-alive>
        </transition>
      </div>
    </div>
  </template>
  
  <script>
  import BuyOrders from "@/views/user/BuyOrders"
  import MyOrders from "@/views/user/MyOrders"
  
  export default {
    components: { BuyOrders, MyOrders },
    name: 'Orders',
    data() {
      return {
        activeName: 'first'
      }
    },
    computed: {
      activeComponent() {
        return this.activeName === 'first' ? BuyOrders : MyOrders
      },
      highlightStyle() {
        const index = this.activeName === 'first' ? 0 : 1
        return {
          transform: `translateX(${index * 100}%)`,
          width: '50%'
        }
      }
    }
  }
  </script>
  
  <style scoped lang="scss">
  .orders-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
  }
  
  .custom-tabs {
    position: relative;
    display: flex;
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    margin-bottom: 30px;
    overflow: hidden;
    
    .tab-item {
      flex: 1;
      text-align: center;
      padding: 20px 0;
      cursor: pointer;
      position: relative;
      z-index: 1;
      transition: all 0.3s ease;
      
      &:hover:not(.active) {
        background-color: rgba(64, 158, 255, 0.05);
      }
      
      &.active {
        .tab-icon {
          color: #409EFF;
          transform: translateY(-5px);
        }
        
        .tab-label {
          color: #409EFF;
          font-weight: 600;
        }
      }
      
      .tab-icon {
        display: block;
        font-size: 24px;
        margin-bottom: 8px;
        color: #909399;
        transition: all 0.3s cubic-bezier(0.68, -0.55, 0.27, 1.55);
      }
      
      .tab-label {
        font-size: 16px;
        color: #606266;
        transition: all 0.3s;
      }
      
      .tab-indicator {
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 0;
        height: 3px;
        background-color: #409EFF;
        transition: all 0.3s;
      }
    }
    
    .tab-highlight {
      position: absolute;
      top: 0;
      left: 0;
      height: 100%;
      background-color: rgba(64, 158, 255, 0.1);
      transition: all 0.4s cubic-bezier(0.65, 0, 0.35, 1);
      border-radius: 12px;
    }
  }
  
  .tab-content {
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    min-height: 500px;
  }
  
  .fade-enter-active, .fade-leave-active {
    transition: opacity 0.3s;
  }
  .fade-enter, .fade-leave-to {
    opacity: 0;
  }
  
  @media (max-width: 768px) {
    .custom-tabs {
      .tab-item {
        padding: 15px 0;
        
        .tab-icon {
          font-size: 20px;
        }
        
        .tab-label {
          font-size: 14px;
        }
      }
    }
  }
  </style>