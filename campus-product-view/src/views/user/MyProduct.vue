<template>
    <div class="product-management">
      <!-- 头部标题和操作按钮 -->
      <div class="header-section">
        <h2 class="page-title">我的商品</h2>
        <el-button 
          type="primary" 
          icon="el-icon-plus" 
          @click="$router.push('/post-product')"
          class="add-button">
          发布新商品
        </el-button>
      </div>
  
      <!-- 商品列表 -->
      <div v-if="loading" class="loading-container">
        <el-skeleton :rows="6" animated />
      </div>
  
      <div v-else-if="productList.length === 0" class="empty-container">
        <el-empty description="暂无商品信息">
          <el-button 
            type="primary" 
            @click="$router.push('/post-product')"
            class="empty-button">
            发布我的第一个商品
          </el-button>
        </el-empty>
      </div>
  
      <el-row :gutter="20" v-else>
        <el-col 
          :xs="24" :sm="12" :md="8" :lg="6" 
          v-for="(product, index) in productList" 
          :key="index">
          <div class="product-card">
            <!-- 商品封面 -->
            <div class="product-cover" @click="route(product)">
              <img :src="getCoverImage(product)" alt="商品封面">
              <div class="bargain-tag" :class="{'active': product.isBargain}">
                {{ product.isBargain ? '支持砍价' : '不支持砍价' }}
              </div>
            </div>
  
            <!-- 商品信息 -->
            <div class="product-info">
              <h3 class="product-title" @click="route(product)">
                {{ product.name }}
              </h3>
              
              <div class="price-section">
                <span class="price-symbol">¥</span>
                <span class="price-value">{{ product.price }}</span>
                <span class="like-count">{{ product.likeNumber }}人想要</span>
              </div>
  
              <!-- 操作按钮 -->
              <div class="action-buttons">
                <el-button 
                  size="mini" 
                  @click="handleEdit(product)"
                  class="delete-button customer">
                  编辑
                </el-button>
                <el-button 
                  size="mini" 
                  @click="handleDelete(product)"
                  class="delete-button customer">
                  删除
                </el-button>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
  </template>
  
  <script>
  import { setProductInfo } from "@/utils/storage";
  
  export default {
    name: 'MyProduct',
    data() {
      return {
        productList: [],
        loading: true
      };
    },
    created() {
      this.fetchProduct();
    },
    methods: {
      // 跳转到商品详情
      route(product) {
        this.$router.push(`/product-detail?productId=${product.id}`);
      },
  
      // 编辑商品
      handleEdit(product) {
        setProductInfo(product);
        this.$router.push('/edit-product');
      },
  
      // 删除商品
      async handleDelete(product) {
        try {
          await this.$confirm(`确定要删除【${product.name}】商品吗？`, '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          });
  
          const response = await this.$axios.post('/product/batchDelete', [product.id]);
          
          if (response.data.code === 200) {
            this.$message.success('商品删除成功');
            this.fetchProduct();
          }
        } catch (error) {
          if (error !== 'cancel') {
            this.$message.error('删除失败: ' + (error.message || error));
            console.error('商品删除异常:', error);
          }
        }
      },
  
      // 获取商品封面图
      getCoverImage(product) {
        if (!product.coverList) return '';
        const covers = product.coverList.split(',');
        return covers[0] || '';
      },
  
      // 获取商品列表
      async fetchProduct() {
        this.loading = true;
        try {
          const response = await this.$axios.post('/product/queryUser', {});
          
          if (response.data.code === 200) {
            // 确保返回的是数组格式
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
  .product-management {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
  }
  
  .header-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
  
    .page-title {
      font-size: 24px;
      color: #333;
      margin: 0;
    }
  
    .add-button {
      padding: 10px 20px;
    }
  }
  
  .loading-container {
    padding: 40px 0;
  }
  
  .empty-container {
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
  
    &:hover {
      transform: translateY(-5px);
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }
  }
  
  .product-cover {
    position: relative;
    cursor: pointer;
  
    img {
      width: 100%;
      height: 200px;
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
  
      &.active {
        background: rgba(255, 150, 0, 0.9);
        color: white;
      }
    }
  }
  
  .product-info {
    padding: 15px;
  
    .product-title {
      font-size: 16px;
      margin: 0 0 10px;
      color: #333;
      cursor: pointer;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
  
      &:hover {
        color: #409EFF;
      }
    }
  }
  
  .price-section {
    display: flex;
    align-items: center;
    margin: 10px 0;
  
    .price-symbol {
      color: #ff4f24;
      font-weight: bold;
      font-size: 14px;
    }
  
    .price-value {
      color: #ff4f24;
      font-weight: bold;
      font-size: 20px;
      margin: 0 10px 0 5px;
    }
  
    .like-count {
      color: #999;
      font-size: 13px;
    }
  }
  
  .action-buttons {
    display: flex;
    justify-content: space-between;
    margin-top: 15px;
  
    .edit-button {
      flex: 1;
      margin-right: 10px;
    }
  
    .delete-button {
      flex: 1;
      color: #F56C6C;
      border-color: #F56C6C;
  
      &:hover {
        background: #fef0f0;
      }
    }
  }
  
  @media (max-width: 768px) {
    .header-section {
      flex-direction: column;
      align-items: flex-start;
  
      .add-button {
        margin-top: 15px;
        width: 100%;
      }
    }
  
    .product-cover img {
      height: 150px;
    }
  }
  </style>