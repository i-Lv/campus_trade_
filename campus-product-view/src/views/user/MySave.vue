<template>
    <div class="product-container">
      <!-- 商品列表标题 -->
      <div class="product-header">
        <h2 class="product-title">我的商品</h2>
      </div>
  
      <!-- 商品列表内容 -->
      <div class="product-content">
        <!-- 加载状态 -->
        <div v-if="loading" class="loading-state">
          <el-skeleton :rows="6" animated />
        </div>
  
        <!-- 空状态 -->
        <div v-else-if="productList.length === 0" class="empty-state">
          <el-empty description="暂无商品信息">
            <el-button 
              type="primary" 
              @click="$router.push('/post-product')"
              class="empty-button">
              发布新商品
            </el-button>
          </el-empty>
        </div>
  
        <!-- 商品列表 -->
        <el-row :gutter="20" v-else>
          <el-col 
            :xs="24" :sm="12" :md="8" :lg="6" 
            v-for="(product, index) in productList" 
            :key="index">
            <div class="product-card">
              <!-- 商品封面 -->
              <div class="product-cover" @click="goToProductDetail(product)">
                <img :src="getProductCover(product)" :alt="product.name">
                <span class="bargain-tag" :class="{'bargain-active': product.isBargain}">
                  {{ product.isBargain ? '支持砍价' : '不支持砍价' }}
                </span>
              </div>
  
              <!-- 商品信息 -->
              <div class="product-info">
                <h3 class="product-name" @click="goToProductDetail(product)">
                  {{ product.name }}
                </h3>
                
                <div class="product-price">
                  <span class="price-symbol">¥</span>
                  <span class="price-value">{{ product.price }}</span>
                </div>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>
    </div>
  </template>
  
  <script>
  import { setProductInfo } from "@/utils/storage";
  
  export default {
    name: 'MyProductList',
    data() {
      return {
        productList: [],
        loading: true
      };
    },
    created() {
      this.fetchProducts();
    },
    methods: {
      // 跳转到商品详情页
      goToProductDetail(product) {
        this.$router.push(`/product-detail?productId=${product.id}`);
      },
  
      // 获取商品封面图
      getProductCover(product) {
        if (!product.coverList) return '';
        const covers = product.coverList.split(',');
        return covers[0] || '';
      },
  
      // 获取商品列表
      async fetchProducts() {
        this.loading = true;
        try {
          const response = await this.$axios.post('/interaction/queryUser');
          
          if (response.data.code === 200) {
            this.productList = Array.isArray(response.data.data) 
              ? response.data.data 
              : [];
          }
        } catch (error) {
          console.error("商品查询异常:", error);
          this.$message.error('获取商品列表失败');
        } finally {
          this.loading = false;
        }
      }
    }
  };
  </script>
  
  <style scoped lang="scss">
  .product-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
  }
  
  .product-header {
    margin-bottom: 30px;
    border-bottom: 1px solid #eee;
    padding-bottom: 15px;
  
    .product-title {
      font-size: 24px;
      color: #333;
      margin: 0;
    }
  }
  
  .loading-state {
    padding: 40px 0;
  }
  
  .empty-state {
    margin: 50px 0;
  
    .empty-button {
      margin-top: 20px;
    }
  }
  
  .product-card {
    background: #fff;
    border-radius: 8px;
    overflow: hidden;
    margin-bottom: 20px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
    transition: all 0.3s;
    cursor: pointer;
  
    &:hover {
      transform: translateY(-5px);
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }
  }
  
  .product-cover {
    position: relative;
    height: 240px;
  
    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }
  
    .bargain-tag {
      position: absolute;
      top: 10px;
      left: 10px;
      background: rgba(255, 230, 15, 0.9);
      color: #333;
      padding: 3px 8px;
      font-size: 12px;
      border-radius: 4px;
      font-weight: bold;
  
      &.bargain-active {
        background: rgba(255, 150, 0, 0.9);
        color: white;
      }
    }
  }
  
  .product-info {
    padding: 15px;
  
    .product-name {
      font-size: 16px;
      margin: 0 0 10px;
      color: #333;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
  }
  
  .product-price {
    display: flex;
    align-items: center;
  
    .price-symbol {
      color: #ff4f24;
      font-weight: bold;
      font-size: 14px;
    }
  
    .price-value {
      color: #ff4f24;
      font-weight: bold;
      font-size: 20px;
      margin-left: 5px;
    }
  }
  
  @media (max-width: 768px) {
    .product-cover {
      height: 180px;
    }
  }
  </style>