import request from '@/utils/request'
export function getOrderSetting(id) {
  return request({
    // url:'/orderSetting/'+id,
    url:'/order-setting/'+id,
    method:'get',
  })
}

export function updateOrderSetting(id,data) {
  return request({
    // url:'/orderSetting/update/'+id,
    url:'/order-setting/update/'+id,
    method:'post',
    data:data
  })
}
