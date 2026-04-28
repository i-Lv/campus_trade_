<template>
  <div class="product-page">
    <!-- 分类筛选区 -->
    <div class="filter-section">
      <div class="filter-container">
        <!-- 商品分类 -->
        <div class="category-filter">
          <div class="filter-title">筛选商品</div>
          <div class="category-tags">
            商品类别：
            <el-tag v-for="(category, index) in isUseCategoryList" :key="index"
              :type="categorySelectedItem.id === category.id ? '' : 'info'"
              :effect="categorySelectedItem.id === category.id ? 'dark' : 'plain'" @click="categorySelected(category)"
              class="category-tag">
              {{ category.name }}
            </el-tag>
          </div>
        </div>

        <!-- 筛选条件 -->
        <div class="advanced-filters">
          是否支持砍价：
          <div class="filter-group">
            <el-tag v-for="(bargain, index) in bargainStatus" :key="index"
              :type="bargainSelectedItem.isBargain === bargain.isBargain ? '' : 'info'"
              :effect="bargainSelectedItem.isBargain === bargain.isBargain ? 'dark' : 'plain'"
              @click="bargainSelected(bargain)" class="filter-tag">
              {{ bargain.name }}
            </el-tag>
          </div>
        </div>

      </div>
    </div>

    <!-- 商品列表 -->
    <div class="product-list-container">
      <el-empty v-if="productList.length === 0" description="暂无商品信息"></el-empty>

      <transition-group key="model-7" v-else name="product-list" tag="div" class="product-grid">
        <div
          :style="{ boxShadow: product.inventory === 0 ? '0 2px 10px rgba(142, 0, 0, 0.05)' : '', backgroundColor: product.inventory === 0 ? 'rgba(142, 0, 0,0.1)' : '' }"
          v-for="(product, index) in productList" :key="product.id" class="product-card" @click="route(product)">
          <div class="product-image-container">
            <transition name="fade">
              <img :src="coverListParse(product)" :alt="product.name" class="product-image">
            </transition>

            <div class="bargain-tag" v-if="product.isBargain">
              <span>支持砍价</span>
            </div>

            <div class="like-count">
              <i class="el-icon-star-on"></i>
              {{ product.likeNumber }}人想要
            </div>


            <div class="like-count1">
              <i class="el-icon-star-on"></i>
              库存{{ product.inventory }}
            </div>
          </div>

          <div class="product-info">
            <h3 class="product-title">{{ product.name }}</h3>

            <div class="price-section">
              <span class="price-symbol">¥</span>
              <span class="price-value">{{ product.price }}</span>
            </div>

            <div class="seller-info">
              <el-avatar :src="product.userAvatar" size="small"></el-avatar>
              <span class="seller-name">{{ product.userName }}</span>
            </div>
          </div>
        </div>
      </transition-group>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Product',
  data() {
    return {
      categoryList: [],
      isUseCategoryList: [],
      categorySelectedItem: {},
      productQueryDto: {},
      productList: [],
      bargainSelectedItem: {},
      searchTime: [],
      bargainStatus: [
        { isBargain: null, name: '全部' },
        { isBargain: true, name: '支持砍价' },
        { isBargain: false, name: '不支持砍价' }
      ]
    };
  },
  created() {
    this.fetchFreshData();
    this.fetchCategoryList();
    this.bargainSelected(this.bargainStatus[0]);
  },
  methods: {
    route(product) {
      this.$router.push('/product-detail?productId=' + product.id);
    },

    coverListParse(product) {
      if (!product.coverList) return '';
      const newCoverList = product.coverList.split(',');
      return newCoverList[0] || '';
    },

    bargainSelected(bargain) {
      this.bargainSelectedItem = bargain;
      this.productQueryDto.isBargain = bargain.isBargain;
      this.fetchFreshData();
    },

    async fetchFreshData() {
      let startTime = null;
      let endTime = null;

      if (this.searchTime && this.searchTime.length === 2) {
        startTime = `${this.searchTime[0]}T00:00:00`;
        endTime = `${this.searchTime[1]}T23:59:59`;
      }

      this.productQueryDto = {
        ...this.productQueryDto,
        startTime,
        endTime
      };

      try {
        const res = await this.$axios.post('/product/query', this.productQueryDto);
        if (res.data.code === 200) {
          this.productList = res.data.data;
        }
      } catch (error) {
        console.error("商品查询异常：", error);
        this.$message.error('获取商品列表失败');
      }
    },

    categorySelected(category) {
      this.categorySelectedItem = category;
      this.productQueryDto.categoryId = category.id;
      this.fetchFreshData();
    },

    fetchCategoryList() {
      this.$axios.post('/category/query', {}).then(res => {
        if (res.data.code === 200) {
          this.categoryList = res.data.data;
          this.isUseCategoryList = res.data.data.filter(category => category.isUse);
          this.isUseCategoryList.unshift({ id: null, name: '全部' });
          this.categorySelected(this.isUseCategoryList[0]);
        }
      }).catch(error => {
        console.error("商品类别查询异常：", error);
      });
    }
  }
};
</script>

<style scoped lang="scss">
.product-page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;

  .filter-section {
    background-color: #fff;
    border-radius: 12px;
    // box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
    margin-bottom: 20px;
    padding: 4px 20px;

    .filter-container {
      .category-filter {
        margin-bottom: 30px;

        .filter-title {
          font-size: 26px;
          font-weight: 600;
          color: #333;
          margin-bottom: 12px;
        }

        .category-tags {
          display: flex;
          flex-wrap: wrap;
          align-items: center;
          gap: 10px;

          .category-tag {
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            border-radius: 20px;

            &:hover {
              transform: translateY(-2px);
              box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }
          }
        }
      }

      .advanced-filters {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        gap: 15px;

        .filter-group {
          display: flex;
          align-items: center;
          gap: 10px;

          .filter-tag {
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            border-radius: 20px;

            &:hover {
              transform: translateY(-2px);
              box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }
          }

          .date-picker {
            width: 280px;
          }

          .category-select {
            width: 180px;
          }
        }
      }
    }
  }

  .product-list-container {
    .product-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;

      .product-list-move {
        transition: transform 0.5s;
      }

      .product-list-enter-active,
      .product-list-leave-active {
        transition: all 0.5s;
      }

      .product-list-enter,
      .product-list-leave-to {
        opacity: 0;
        transform: translateY(20px);
      }
    }

    .product-card {
      background-color: #fff;
      border-radius: 12px;
      overflow: hidden;
      // box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
      transition: all 0.3s;
      cursor: pointer;

      &:hover {
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);

        .product-image {
          transform: scale(1.05);
        }
      }

      .product-image-container {
        position: relative;
        height: 240px;
        overflow: hidden;
        background-color: #fff;

        .product-image {
          width: 100%;
          height: 100%;
          transition: transform 0.5s;
        }

        .bargain-tag {
          position: absolute;
          top: 10px;
          left: 10px;
          background-color: #ffcc00;
          color: #333;
          font-size: 12px;
          font-weight: bold;
          padding: 2px 6px;
          border-radius: 12px;
          box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .like-count1 {
          position: absolute;
          bottom: 10px;
          left: 10px;
          background-color: rgba(0, 0, 0, 0.6);
          color: #fff;
          font-size: 12px;
          padding: 4px 10px;
          border-radius: 12px;
          display: flex;
          align-items: center;

          i {
            margin-right: 5px;
            color: #ffcc00;
          }
        }

        .like-count {
          position: absolute;
          bottom: 10px;
          right: 10px;
          background-color: rgba(0, 0, 0, 0.6);
          color: #fff;
          font-size: 12px;
          padding: 4px 10px;
          border-radius: 12px;
          display: flex;
          align-items: center;

          i {
            margin-right: 5px;
            color: #ffcc00;
          }
        }
      }

      .product-info {
        padding: 15px;

        .product-title {
          margin: 0 0 10px 0;
          font-size: 16px;
          color: #333;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        .price-section {
          margin-bottom: 15px;

          .price-symbol {
            font-size: 14px;
            color: #ff4f24;
            font-weight: bold;
          }

          .price-value {
            font-size: 20px;
            color: #ff4f24;
            font-weight: bold;
          }
        }

        .seller-info {
          display: flex;
          align-items: center;
          gap: 8px;

          .seller-name {
            font-size: 14px;
            color: #666;
          }
        }
      }
    }
  }
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s;
}

.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>