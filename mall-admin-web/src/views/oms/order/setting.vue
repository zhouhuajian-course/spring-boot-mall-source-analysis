<template> 
  <el-card class="form-container" shadow="never">
    <el-form :model="orderSetting"
             ref="orderSettingForm"
             :rules="rules"
             label-width="150px">
      <el-form-item label="秒杀订单超过：" prop="flashOrderOvertime">
        <el-input v-model="orderSetting.flashOrderOvertime" class="input-width">
          <template slot="append">分</template>
        </el-input>
        <span class="note-margin">未付款，订单自动关闭</span>
      </el-form-item>
      <el-form-item label="正常订单超过：" prop="normalOrderOvertime">
        <el-input v-model="orderSetting.normalOrderOvertime" class="input-width">
          <template slot="append">分</template>
        </el-input>
        <span class="note-margin">未付款，订单自动关闭</span>
      </el-form-item>
      <el-form-item label="发货超过：" prop="confirmOvertime">
        <el-input v-model="orderSetting.confirmOvertime" class="input-width">
          <template slot="append">天</template>
        </el-input>
        <span class="note-margin">未收货，订单自动完成</span>
      </el-form-item>
      <el-form-item label="订单完成超过：" prop="finishOvertime">
        <el-input v-model="orderSetting.finishOvertime" class="input-width">
          <template slot="append">天</template>
        </el-input>
        <span class="note-margin">自动结束交易，不能申请售后</span>
      </el-form-item>
      <el-form-item label="订单完成超过：" prop="commentOvertime">
        <el-input v-model="orderSetting.commentOvertime" class="input-width">
          <template slot="append">天</template>
        </el-input>
        <span class="note-margin">自动五星好评</span>
      </el-form-item>
      <el-form-item>
        <el-button
          @click="confirm('orderSettingForm')"
          type="primary">提交
        </el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>
<script>
import {getOrderSetting, updateOrderSetting} from '@/api/orderSetting';

const defaultOrderSetting = {
  id: null,
  flashOrderOvertime: null,
  normalOrderOvertime: null,
  confirmOvertime: null,
  finishOvertime: null,
  commentOvertime: null,
  // flashOrderOvertime: 0,
  // normalOrderOvertime: 0,
  // confirmOvertime: 0,
  // finishOvertime: 0,
  // commentOvertime: 0
};
const checkTime = (rule, value, callback) => {
  value = String(value)
  const reg = /^[1-9][0-9]*$/
  if (!reg.test(value)) {
    callback(new Error("请输入大于0的正整数"))
  } else {
    callback()
  }
  // if (!value) {
  //   return callback(new Error('不能为空'));
  // }
  // console.log("checkTime", value, typeof value);
  // if (typeof value === "string" && value.indexOf(".") !== -1) {
  //   return callback(new Error('不能包含小数'));
  // }
  // let intVal = parseInt(value);
  // if (!Number.isInteger(intVal)) {
  //   return callback(new Error('只能填写数字'));
  // } else if (intVal < 0) {
  //   return callback(new Error('不能填写负数'));
  // } else if (intVal === 0) {
  //   return callback(new Error('不能填写零'));
  // }
  // callback();
};
export default {
  name: 'orderSetting',
  data() {
    return {
      orderSetting: Object.assign({}, defaultOrderSetting),
      rules: {
        flashOrderOvertime: {validator: checkTime, trigger: 'blur'},
        normalOrderOvertime: {validator: checkTime, trigger: 'blur'},
        confirmOvertime: {validator: checkTime, trigger: 'blur'},
        finishOvertime: {validator: checkTime, trigger: 'blur'},
        commentOvertime: {validator: checkTime, trigger: 'blur'}
      }
    }
  },
  created() {
    this.getDetail();
  },
  methods: {
    confirm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$confirm('是否要提交修改?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            updateOrderSetting(1, this.orderSetting).then(response => {
              this.$message({
                type: 'success',
                message: '提交成功!',
                duration: 1000
              });
            })
          });
        } else {
          this.$message({
            message: '请填写正确后再提交',
            type: 'warning',
            duration: 5000
          });
          return false;
        }
      });
    },
    getDetail() {
      getOrderSetting(1).then(response => {
        this.orderSetting = response.data;
      })
    }
  }
}
</script>
<style scoped>
.input-width {
  width: 50%;
}

.note-margin {
  margin-left: 15px;
}
</style>


