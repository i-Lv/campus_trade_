<template>
    <div class="order-container">
        <!-- 商品信息卡片 -->
        <el-card class="product-card" shadow="never">
            <div class="product-info">
                <div class="product-header">
                    <img :src="product.coverList.split(',')[0]" class="product-image" alt="商品图片">
                    <div class="product-details">
                        <h3 class="product-title">{{ product.name }}</h3>
                        <div class="price-section">
                            <span class="price">¥{{ product.price }}</span>
                            <el-tag size="mini" :type="product.isBargain ? 'warning' : 'info'">
                                {{ product.isBargain ? '可砍价' : '不支持砍价' }}
                            </el-tag>
                            <el-tag size="mini" type="info">{{ product.oldLevel }}成新</el-tag>
                        </div>
                        <div class="product-meta">
                            <span><i class="el-icon-user"></i> {{ product.userName }}</span>
                            <span><i class="el-icon-folder-opened"></i> {{ product.categoryName }}</span>
                            <span><i class="el-icon-box"></i> 库存 {{ product.inventory }}件</span>
                        </div>
                    </div>
                </div>

                <!-- 购买参数 -->
                <div class="order-params">
                    <el-form label-width="100px">
                        <el-form-item label="购买数量" required>
                            <el-input-number v-model="buyNumber" :min="1" :max="product.inventory"
                                controls-position="right" size="medium"
                                @change="handleQuantityChange"></el-input-number>
                            <span class="inventory-tip">剩余{{ product.inventory }}件</span>
                        </el-form-item>
                        <el-form-item label="商品总价">
                            <span class="total-price">¥{{ (product.price * buyNumber).toFixed(2) }}</span>
                        </el-form-item>
                        <el-form-item label="备注信息">
                            <el-input type="textarea" :rows="3" placeholder="请输入备注信息（选填）" v-model="detail" resize="none"
                                maxlength="100" show-word-limit></el-input>
                        </el-form-item>
                    </el-form>
                </div>
            </div>
        </el-card>

        <!-- 地址选择 -->
        <el-card class="address-card" shadow="never">
            <div class="card-header">
                <h3>选择收货地址</h3>
                <el-button type="text" @click="showAddDialog" icon="el-icon-plus">新增地址</el-button>
            </div>

            <div class="address-list" v-if="addressList.length > 0">
                <el-radio-group v-model="selectedAddressId" class="address-radio-group">
                    <div class="address-item" v-for="item in addressList" :key="item.id"
                        :class="{ 'active': selectedAddressId === item.id }">
                        <el-radio :label="item.id" class="address-radio"></el-radio>
                        <div class="address-content">
                            <div class="address-info">
                                <div class="receiver">{{ item.concatPerson }}</div>
                                <div class="phone">{{ item.concatPhone }}</div>
                                <el-tag v-if="item.isDefault" size="mini" type="success">默认</el-tag>
                            </div>
                            <div class="address-detail">{{ item.getAdr }}</div>
                        </div>
                        <div class="address-actions">
                            <el-button size="mini" @click="handleEdit(item)">编辑</el-button>
                            <el-button size="mini" type="text" @click="setDefault(item.id)" :disabled="item.isDefault">
                                设为默认
                            </el-button>
                        </div>
                    </div>
                </el-radio-group>
            </div>
            <div class="empty-address" v-else>
                <el-empty description="暂无收货地址">
                    <el-button type="primary" size="small" @click="showAddDialog">添加收货地址</el-button>
                </el-empty>
            </div>
        </el-card>

        <!-- 底部操作栏 -->
        <div class="order-footer">
            <el-button type="info" size="medium" @click="goBack" icon="el-icon-arrow-left">
                返回商品页
            </el-button>
            <div class="order-summary">
                <span class="total">合计：<span class="price">¥{{ (product.price * buyNumber).toFixed(2) }}</span></span>
                <span class="quantity">共{{ buyNumber }}件</span>
            </div>
            <el-button type="primary" size="medium" @click="submitOrder" :disabled="!selectedAddressId || submitting"
                :loading="submitting" icon="el-icon-sell">
                提交订单
            </el-button>
        </div>

        <!-- 新增/编辑地址对话框 -->
        <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="600px" :close-on-click-modal="false">
            <el-form :model="addressForm" :rules="rules" ref="addressForm" label-width="100px" @submit.native.prevent>
                <el-form-item label="收件人" prop="concatPerson">
                    <el-input v-model="addressForm.concatPerson" placeholder="请输入收件人姓名" maxlength="20"
                        show-word-limit></el-input>
                </el-form-item>
                <el-form-item label="联系电话" prop="concatPhone">
                    <el-input v-model="addressForm.concatPhone" placeholder="请输入收件人手机号码"></el-input>
                </el-form-item>
                <el-form-item label="收货地址" prop="getAdr">
                    <el-input type="textarea" v-model="addressForm.getAdr" placeholder="请输入详细收货地址" :rows="3"
                        maxlength="100" show-word-limit></el-input>
                </el-form-item>
                <el-form-item label="默认地址">
                    <el-switch v-model="addressForm.isDefault"></el-switch>
                    <span class="tip">设为默认地址后，下单时会优先选择</span>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取消</el-button>
                <el-button type="primary" @click="submitAddressForm" :loading="addressSubmitting">
                    确定
                </el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
import { getUserInfo } from "@/utils/storage"
export default {
    data() {
        return {
            product: {
                id: null,
                name: '',
                price: 0,
                inventory: 0,
                coverList: '',
                isBargain: false,
                oldLevel: '',
                userName: '',
                categoryName: ''
            },
            buyNumber: 1,
            detail: '',
            selectedAddressId: null,
            addressList: [],
            submitting: false,
            addressSubmitting: false,

            // 地址表单相关
            dialogVisible: false,
            dialogTitle: '新增地址',
            addressForm: {
                id: null,
                concatPerson: '',
                concatPhone: '',
                getAdr: '',
                isDefault: false
            },
            rules: {
                concatPerson: [
                    { required: true, message: '请输入收件人姓名', trigger: 'blur' },
                    { min: 2, max: 20, message: '长度在2到20个字符', trigger: 'blur' }
                ],
                concatPhone: [
                    { required: true, message: '请输入联系电话', trigger: 'blur' },
                    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
                ],
                getAdr: [
                    { required: true, message: '请输入收货地址', trigger: 'blur' },
                    { min: 5, max: 100, message: '长度在5到100个字符', trigger: 'blur' }
                ]
            }
        }
    },
    created() {
        this.initData();
    },
    methods: {
        async initData() {
            await this.fetchProduct();
            await this.fetchAddressList();
        },

        // 获取商品信息
        async fetchProduct() {
            const productId = this.$route.query.productId;
            if (!productId) {
                this.$message.error('商品信息获取失败');
                this.$router.go(-1);
                return;
            }

            try {
                const res = await this.$axios.post('/product/query', { id: productId });
                if (res.data.code === 200 && res.data.data.length > 0) {
                    this.product = res.data.data[0];
                    // 初始化购买数量不超过库存
                    this.buyNumber = Math.min(1, this.product.inventory);
                } else {
                    this.$message.error('商品信息获取失败');
                    this.$router.go(-1);
                }
            } catch (error) {
                this.$message.error('商品信息获取失败');
                console.error('获取商品信息失败:', error);
                this.$router.go(-1);
            }
        },

        // 获取地址列表
        async fetchAddressList() {
            try {
                const userInfo = getUserInfo();
                if (userInfo === null) { // 没登录不用记录
                    this.$notify({
                        duration: 1000,
                        title: '未登录',
                        message: '登录后才可使用下单功能哦',
                        type: 'info'
                    });
                    this.$router.push('/login');
                    return;
                }

                const res = await this.$axios.post('/address/queryUser', {
                    current: 1,
                    size: 100 // 获取足够多的地址，避免分页
                });

                if (res.data.code === 200) {
                    this.addressList = res.data.data || [];
                    // 设置默认选中默认地址
                    const defaultAddress = this.addressList.find(item => item.isDefault);
                    if (defaultAddress) {
                        this.selectedAddressId = defaultAddress.id;
                    } else if (this.addressList.length > 0) {
                        this.selectedAddressId = this.addressList[0].id;
                    }
                }
            } catch (error) {
                console.error('获取地址列表失败:', error);
                this.$message.error('地址列表获取失败');
            }
        },

        // 数量变化处理
        handleQuantityChange(value) {
            if (value > this.product.inventory) {
                this.buyNumber = this.product.inventory;
                this.$message.warning(`购买数量不能超过库存数量`);
            }
        },

        // 提交订单
        async submitOrder() {
            if (!this.selectedAddressId) {
                this.$message.error('请选择收货地址');
                return;
            }

            if (this.buyNumber <= 0) {
                this.$message.error('购买数量必须大于0');
                return;
            }

            if (this.buyNumber > this.product.inventory) {
                this.$message.error('购买数量不能超过库存数量');
                return;
            }

            this.submitting = true;

            try {
                const orderData = {
                    productId: this.product.id,
                    buyNumber: this.buyNumber,
                    detail: this.detail,
                    addressId: this.selectedAddressId
                };

                const res = await this.$axios.post('/orders/save', orderData);

                if (res.data.code === 200) {
                    this.$message.success('下单成功');
                    this.$router.push({
                        path: '/orders',
                        query: { orderId: res.data.data }
                    });
                } else {
                    this.$message.error(res.data.msg || '下单失败');
                }
            } catch (error) {
                console.error('下单失败:', error);
                this.$message.error('下单失败，请稍后重试');
            } finally {
                this.submitting = false;
            }
        },

        // 返回商品页
        goBack() {
            this.$router.go(-1);
        },

        // 显示新增地址对话框
        showAddDialog() {
            this.dialogTitle = '新增地址';
            this.addressForm = {
                id: null,
                concatPerson: '',
                concatPhone: '',
                getAdr: '',
                isDefault: false
            };
            this.dialogVisible = true;

            this.$nextTick(() => {
                if (this.$refs.addressForm) {
                    this.$refs.addressForm.clearValidate();
                }
            });
        },

        // 编辑地址
        handleEdit(row) {
            this.dialogTitle = '编辑地址';
            this.addressForm = JSON.parse(JSON.stringify(row));
            this.dialogVisible = true;

            this.$nextTick(() => {
                if (this.$refs.addressForm) {
                    this.$refs.addressForm.clearValidate();
                }
            });
        },

        // 提交地址表单
        async submitAddressForm() {
            this.$refs.addressForm.validate(async (valid) => {
                if (!valid) return;

                this.addressSubmitting = true;

                try {
                    const formData = {
                        ...this.addressForm
                    };

                    const api = formData.id ? '/address/update' : '/address/save';
                    const res = await this.$axios.post(api, formData);

                    if (res.data.code === 200) {
                        this.$message.success(formData.id ? '地址更新成功' : '地址添加成功');
                        this.dialogVisible = false;
                        await this.fetchAddressList();
                    } else {
                        this.$message.error(res.data.msg || '操作失败');
                    }
                } catch (error) {
                    console.error('地址操作失败:', error);
                    this.$message.error('操作失败，请稍后重试');
                } finally {
                    this.addressSubmitting = false;
                }
            });
        },

        // 设为默认地址
        async setDefault(id) {
            try {
                await this.$confirm('确认设为默认地址吗?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                });

                const res = await this.$axios.put('/address/isDefault', {
                    id: id,
                    isDefault: true
                });

                if (res.data.code === 200) {
                    this.$message.success('设置成功');
                    await this.fetchAddressList();
                } else {
                    this.$message.info(res.data.msg);
                }
            } catch (error) {
                // 用户取消不做处理
            }
        }
    }
}
</script>

<style scoped lang="scss">
.order-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

.product-card {
    margin-bottom: 20px;
    border-radius: 8px;

    .product-info {
        padding: 20px;
    }

    .product-header {
        display: flex;
        margin-bottom: 20px;
    }

    .product-image {
        width: 120px;
        height: 120px;
        border-radius: 4px;
        margin-right: 20px;
        object-fit: cover;
    }

    .product-details {
        flex: 1;

        .product-title {
            margin: 0 0 10px 0;
            font-size: 18px;
            color: #333;
        }

        .price-section {
            margin-bottom: 10px;

            .price {
                font-size: 24px;
                color: #ff5000;
                margin-right: 10px;
                font-weight: bold;
            }

            .el-tag {
                margin-right: 8px;
            }
        }

        .product-meta {
            color: #666;
            font-size: 14px;

            span {
                margin-right: 15px;

                i {
                    margin-right: 5px;
                }
            }
        }
    }

    .order-params {
        margin-top: 20px;

        .el-form-item {
            margin-bottom: 15px;
        }

        .inventory-tip {
            margin-left: 10px;
            color: #999;
            font-size: 12px;
        }

        .total-price {
            font-size: 18px;
            color: #ff5000;
            font-weight: bold;
        }
    }
}

.address-card {
    margin-bottom: 20px;
    border-radius: 8px;

    .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 20px;
        border-bottom: 1px solid #f0f0f0;

        h3 {
            margin: 0;
            font-size: 16px;
            color: #333;
        }
    }

    .address-list {
        padding: 10px;
    }

    .address-item {
        display: flex;
        align-items: center;
        padding: 15px;
        margin-bottom: 10px;
        border: 1px solid #e6e6e6;
        border-radius: 4px;
        transition: all 0.3s;
        cursor: pointer;

        &:hover {
            border-color: #409EFF;
        }

        &.active {
            border-color: #409EFF;
            background-color: #f5f9ff;
        }

        .address-radio {
            margin-right: 15px;
        }

        .address-content {
            flex: 1;

            .address-info {
                margin-bottom: 5px;
                display: flex;
                align-items: center;
                justify-content: left;

                .receiver {
                    font-weight: bold;
                    margin-right: 10px;
                    font-size: 14px;
                }

                .phone {
                    margin-right: 10px;
                    color: #666;
                                        font-size: 14px;
                }
            }

            .address-detail {
                color: #666;
                font-size: 14px;
            }
        }

        .address-actions {
            margin-left: 15px;
        }
    }

    .empty-address {
        padding: 40px 0;
    }
}

.order-footer {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background: #fff;
    box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    z-index: 100;

    .order-summary {
        text-align: right;

        .total {
            font-size: 16px;
            margin-right: 15px;

            .price {
                font-size: 20px;
                color: #ff5000;
                font-weight: bold;
            }
        }

        .quantity {
            color: #666;
            font-size: 14px;
        }
    }
}

.dialog-footer {
    text-align: right;
}

.tip {
    margin-left: 10px;
    color: #999;
    font-size: 12px;
}
</style>