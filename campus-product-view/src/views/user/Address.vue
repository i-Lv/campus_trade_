<template>
    <div class="address-container">
        <!-- 搜索区域 -->
        <el-card class="search-card">
            <el-form :inline="true" :model="queryParams" class="search-form">
                <el-form-item label="默认地址">
                    <el-select v-model="queryParams.isDefault" placeholder="请选择" clearable>
                        <el-option label="是" :value="true"></el-option>
                        <el-option label="否" :value="false"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="handleSearch">查询</el-button>
                    <el-button @click="resetSearch">重置</el-button>
                    <el-button type="success" @click="showAddDialog">新增地址</el-button>
                </el-form-item>
            </el-form>
        </el-card>

        <!-- 地址列表 -->
        <el-card class="table-card">
            <el-table :data="addressList" border style="width: 100%">
                <el-table-column prop="id" label="ID" width="80"></el-table-column>
                <el-table-column prop="userId" label="用户ID" width="100"></el-table-column>
                <el-table-column prop="concatPerson" label="收件人" width="120"></el-table-column>
                <el-table-column prop="concatPhone" label="联系电话" width="150"></el-table-column>
                <el-table-column prop="getAdr" label="收货地址"></el-table-column>
                <el-table-column label="默认地址" width="120">
                    <template slot-scope="scope">
                        <el-tag :type="scope.row.isDefault ? 'success' : 'info'">
                            {{ scope.row.isDefault ? '是' : '否' }}
                        </el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="操作" width="280">
                    <template slot-scope="scope">
                        <el-button size="mini" @click="handleEdit(scope.row)">编辑</el-button>
                        <el-button size="mini" type="primary" @click="setDefault(scope.row.id)"
                            :disabled="scope.row.isDefault">
                            设为默认
                        </el-button>
                        <el-button size="mini" type="danger" @click="handleDelete(scope.row.id)">删除</el-button>
                    </template>
                </el-table-column>
            </el-table>

            <!-- 分页 -->
            <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                :current-page="queryParams.current" :page-sizes="[10, 20, 30]" :page-size="queryParams.size"
                layout="total, sizes, prev, pager, next, jumper" :total="total" class="pagination"></el-pagination>
        </el-card>

        <!-- 新增/编辑对话框 -->
        <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="50%">
            <el-form :model="addressForm" :rules="rules" ref="addressForm" label-width="100px">
                <el-form-item label="收件人" prop="concatPerson">
                    <el-input v-model="addressForm.concatPerson"></el-input>
                </el-form-item>
                <el-form-item label="联系电话" prop="concatPhone">
                    <el-input v-model="addressForm.concatPhone"></el-input>
                </el-form-item>
                <el-form-item label="收货地址" prop="getAdr">
                    <el-input type="textarea" v-model="addressForm.getAdr"></el-input>
                </el-form-item>
                <el-form-item label="默认地址">
                    <el-switch v-model="addressForm.isDefault"></el-switch>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取消</el-button>
                <el-button type="primary" @click="submitForm">确定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
export default {
    data() {
        return {
            queryParams: {
                userId: null,
                isDefault: null,
                current: 1,
                size: 10
            },
            addressList: [],
            total: 0,
            dialogVisible: false,
            dialogTitle: '新增地址',
            addressForm: {
                id: null,
                userId: null,
                concatPerson: '',
                concatPhone: '',
                getAdr: '',
                isDefault: false
            },
            rules: {
                userId: [
                    { required: true, message: '请输入用户ID', trigger: 'blur' },
                    { type: 'number', message: '用户ID必须为数字', trigger: 'blur', transform: value => Number(value) }
                ],
                concatPerson: [
                    { required: true, message: '请输入收件人姓名', trigger: 'blur' },
                    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
                ],
                concatPhone: [
                    { required: true, message: '请输入联系电话', trigger: 'blur' },
                    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
                ],
                getAdr: [
                    { required: true, message: '请输入收货地址', trigger: 'blur' },
                    { min: 5, max: 100, message: '长度在 5 到 100 个字符', trigger: 'blur' }
                ]
            }
        }
    },
    created() {
        this.fetchAddressList()
    },
    methods: {
        // 获取地址列表
        fetchAddressList() {
            this.$axios.post('/address/queryUser', this.queryParams).then(res => {
                const { data } = res
                if (data.code === 200) {
                    this.addressList = data.data
                    this.total = data.total || 0
                }
            })
        },
        // 搜索
        handleSearch() {
            this.queryParams.current = 1
            this.fetchAddressList()
        },
        // 重置搜索
        resetSearch() {
            this.queryParams = {
                userId: null,
                isDefault: null,
                current: 1,
                size: 10
            }
            this.fetchAddressList()
        },
        // 分页大小变化
        handleSizeChange(size) {
            this.queryParams.size = size
            this.fetchAddressList()
        },
        // 当前页变化
        handleCurrentChange(current) {
            this.queryParams.current = current
            this.fetchAddressList()
        },
        // 显示新增对话框
        showAddDialog() {
            this.dialogTitle = '新增地址'
            this.addressForm = {
                id: null,
                userId: null,
                concatPerson: '',
                concatPhone: '',
                getAdr: '',
                isDefault: false
            }
            this.dialogVisible = true
            this.$nextTick(() => {
                if (this.$refs.addressForm) {
                    this.$refs.addressForm.clearValidate();
                }
            })
        },
        // 显示编辑对话框
        handleEdit(row) {
            this.dialogTitle = '编辑地址'
            this.addressForm = JSON.parse(JSON.stringify(row))
            this.dialogVisible = true
            this.$nextTick(() => {
                if (this.$refs.addressForm) {
                    this.$refs.addressForm.clearValidate();
                }
            })
        },
        // 提交表单
        submitForm() {
            this.$refs.addressForm.validate(valid => {
                if (valid) {
                    if (this.addressForm.id) {
                        // 更新
                        this.$axios.put('/address/update', this.addressForm).then(res => {
                            this.handleResponse(res, '更新成功')
                        })
                    } else {
                        // 新增
                        this.$axios.post('/address/save', this.addressForm).then(res => {
                            this.handleResponse(res, '新增成功')
                        })
                    }
                }
            })
        },
        // 处理响应
        handleResponse(res, msg) {
            const { data } = res
            if (data.code === 200) {
                this.$message.success(msg)
                this.dialogVisible = false
                this.fetchAddressList()
            } else {
                this.$message.error(data.msg || '操作失败')
            }
        },
        // 删除地址
        handleDelete(id) {
            this.$confirm('确认删除该地址吗?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                this.$axios.post('/address/batchDelete', [id]).then(res => {
                    const { data } = res
                    if (data.code === 200) {
                        this.$message.success('删除成功')
                        this.fetchAddressList()
                    }
                })
            }).catch(() => { })
        },
        // 设为默认地址
        setDefault(id) {
            this.$confirm('确认设为默认地址吗?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                const params = {
                    id: id,

                    isDefault: true
                }
                this.$axios.put('/address/isDefault', params).then(res => {
                    const { data } = res
                    if (data.code === 200) {
                        this.$message.success('设置成功')
                        this.fetchAddressList()
                    } else {
                        this.$message.info(data.msg)
                    }
                })
            }).catch(() => { })
        }
    }
}
</script>

<style scoped>
.address-container {
    padding: 20px;
}

.search-card {
    margin-bottom: 20px;
}

.search-form {
    display: flex;
    align-items: center;
}

.table-card {
    margin-bottom: 20px;
}

.pagination {
    margin-top: 20px;
    text-align: right;
}
</style>