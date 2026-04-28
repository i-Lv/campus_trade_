<template>
    <div class="product-edit-container">
      <!-- 主标题 -->
      <h1 class="edit-title">修改商品信息</h1>
      
      <!-- 两栏布局 -->
      <div class="edit-layout">
        <!-- 左侧表单区域 -->
        <div class="form-section">
          <!-- 商品基本信息卡片 -->
          <div class="form-card">
            <h2 class="card-title">商品基本信息</h2>
            
            <div class="form-group">
              <label class="form-label">商品名称</label>
              <el-input 
                v-model="product.name" 
                placeholder="请输入商品名称" 
                class="form-input"
                clearable
              ></el-input>
            </div>
            
            <div class="form-group">
              <label class="form-label">商品价格</label>
              <el-input 
                v-model="product.price" 
                placeholder="请输入商品价格" 
                class="form-input"
                clearable
              >
                <template slot="prepend">¥</template>
              </el-input>
            </div>
            
            <div class="form-group">
              <label class="form-label">新旧程度</label>
              <div class="condition-slider">
                <el-slider
                  v-model="product.oldLevel"
                  :min="1"
                  :max="10"
                  :marks="conditionMarks"
                  show-stops
                ></el-slider>
                <div class="condition-value">{{ oldLevelText }}</div>
              </div>
            </div>
            
            <div class="form-group">
              <label class="form-label">商品库存</label>
              <el-input-number 
                v-model="product.inventory" 
                :min="1" 
                :max="10000" 
                class="inventory-input"
              ></el-input-number>
            </div>
            
            <div class="form-group">
              <label class="form-label">是否支持砍价</label>
              <el-switch 
                v-model="product.isBargain" 
                active-text="支持砍价" 
                inactive-text="不支持砍价"
                active-color="#13ce66"
              ></el-switch>
            </div>
          </div>
          
          <!-- 商品分类卡片 -->
          <div class="form-card">
            <h2 class="card-title">商品分类</h2>
            <div class="category-tags">
              <el-tag
                v-for="(category, index) in categoryList"
                :key="index"
                :type="categorySelected.id === category.id ? '' : 'info'"
                @click="categoryClick(category)"
                class="category-tag"
              >
                {{ category.name }}
              </el-tag>
            </div>
          </div>
        </div>
        
        <!-- 右侧上传和编辑区域 -->
        <div class="upload-section">
          <!-- 图片上传卡片 -->
          <div class="upload-card">
            <h2 class="card-title">商品图片</h2>
            <p class="upload-tip">建议上传1:1比例的图片，最多9张</p>
            
            <el-upload 
              action="http://localhost:21090/api/campus-product-sys/v1.0/file/upload"
              list-type="picture-card"
              :limit="9"
              :on-success="handlePictureCardSuccess"
              :on-preview="handlePictureCardPreview"
              :on-remove="handleRemove"
              :file-list="coverList"
              class="image-uploader"
            >
              <i class="el-icon-plus"></i>
            </el-upload>
            
            <el-dialog :visible.sync="dialogVisible">
              <img width="100%" :src="dialogImageUrl" alt="">
            </el-dialog>
          </div>
          
          <!-- 商品详情编辑器 -->
          <div class="editor-card">
            <h2 class="card-title">商品详情</h2>
            <Editor 
              height="400px" 
              :receiveContent="product.detail" 
              @on-receive="onReceive" 
            />
          </div>
          
          <!-- 修改按钮 -->
          <el-button 
            type="primary" 
            @click="editProduct" 
            class="edit-button"
            :loading="editing"
          >
            确认修改
          </el-button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import Editor from "@/components/Editor"
  import { getProductInfo } from "@/utils/storage"
  
  export default {
    components: { Editor },
    name: 'EditProduct',
    data() {
      return {
        product: {},
        editing: false,
        categorySelected: {},
        dialogImageUrl: '',
        dialogVisible: false,
        coverList: [],
        categoryList: [],
        conditionMarks: {
          1: '全新',
          5: '一般',
          10: '旧物'
        }
      }
    },
    computed: {
      oldLevelText() {
        if (this.product.oldLevel === 10) return '十成新';
        return `${this.product.oldLevel}成新`;
      }
    },
    created() {
      this.getStorageProductInfo();
      this.fetchCategoryList();
    },
    methods: {
      getStorageProductInfo() {
        this.product = getProductInfo();
        this.coverListParse(this.product);
      },
      
      coverListParse(product) {
        if (product.coverList) {
          this.coverList = product.coverList.split(',').map(coverEntity => ({
            uid: Date.now() + Math.floor(Math.random() * 10001),
            name: Date.now() + Math.floor(Math.random() * 10001),
            status: 'success',
            url: coverEntity
          }));
        }
      },
      
      async editProduct() {
        if (!this.validateForm()) return;
        
        this.editing = true;
        this.product.coverList = this.coverList.map(entity => entity.url).join(',');
        
        try {
          const res = await this.$axios.put('/product/update', this.product);
          if (res.data.code === 200) {
            this.$notify.success({
              title: '修改成功',
              message: res.data.msg,
              duration: 2000
            });
            this.$router.push('/myProduct');
          }
        } catch (error) {
          this.$notify.error({
            title: '修改失败',
            message: error.message || '修改商品时出错',
            duration: 2000
          });
          console.error("修改商品异常:", error);
        } finally {
          this.editing = false;
        }
      },
      
      validateForm() {
        if (!this.product.name) {
          this.$notify.warning({
            title: '提示',
            message: '请输入商品名称',
            duration: 1500
          });
          return false;
        }
        
        if (!this.product.price || isNaN(this.product.price)) {
          this.$notify.warning({
            title: '提示',
            message: '请输入有效的商品价格',
            duration: 1500
          });
          return false;
        }
        
        if (this.coverList.length === 0) {
          this.$notify.warning({
            title: '提示',
            message: '请上传商品图片',
            duration: 1500
          });
          return false;
        }
        
        if (!this.product.categoryId) {
          this.$notify.warning({
            title: '提示',
            message: '请选择商品分类',
            duration: 1500
          });
          return false;
        }
        
        return true;
      },
      
      onReceive(detail) {
        this.product.detail = detail;
      },
      
      categoryClick(category) {
        this.categorySelected = category;
        this.product.categoryId = category.id;
      },
      
      async fetchCategoryList() {
        try {
          const res = await this.$axios.post('/category/query', {});
          if (res.data.code === 200) {
            this.categoryList = res.data.data;
            // 设置当前商品的分类为选中状态
            if (this.product.categoryId) {
              const currentCategory = this.categoryList.find(c => c.id === this.product.categoryId);
              if (currentCategory) {
                this.categorySelected = currentCategory;
              }
            }
          }
        } catch (error) {
          console.error("查询商品类别信息异常:", error);
        }
      },
      
      handlePictureCardSuccess(file) {
        this.coverList.push({
          uid: Date.now() + Math.floor(Math.random() * 10001),
          name: Date.now() + Math.floor(Math.random() * 10001),
          status: 'success',
          url: file.data
        });
      },
      
      handleRemove(file, fileList) {
        this.coverList = fileList;
      },
      
      handlePictureCardPreview(file) {
        this.dialogImageUrl = file.url || (file.response && file.response.data);
        this.dialogVisible = true;
      }
    }
  }
  </script>
  
  <style scoped lang="scss">
  .product-edit-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    
    .edit-title {
      font-size: 24px;
      color: #333;
      margin-bottom: 30px;
      text-align: center;
      font-weight: 600;
    }
    
    .edit-layout {
      display: flex;
      gap: 20px;
      
      .form-section {
        flex: 1;
        min-width: 400px;
      }
      
      .upload-section {
        flex: 1;
        min-width: 400px;
      }
    }
    
    .form-card, .upload-card, .editor-card {
      background-color: #fff;
      border-radius: 12px;
      padding: 20px;
      margin-bottom: 20px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
      
      .card-title {
        font-size: 18px;
        color: #333;
        margin-bottom: 20px;
        font-weight: 600;
        position: relative;
        padding-left: 10px;
        
        &::before {
          content: '';
          position: absolute;
          left: 0;
          top: 4px;
          height: 16px;
          width: 4px;
          background-color: #409EFF;
          border-radius: 2px;
        }
      }
    }
    
    .form-group {
      margin-bottom: 20px;
      
      .form-label {
        display: block;
        font-size: 14px;
        color: #606266;
        margin-bottom: 10px;
        font-weight: 500;
      }
      
      .form-input {
        width: 100%;
      }
      
      .condition-slider {
        display: flex;
        align-items: center;
        gap: 20px;
        
        .el-slider {
          flex: 1;
        }
        
        .condition-value {
          min-width: 60px;
          text-align: center;
          font-size: 14px;
          color: #409EFF;
          font-weight: 500;
        }
      }
      
      .inventory-input {
        width: 150px;
      }
    }
    
    .category-tags {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      
      .category-tag {
        cursor: pointer;
        transition: all 0.3s;
        padding: 0 20px;
        height: 32px;
        line-height: 32px;
        
        &:hover {
          transform: translateY(-2px);
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
      }
    }
    
    .upload-tip {
      font-size: 12px;
      color: #909399;
      margin-bottom: 15px;
    }
    
    .editor-card {
      min-height: 500px;
    }
    
    .edit-button {
      width: 100%;
      height: 50px;
      font-size: 16px;
      margin-top: 20px;
      border-radius: 8px;
      background: linear-gradient(90deg, #67C23A, #85ce61);
      border: none;
      box-shadow: 0 4px 12px rgba(103, 194, 58, 0.3);
      transition: all 0.3s;
      
      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(103, 194, 58, 0.4);
      }
      
      &:active {
        transform: translateY(0);
      }
    }
  }
  
  /* 使用全局样式替代/deep/ */
  .image-uploader ::v-deep .el-upload {
    width: 100px;
    height: 100px;
    line-height: 100px;
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    transition: all 0.3s;
    
    &:hover {
      border-color: #409EFF;
    }
  }
  
  @media (max-width: 992px) {
    .edit-layout {
      flex-direction: column;
      
      .form-section, .upload-section {
        min-width: 100% !important;
      }
    }
  }
  </style>