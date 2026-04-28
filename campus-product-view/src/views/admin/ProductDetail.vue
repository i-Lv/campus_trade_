<template>
    <div class="product-detail">
      <!-- 商品主区域 -->
      <div class="product-main">
        <!-- 商品图片展示区 -->
        <div class="product-gallery">
          <!-- 缩略图列表 -->
          <div class="thumbnail-list">
            <div
              v-for="(coverItem, index) in coverList"
              :key="index"
              class="thumbnail-item"
              :class="{ active: coverIndex === index }"
              @click="coverSelected(coverItem, index)"
            >
              <img :src="coverItem" alt="商品缩略图">
            </div>
          </div>
          
          <!-- 主图展示 -->
          <div class="main-image-container">
            <transition name="fade" mode="out-in">
              <img 
                :key="coverItem"
                :src="coverItem" 
                alt="商品主图"
                class="main-image"
              >
            </transition>
            
            <!-- 导航箭头 -->
            <div class="image-nav">
              <div class="nav-arrow left" @click="coverToLeft">
                <i class="el-icon-arrow-left"></i>
              </div>
              <div class="nav-arrow right" @click="coverToRight">
                <i class="el-icon-arrow-right"></i>
              </div>
            </div>
            
            <!-- 砍价标签 -->
            <div class="bargain-tag" v-if="product.isBargain">
              支持砍价
            </div>
          </div>
        </div>
        
        <!-- 商品信息区 -->
        <div class="product-info">
          <h1 class="product-title">{{ product.name }}</h1>
          
          <!-- 价格信息 -->
          <div class="price-section">
            <span class="price">
              <span class="symbol">¥</span>
              <span class="value">{{ product.price }}</span>
            </span>
            
            <div class="meta-info">
              <span class="category">{{ product.categoryName }}</span>
              <span class="condition">{{ product.oldLevel }}成新</span>
              <span class="inventory">库存 {{ product.inventory }}件</span>
            </div>
          </div>
          
          <!-- 用户互动数据 -->
          <div class="interaction-stats">
            <div class="stat-item">
              <i class="el-icon-view"></i>
              <span>{{ product.viewNumber }}人浏览</span>
            </div>
            <div class="stat-item">
              <i class="el-icon-star-off"></i>
              <span>{{ product.saveNumber }}人收藏</span>
            </div>
            <div class="stat-item">
              <i class="el-icon-sell"></i>
              <span>{{ product.likeNumber }}人想要</span>
            </div>
          </div>
          
          <!-- 卖家信息 -->
          <div class="seller-info">
            <el-avatar :src="product.userAvatar" size="medium"></el-avatar>
            <span class="seller-name">{{ product.userName }}</span>
          </div>
          
          <!-- 操作按钮 -->
          <div class="action-buttons">
            <el-button 
              type="warning" 
              icon="el-icon-star-off" 
              @click="saveOperation"
              :class="{ 'is-saved': saveFlag }"
            >
              {{ saveFlag ? '已收藏' : '收藏' }}
            </el-button>
            
            <el-button 
              type="primary" 
              icon="el-icon-sell" 
              @click="likeProduct"
            >
              我想要
            </el-button>
            
            <el-button 
              type="danger" 
              icon="el-icon-shopping-cart-2" 
              @click="buyProduct"
            >
              立即购买
            </el-button>
          </div>
        </div>
      </div>
      
      <!-- 商品详情 -->
      <div class="product-detail-content">
        <h2 class="section-title">商品详情</h2>
        <div class="detail-html" v-html="product.detail"></div>
      </div>
      
      <!-- 商品评价 -->
      <div class="product-reviews" v-if="userInfo !== null">
        <h2 class="section-title">商品评价</h2>
        <Evaluations contentType="PRODUCT" :contentId="product.id" />
      </div>
      
      <!-- 购买对话框 -->
      <el-dialog 
        :visible.sync="dialogProductOperaion" 
        title="确认订单"
        width="500px"
        center
      >
        <div class="order-dialog">
          <div class="product-info">
            <div class="price-section">
              <span class="price">
                <span class="symbol">¥</span>
                <span class="value">{{ product.price }}</span>
              </span>
              <span class="inventory">库存 {{ product.inventory }}件</span>
            </div>
            <h3 class="product-title">{{ product.name }}</h3>
            <div class="seller-info">
              <el-avatar :src="product.userAvatar" size="small"></el-avatar>
              <span class="seller-name">{{ product.userName }}</span>
            </div>
          </div>
          
          <div class="order-form">
            <div class="form-item">
              <label>购买数量</label>
              <el-input-number 
                v-model="buyNumber" 
                :min="1" 
                :max="product.inventory"
                controls-position="right"
              ></el-input-number>
            </div>
            
            <div class="form-item">
              <label>备注信息</label>
              <el-input
                type="textarea"
                :rows="3"
                placeholder="请输入备注信息（选填）"
                v-model="detail"
              ></el-input>
            </div>
          </div>
        </div>
        
        <span slot="footer" class="dialog-footer">
          <el-button @click="cannelBuy">取消</el-button>
          <el-button type="primary" @click="buyConfirm">确认下单</el-button>
        </span>
      </el-dialog>
    </div>
  </template>
  
  <script>
  import { getUserInfo } from "@/utils/storage"
  import Evaluations from "@/components/Evaluations"
  
  export default {
    components: { Evaluations },
    name: 'ProductDetail',
    data() {
      return {
        productId: null,
        product: {},
        coverList: [],
        coverIndex: 0,
        coverItem: null,
        keyInterval: null,
        saveFlag: false,
        dialogProductOperaion: false,
        buyNumber: 1,
        detail: '',
        userInfo: null
      }
    },
    created() {
      this.getParam();
      this.viewOperation();
    },
    beforeDestroy() {
      this.clearBanner();
    },
    methods: {

      viewOperation() {
        const userInfo = getUserInfo();
        if (!userInfo) return;
        
        this.userInfo = userInfo;
        this.$axios.post(`/interaction/view/${this.productId}`).catch(error => {
          console.error("浏览记录异常：", error);
        })
      },
      
      buyConfirm() {
        const ordersDTO = {
          productId: this.product.id,
          buyNumber: this.buyNumber,
          detail: this.detail
        }
        
        this.$axios.post(`/product/buyProduct`, ordersDTO).then(res => {
          const { data } = res;
          if (data.code === 200) {
            this.$message.success(data.msg);
            this.fetchProduct(this.product.id);
            this.cannelBuy();
          } else {
            this.$message.error(data.msg);
          }
        }).catch(error => {
          this.$message.error('下单失败');
          console.error("商品下单异常：", error);
        })
      },
      
      cannelBuy() {
        this.dialogProductOperaion = false;
        this.buyNumber = 1;
        this.detail = '';
      },
      
      buyProduct() {
        this.dialogProductOperaion = true;
      },
      
      likeProduct() {
        this.$axios.post(`/interaction/likeProduct/${this.product.id}`).then(res => {
          const { data } = res;
          if (data.code === 200) {
            this.$message.success(data.msg);
            this.fetchProduct(this.product.id);
          } else {
            this.$message.info(data.msg);
          }
        }).catch(error => {
          console.error("商品想要异常：", error);
        })
      },
      
      querySaveStatus() {
        const userInfo = getUserInfo();
        if (!userInfo) return;
        
        const interactionQueryDto = {
          userId: userInfo.id,
          productId: this.product.id,
          type: 1
        };
        
        this.$axios.post('/interaction/query', interactionQueryDto).then(res => {
          const { data } = res;
          if (data.code === 200) {
            this.saveFlag = data.total !== 0;
          }
        }).catch(error => {
          console.error("收藏状态查询异常：", error);
        })
      },
      
      saveOperation() {
        this.$axios.post(`/interaction/saveOperation/${this.product.id}`).then(res => {
          const { data } = res;
          if (data.code === 200) {
            this.saveFlag = data.data;
            this.$message.success(data.msg);
            this.fetchProduct(this.product.id);
          }
        }).catch(error => {
          console.error("收藏操作异常：", error);
        })
      },
      
      clearBanner() {
        if (this.keyInterval) {
          clearInterval(this.keyInterval);
          this.keyInterval = null;
        }
      },
      
      startBanner() {
        this.keyInterval = setInterval(() => {
          this.coverIndex = (this.coverIndex + 1) % this.coverList.length;
          this.coverItem = this.coverList[this.coverIndex];
        }, 5000);
      },
      
      coverToLeft() {
        this.coverIndex = (this.coverIndex - 1 + this.coverList.length) % this.coverList.length;
        this.coverItem = this.coverList[this.coverIndex];
      },
      
      coverToRight() {
        this.coverIndex = (this.coverIndex + 1) % this.coverList.length;
        this.coverItem = this.coverList[this.coverIndex];
      },
      
      coverSelected(coverItem, index) {
        this.coverItem = coverItem;
        this.coverIndex = index;
      },
      
      getParam() {
        const param = this.$route.query;
        this.productId = Number(param.productId);
        this.fetchProduct(this.productId);
      },
      
      coverListParse(product) {
        if (!product.coverList) return;
        
        this.coverList = product.coverList.split(',');
        this.coverItem = this.coverList[0];
        this.startBanner();
      },
      
      fetchProduct(productId) {
        this.$axios.post('/product/query', { id: productId }).then(res => {
          const { data } = res;
          if (data.code === 200) {
            this.product = data.data[0];
            this.coverListParse(this.product);
            this.querySaveStatus();
          }
        }).catch(error => {
          console.error("商品查询异常：", error);
        })
      }
    }
  }
  </script>
  
  <style scoped lang="scss">
  .product-detail {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    
    .product-main {
      display: flex;
      gap: 40px;
      margin-bottom: 40px;
      
      .product-gallery {
        width: 480px;
        display: flex;
        gap: 20px;
        
        .thumbnail-list {
          width: 80px;
          
          .thumbnail-item {
            width: 80px;
            height: 80px;
            margin-bottom: 10px;
            border: 1px solid #e5e5e5;
            border-radius: 4px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s;
            
            &.active {
              border-color: #ff6b6b;
            }
            
            &:hover {
              border-color: #ff6b6b;
            }
            
            img {
              width: 100%;
              height: 100%;
              object-fit: cover;
            }
          }
        }
        
        .main-image-container {
          flex: 1;
          position: relative;
          
          .main-image {
            width: 100%;
            height: 400px;
            object-fit: contain;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
          }
          
          .image-nav {
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            display: flex;
            justify-content: space-between;
            transform: translateY(-50%);
            
            .nav-arrow {
              width: 40px;
              height: 40px;
              background-color: rgba(255, 255, 255, 0.8);
              border-radius: 50%;
              display: flex;
              align-items: center;
              justify-content: center;
              cursor: pointer;
              transition: all 0.3s;
              
              &:hover {
                background-color: rgba(255, 107, 107, 0.8);
                color: white;
              }
              
              i {
                font-size: 18px;
                font-weight: bold;
              }
            }
          }
          
          .bargain-tag {
            position: absolute;
            top: 10px;
            left: 10px;
            background-color: #ffcc00;
            color: #333;
            font-size: 12px;
            font-weight: bold;
            padding: 4px 10px;
            border-radius: 12px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
          }
        }
      }
      
      .product-info {
        flex: 1;
        
        .product-title {
          font-size: 24px;
          color: #333;
          margin-bottom: 20px;
          font-weight: 600;
        }
        
        .price-section {
          margin-bottom: 20px;
          padding-bottom: 20px;
          border-bottom: 1px solid #f0f0f0;
          
          .price {
            display: block;
            margin-bottom: 10px;
            
            .symbol {
              font-size: 16px;
            }
            
            .value {
              font-size: 28px;
              font-weight: bold;
              color: #ff4f24;
            }
          }
          
          .meta-info {
            display: flex;
            gap: 15px;
            font-size: 14px;
            color: #666;
            
            span {
              position: relative;
              
              &:not(:last-child)::after {
                content: "";
                position: absolute;
                right: -8px;
                top: 50%;
                transform: translateY(-50%);
                width: 4px;
                height: 4px;
                background-color: #999;
                border-radius: 50%;
              }
            }
          }
        }
        
        .interaction-stats {
          display: flex;
          gap: 20px;
          margin-bottom: 20px;
          
          .stat-item {
            display: flex;
            align-items: center;
            font-size: 14px;
            color: #666;
            
            i {
              margin-right: 5px;
              font-size: 16px;
            }
          }
        }
        
        .seller-info {
          display: flex;
          align-items: center;
          gap: 10px;
          margin-bottom: 30px;
          
          .seller-name {
            font-size: 14px;
            color: #333;
          }
        }
        
        .action-buttons {
          display: flex;
          gap: 15px;
          
          .el-button {
            flex: 1;
            height: 46px;
            font-size: 16px;
            
            &.is-saved {
              background-color: #67c23a;
              border-color: #67c23a;
            }
          }
        }
      }
    }
    
    .product-detail-content,
    .product-reviews {
      background-color: #fff;
      border-radius: 8px;
      padding: 20px;
      margin-bottom: 20px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
      
      .section-title {
        font-size: 18px;
        color: #333;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 1px solid #f0f0f0;
      }
      
      .detail-html {
        line-height: 1.6;
        
        img {
          max-width: 100%;
          height: auto;
        }
      }
    }
    
    .order-dialog {
      .product-info {
        margin-bottom: 20px;
        padding-bottom: 20px;
        border-bottom: 1px solid #f0f0f0;
        
        .product-title {
          font-size: 16px;
          margin: 10px 0;
        }
        
        .seller-info {
          display: flex;
          align-items: center;
          gap: 8px;
          margin-top: 10px;
          
          .seller-name {
            font-size: 14px;
            color: #666;
          }
        }
      }
      
      .form-item {
        margin-bottom: 20px;
        
        label {
          display: block;
          margin-bottom: 8px;
          font-size: 14px;
          color: #666;
        }
      }
    }
  }
  
  .fade-enter-active, .fade-leave-active {
    transition: opacity 0.5s;
  }
  .fade-enter, .fade-leave-to {
    opacity: 0;
  }
  </style>