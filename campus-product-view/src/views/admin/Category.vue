<template>
    <div class="category-management-container">
        <!-- 搜索和操作区域 -->
        <div class="search-operation-area">
            <div class="search-box">
                <el-input v-model="categoryQueryDto.name" placeholder="请输入商品类别名称" clearable @clear="handleFilterClear"
                    @keyup.enter="handleFilter" size="medium" style="width: 300px">
                    <template #append>
                        <el-button type="primary" icon="el-icon-search" @click="handleFilter"></el-button>
                    </template>
                </el-input>
            </div>
            <div class="operation-buttons">
                <el-button class="customer" type="primary" icon="el-icon-plus" @click="add" size="medium">
                    新增商品类别
                </el-button>
            </div>
        </div>

        <!-- 表格区域 -->
        <div class="table-area">
            <el-table :data="tableData" stripe border style="width: 100%" @selection-change="handleSelectionChange">
                <el-table-column prop="id" label="ID" width="100" align="center"></el-table-column>
                <el-table-column prop="name" label="商品类别名称" min-width="200"></el-table-column>
                <el-table-column prop="isUse" label="状态" width="120" align="left">
                    <template #default="{ row }">
                        <el-tag :type="row.isUse ? 'success' : 'info'" size="medium">
                            {{ row.isUse ? '启用' : '禁用' }}
                        </el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="操作" width="180" align="center">
                    <template #default="{ row }">
                        <el-button  class="customer"  type="text" size="mini" icon="el-icon-edit" @click="handleEdit(row)">
                            编辑
                        </el-button>
                        <el-button  class="customer"  type="text" size="mini" icon="el-icon-delete" @click="handleDelete(row)"
                            style="color: #F56C6C">
                            删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
        </div>

        <!-- 分页区域 -->
        <div class="pagination-area">
            <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                :current-page="currentPage" :page-sizes="[10, 20, 50, 100]" :page-size="pageSize"
                layout="total, sizes, prev, pager, next, jumper" :total="totalItems"></el-pagination>
        </div>

        <!-- 新增/编辑对话框 -->
        <el-dialog :show-title="false" :show-close="false" :visible.sync="dialogCategoryOperation" width="400px"
            :close-on-click-modal="false">
            <el-form :model="data" label-width="150px" label-position="right" style="padding: 30px;">
                <el-form-item label="商品类别名称" prop="name" required>
                    <el-input v-model="data.name" placeholder="请输入商品类别名称" clearable maxlength="50"
                        show-word-limit></el-input>
                </el-form-item>
                <el-form-item label="状态" prop="isUse" required>
                    <el-switch v-model="data.isUse" active-text="启用" inactive-text="禁用" active-color="#13ce66"
                        inactive-color="#ff4949"></el-switch>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button  class="customer"  @click="cannel" size="medium">取 消</el-button>
                <el-button  class="customer"  type="primary" @click="isOperation ? updateOperation() : addOperation()" size="medium">
                    确 定
                </el-button>
            </div>
        </el-dialog>
    </div>
</template>

<script>
export default {
    data() {
        return {
            data: {
                name: '',
                isUse: true
            },
            currentPage: 1,
            pageSize: 10,
            totalItems: 0,
            dialogCategoryOperation: false,
            isOperation: false,
            tableData: [],
            selectedRows: [],
            categoryQueryDto: {
                name: '',
                current: 1,
                size: 10
            }
        }
    },
    created() {
        this.fetchFreshData()
    },
    methods: {
        cannel() {
            this.data = {
                name: '',
                isUse: true
            }
            this.dialogCategoryOperation = false
            this.isOperation = false
        },
        async batchDelete() {
            if (!this.selectedRows.length) {
                this.$message.warning('请至少选择一条数据')
                return
            }

            try {
                const confirmed = await this.$confirm(
                    `确认删除选中的${this.selectedRows.length}条商品类别数据吗？删除后不可恢复！`,
                    '删除确认',
                    {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning'
                    }
                )

                if (confirmed) {
                    const ids = this.selectedRows.map(item => item.id)
                    const response = await this.$axios.post('/category/batchDelete', ids)

                    if (response.data.code === 200) {
                        this.$message.success('删除成功')
                        this.fetchFreshData()
                        this.selectedRows = []
                    } else {
                        this.$message.error(response.data.msg || '删除失败')
                    }
                }
            } catch (error) {
                console.error('删除商品类别异常:', error)
                
            }
        },
        updateOperation() {
            this.$axios.put('/category/update', this.data)
                .then(res => {
                    if (res.data.code === 200) {
                        this.$message.success('修改成功')
                        this.fetchFreshData()
                        this.cannel()
                    } else {
                        this.$message.error(res.data.msg || '修改失败')
                    }
                })
                .catch(error => {
                    console.error('修改商品类别异常:', error)
                    this.$message.error('修改操作异常')
                })
        },
        addOperation() {
            this.$axios.post('/category/save', this.data)
                .then(res => {
                    if (res.data.code === 200) {
                        this.$message.success('新增成功')
                        this.fetchFreshData()
                        this.cannel()
                    } else {
                        this.$message.error(res.data.msg || '新增失败')
                    }
                })
                .catch(error => {
                    console.error('新增商品类别异常:', error)
                    this.$message.error('新增操作异常')
                })
        },
        fetchFreshData() {
            this.categoryQueryDto.current = this.currentPage
            this.categoryQueryDto.size = this.pageSize

            this.$axios.post('/category/query', this.categoryQueryDto)
                .then(res => {
                    if (res.data.code === 200) {
                        this.tableData = res.data.data
                        this.totalItems = res.data.total
                    } else {
                        this.$message.error(res.data.msg || '查询失败')
                    }
                })
                .catch(error => {
                    console.error('查询商品类别异常:', error)
                    this.$message.error('查询操作异常')
                })
        },
        add() {
            this.dialogCategoryOperation = true
            this.isOperation = false
        },
        handleFilter() {
            this.currentPage = 1
            this.fetchFreshData()
        },
        handleFilterClear() {
            this.categoryQueryDto.name = ''
            this.handleFilter()
        },
        handleSizeChange(val) {
            this.pageSize = val
            this.currentPage = 1
            this.fetchFreshData()
        },
        handleCurrentChange(val) {
            this.currentPage = val
            this.fetchFreshData()
        },
        handleEdit(row) {
            this.dialogCategoryOperation = true
            this.isOperation = true
            this.data = { ...row }
        },
        handleDelete(row) {
            this.selectedRows = [row]
            this.batchDelete()
        },
        handleSelectionChange(rows) {
            this.selectedRows = rows
        }
    }
}
</script>

<style scoped lang="scss">
.category-management-container {
    padding: 20px;
    background-color: #fff;
    border-radius: 4px;

    .search-operation-area {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 20px;
        border-bottom: 1px solid #ebeef5;
    }

    .table-area {
        margin-bottom: 20px;
    }

    .pagination-area {
        display: flex;
        justify-content: flex-start;
    }

    .dialog-footer {
        text-align: right;
    }
}
</style>