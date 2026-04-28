<template>
    <div class="card-container">
        <!-- 筛选卡片 -->
        <el-card class="filter-card" shadow="never">
            <div class="filter-content">
                <div class="filter-tabs">
                    <el-radio-group v-model="bargainSelectedItem" @change="bargainSelected">
                        <el-radio-button v-for="(bargain, index) in bargainStatus" :key="index" :label="bargain">
                            {{ bargain.name }}
                        </el-radio-button>
                    </el-radio-group>
                </div>

                <div class="filter-controls">
                    <el-select class="filter-item" @change="fetchFreshData" v-model="productQueryDto.categoryId"
                        placeholder="商品类别" size="small">
                        <el-option v-for="item in categoryList" :key="item.id" :label="item.name" :value="item.id">
                        </el-option>
                    </el-select>

                    <el-date-picker class="filter-item" @change="fetchFreshData" v-model="searchTime" type="daterange"
                        range-separator="至" start-placeholder="发布开始" end-placeholder="发布结束" size="small">
                    </el-date-picker>

                    <el-input class="filter-item" v-model="productQueryDto.name" placeholder="商品名" clearable
                        @clear="handleFilterClear" size="small">
                        <el-button slot="append" @click="handleFilter" icon="el-icon-search"></el-button>
                    </el-input>
                </div>
            </div>
        </el-card>

        <!-- 商品列表卡片 -->
        <el-card class="product-card" shadow="never">
            <div v-for="product in tableData" :key="product.id" class="product-item">
                <div class="product-header">
                    <el-avatar :size="40" :src="product.userAvatar"></el-avatar>
                    <div class="user-info">
                        <div class="user-name">{{ product.userName }}</div>
                        <div class="create-time">{{ product.createTime }}</div>
                    </div>
                </div>

                <div class="product-content">
                    <div class="product-images" v-if="product.coverList">
                        <el-image v-for="(img, idx) in product.coverList.split(',')" :key="idx" :src="img"
                            :preview-src-list="product.coverList.split(',')" fit="cover" class="product-image">
                        </el-image>
                    </div>

                    <div class="product-details">
                        <h3 class="product-title">{{ product.name }}</h3>
                        <div class="product-meta">
                            <el-tag size="small">{{ product.categoryName }}</el-tag>
                            <el-tag size="small" type="info">{{ product.oldLevel }}成新</el-tag>
                            <el-tag size="small" :type="product.isBargain ? 'success' : 'warning'">
                                {{ product.isBargain ? '支持砍价' : '不支持砍价' }}
                            </el-tag>
                        </div>
                        <div class="product-price">
                            <span class="price">{{ product.price }}元</span>
                            <span class="inventory">库存: {{ product.inventory }}</span>
                        </div>
                        <div class="product-actions">
                            <el-button class="customer" size="mini" type="primary"
                                @click="handleEdit(product)">查看详情</el-button>
                            <el-button class="customer" size="mini" type="danger"
                                @click="handleDelete(product)">删除</el-button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 分页 -->
            <div class="pagination-container">
                <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                    :current-page="currentPage" :page-sizes="[10, 20]" :page-size="pageSize"
                    layout="total, sizes, prev, pager, next, jumper" :total="totalItems">
                </el-pagination>
            </div>
        </el-card>

        <!-- 商品详情抽屉 -->
        <el-drawer title="商品详情" :visible.sync="drawerProductOperaion" :direction="direction" size="40%">
            <div class="drawer-content">
                <el-card shadow="never">
                    <div slot="header">
                        <span>产品封面图</span>
                    </div>
                    <div class="detail-cover">
                        <el-image v-for="(cover, index) in coverList" :key="index" :src="cover"
                            :preview-src-list="coverList" fit="cover" class="cover-image">
                        </el-image>
                    </div>
                </el-card>

                <el-card shadow="never" style="margin-top: 20px;">
                    <div slot="header">
                        <span>商品详情</span>
                    </div>
                    <div class="product-detail" v-html="data.detail"></div>
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
            productQueryDto: {},
            direction: 'rtl',
            categoryList: [],
            bargainSelectedItem: {},
            bargainStatus: [
                { isBargain: null, name: '全部' },
                { isBargain: true, name: '支持砍价' },
                { isBargain: false, name: '不支持砍价' }
            ]
        };
    },
    created() {
        this.fetchCategoryList();
        this.fetchFreshData();
        this.bargainSelected(this.bargainStatus[0]);
    },
    methods: {
        bargainSelected(bargain) {
            this.bargainSelectedItem = bargain;
            this.productQueryDto.isBargain = bargain.isBargain;
            this.fetchFreshData();
        },
        fetchCategoryList() {
            this.$axios.post('/category/query', {}).then(res => {
                const { data } = res;
                if (data.code === 200) {
                    this.categoryList = data.data;
                    this.categoryList.unshift({ id: null, name: '全部' });
                }
            }).catch(error => {
                console.log("商品类别查询异常：", error);
            })
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
                title: '删除商品数据',
                text: `删除后不可恢复，是否继续？`,
                icon: 'warning',
            });
            if (confirmed) {
                try {
                    let ids = this.delectedRows.map(entity => entity.id);
                    const response = await this.$axios.post(`/product/batchDelete`, ids);
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
                    this.$message.error("商品信息删除异常：", error);
                    console.error(`商品信息删除异常：`, error);
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
            this.productQueryDto.current = this.currentPage;
            this.productQueryDto.size = this.pageSize;
            this.productQueryDto.startTime = startTime;
            this.productQueryDto.endTime = endTime;
            this.$axios.post('/product/query', this.productQueryDto).then(res => {
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
            this.coverList = row.coverList ? row.coverList.split(',') : [];
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
        margin-bottom: 10px;
    }

    .filter-controls {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;

        .filter-item {
            flex: 1;
            min-width: 200px;
        }
    }
}

.product-card {
    border-radius: 8px;

    .product-item {
        padding: 20px;
        border-bottom: 1px solid #ebeef5;

        &:last-child {
            border-bottom: none;
        }

        .product-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;

            .user-info {
                margin-left: 10px;

                .user-name {
                    font-weight: 500;
                }

                .create-time {
                    font-size: 12px;
                    color: #909399;
                }
            }
        }

        .product-content {
            display: flex;
            gap: 20px;

            .product-images {
                flex: 0 0 120px;

                .product-image {
                    width: 60px;
                    height: 60px;
                    border-radius: 4px;
                    margin-right: 10px;
                    margin-bottom: 10px;
                    border: 3px solid rgb(255, 255, 255);
                    cursor: pointer;
                    border-radius: 10px;
                }

                .product-image:hover {
                    border: 3px solid rgb(84, 126, 210);
                }
            }

            .product-details {
                flex: 1;

                .product-title {
                    margin: 0 0 10px 0;
                    font-size: 16px;
                    color: #303133;
                }

                .product-meta {
                    margin-bottom: 10px;

                    .el-tag {
                        margin-right: 8px;
                    }
                }

                .product-price {
                    margin-bottom: 15px;

                    .price {
                        font-size: 18px;
                        color: #f56c6c;
                        font-weight: 600;
                        margin-right: 15px;
                    }

                    .inventory {
                        font-size: 14px;
                        color: #909399;
                    }
                }
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

    .detail-cover {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;

        .cover-image {
            width: 100px;
            height: 100px;
            border-radius: 4px;
            cursor: pointer;
        }
    }

    .product-detail {
        line-height: 1.6;
        color: #606266;
    }
}
</style>