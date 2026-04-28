<template>
    <div class="dashboard-container">
      <!-- 左侧统计和图表区域 -->
      <div class="dashboard-left">
        <!-- 统计卡片区域 -->
        <div class="stats-grid">
          <div 
            v-for="(stat, index) in staticCountList" 
            :key="index" 
            class="stat-card"
            :style="{ '--card-color': colorPalette[index % colorPalette.length] }">
            <div class="stat-title">{{ stat.name }}</div>
            <div class="stat-value">
              <el-statistic 
                group-separator="," 
                :precision="0" 
                :value="stat.count">
              </el-statistic>
            </div>
            <div class="stat-icon">
              <i :class="statIcons[index % statIcons.length]"></i>
            </div>
          </div>
        </div>
  
        <!-- 折线图区域 -->
        <div class="chart-container">
          <div class="chart-header">
            <span>商品上架趋势</span>
            <el-tag type="info" size="small">最近{{days}}天</el-tag>
          </div>
          <LineChart 
            @on-selected="onSelected" 
            tag="商品上架情况" 
            :values="values" 
            :date="dates" 
            height="400px" />
        </div>
      </div>
  
      <!-- 右侧最新商品区域 -->
      <div class="dashboard-right">
        <div class="product-header">
          <h2>最新上架商品</h2>
          <el-button 
            type="text" 
            icon="el-icon-refresh" 
            @click="fetchProductList">
            刷新
          </el-button>
        </div>
        
        <div class="product-list">
          <div 
            v-for="(product, index) in productList" 
            :key="index" 
            class="product-card"
            @click="route(product)">
            <div class="product-badge" v-if="product.isBargain">
              <span>砍价</span>
            </div>
            <div class="product-cover">
              <img :src="coverListParse(product)" :alt="product.name">
            </div>
            
            <div class="product-info">
              <div class="product-title">
                {{ product.name }}
              </div>
              
              <div class="product-meta">
                <div class="product-price">
                  <span class="price-symbol">¥</span>
                  <span class="price-value">{{ product.price }}</span>
                </div>
                <div class="product-likes">
                  <i class="el-icon-star-on"></i>
                  <span>{{ product.likeNumber }}人想要</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import LineChart from "@/components/LineChart"
  
  export default {
    components: { LineChart },
    data() {
      return {
        staticCountList: [],
        productList: [],
        values: [],
        dates: [],
        days: 365,
        colorPalette: [
          'linear-gradient(135deg, #6B73FF 0%, #000DFF 100%)',
          'linear-gradient(135deg, #FF6B6B 0%, #FF0000 100%)',
          'linear-gradient(135deg, #4BC0C8 0%, #00D4FF 100%)',
          'linear-gradient(135deg, #FFA500 0%, #FF7B00 100%)'
        ],
        statIcons: [
          'el-icon-s-goods',
          'el-icon-s-shop',
          'el-icon-s-order',
          'el-icon-s-custom'
        ]
      }
    },
    created() {
      this.fetchStaticCount();
      this.fetchProductList();
      this.onSelected(this.days);
    },
    methods: {
      route(product) {
        this.$router.push('/product-detail1?productId=' + product.id);
      },
      
      coverListParse(product) {
        if (!product.coverList) return '';
        const newCoverList = product.coverList.split(',');
        return newCoverList[0] || '';
      },
      
      onSelected(day) {
        this.$axios.get(`/dashboard/productShelvesInfo/${day}`).then(res => {
          const { data } = res;
          if (data.code === 200) {
            this.values = data.data.map(entity => entity.count);
            this.dates = data.data.map(entity => entity.name);
          }
        }).catch(error => {
          console.error("商品上架情况异常:", error);
        })
      },
      
      fetchStaticCount() {
        this.$axios.get('/dashboard/staticCount').then(res => {
          const { data } = res;
          if (data.code === 200) {
            this.staticCountList = data.data;
          }
        }).catch(error => {
          console.error("基础数据查询异常:", error);
        })
      },
      
      fetchProductList() {
        const productQueryDto = {
          size: 3,
          current: 1
        }
        this.$axios.post('/product/query', productQueryDto).then(res => {
          const { data } = res;
          if (data.code === 200) {
            this.productList = data.data;
          }
        }).catch(error => {
          console.error("查询商品信息异常:", error);
        })
      }
    }
  };
  </script>
  
  <style scoped lang="scss">
  .dashboard-container {
    display: flex;
    gap: 24px;
    padding: 24px;
    min-height: calc(100vh - 60px);
    background-color: #fff;
    box-sizing: border-box;
  }
  
  .dashboard-left {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 24px;
  }
  
  .dashboard-right {
    width: 360px;
    flex-shrink: 0;
  }
  
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 20px;
  }
  
  .stat-card {
    position: relative;
    padding: 24px;
    border-radius: 16px;
    background: var(--card-color);
    color: white;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    transition: transform 0.3s, box-shadow 0.3s;
    
    &:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
    }
    
    .stat-title {
      font-size: 16px;
      font-weight: 500;
      margin-bottom: 12px;
      opacity: 0.9;
    }
    
    .stat-value {
      font-size: 32px;
      font-weight: 700;
      
      ::v-deep .el-statistic__content {
        color: white;
        font-size: inherit;
        font-weight: inherit;
      }
    }
    
    .stat-icon {
      position: absolute;
      right: 24px;
      top: 24px;
      font-size: 48px;
      opacity: 0.2;
    }
  }
  
  .chart-container {
    flex: 1;
    display: flex;
    flex-direction: column;
    background: white;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
    
    .chart-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      
      span {
        font-size: 18px;
        font-weight: 600;
        color: #1e293b;
      }
    }
  }
  
  .product-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding: 0 8px;
    
    h2 {
      margin: 0;
      font-size: 18px;
      font-weight: 600;
      color: #1e293b;
    }
  }
  
  .product-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
  }
  
  .product-card {
    position: relative;
    background: white;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
    transition: all 0.3s;
    cursor: pointer;
    
    &:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
      
      .product-cover img {
        transform: scale(1.05);
      }
    }
    
    .product-badge {
      position: absolute;
      top: 12px;
      right: 12px;
      background: linear-gradient(135deg, #FFA500 0%, #FF7B00 100%);
      color: white;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      z-index: 2;
      box-shadow: 0 2px 8px rgba(255, 123, 0, 0.3);
    }
    
    .product-cover {
      height: 180px;
      overflow: hidden;
      
      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s;
      }
    }
    
    .product-info {
      padding: 16px;
      
      .product-title {
        font-size: 16px;
        font-weight: 600;
        color: #1e293b;
        margin-bottom: 12px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
        min-height: 48px;
      }
      
      .product-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;
        
        .product-price {
          .price-symbol {
            font-size: 14px;
            color: #f97316;
            font-weight: 600;
          }
          
          .price-value {
            font-size: 20px;
            color: #f97316;
            font-weight: 700;
          }
        }
        
        .product-likes {
          display: flex;
          align-items: center;
          gap: 6px;
          font-size: 14px;
          color: #64748b;
          
          i {
            color: #f43f5e;
          }
        }
      }
    }
  }
  
  @media (max-width: 1200px) {
    .dashboard-container {
      flex-direction: column;
    }
    
    .dashboard-right {
      width: 100%;
      margin-top: 24px;
    }
    
    .stats-grid {
      grid-template-columns: repeat(2, 1fr);
    }
  }
  
  @media (max-width: 768px) {
    .stats-grid {
      grid-template-columns: 1fr;
    }
    
    .dashboard-container {
      padding: 16px;
    }
    
    .stat-card {
      padding: 20px;
      
      .stat-value {
        font-size: 28px;
      }
      
      .stat-icon {
        font-size: 40px;
      }
    }
  }
  </style>