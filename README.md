# Spring Boot 商城项目源码分析

https://www.macrozheng.com/  
https://www.macrozheng.com/admin/index.html#/login  
https://github.com/macrozheng/mall  
https://github.com/macrozheng/mall-admin-web  
https://www.macrozheng.com/mall/deploy/mall_deploy_windows.html

## 添加商品 完成，提交商品

点击 完成，提交商品 -》 弹出确认框 -》调用添加商品接口-》刷新页面

```
ProductRelationDetail.vue
<el-form-item style="text-align: center">
        <el-button size="medium" @click="handlePrev">上一步，填写商品属性</el-button>
        <el-button type="primary" size="medium" @click="handleFinishCommit">完成，提交商品</el-button>
      </el-form-item>
      
调用 handleFinishCommit

handleFinishCommit(){
        this.$emit('finishCommit',this.isEdit);
      }
      
触发 finistCommmit 事件

ProductDetail.vue
      finishCommit(isEdit) {
        // 提示
        this.$confirm('是否要提交该产品', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          // 更新商品
          if(isEdit){
            updateProduct(this.$route.query.id,this.productParam).then(response=>{
              this.$message({
                type: 'success',
                message: '提交成功',
                duration:1000
              });
              this.$router.back();
            });
          // 添加商品   
          }else{
            createProduct(this.productParam).then(response=>{
              this.$message({
                type: 'success',
                message: '提交成功',
                duration:1000
              });
              // 重新加载页面 刷新页面
              location.reload();
            });
          }
        })
      }           

// 从@/api/product模块引入的createProduct,getProduct,updateProduct函数      
import {createProduct,getProduct,updateProduct} from '@/api/product';
      
api/product.js     
// 创建商品
export function createProduct(data) {
  return request({
    url:'/product/create',
    method:'post',
    data:data
  })
}
// 更新商品
export function updateProduct(id,data) {
  return request({
    url:'/product/update/'+id,
    method:'post',
    data:data
  })
}
// 获取商品信息
export function getProduct(id) {
  return request({
    url:'/product/updateInfo/'+id,
    method:'get',
  })
}
```

## 专题推荐 添加专题

http://localhost:8080/home/recommendSubject/list?pageNum=1&pageSize=5

到数据库加 专题

## 修改产品分类顺序

http://localhost:8080/productCategory/list/withChildren

```
PmsProductCategoryDao.xml
<select id="listWithChildren" resultMap="listWithChildrenMap">
    select
        c1.id,
        c1.name,
        c2.id   child_id,
        c2.name child_name
    from pms_product_category c1 left join pms_product_category c2 on c1.id = c2.parent_id
    where c1.parent_id = 0 
</select>
添加 order by c1.sort desc
```

## 修改 分类顺序

http://localhost:8085/home/productCateList/0

pms_product_category 表 sort 倒排序

```
@Override
    public List<PmsProductCategory> getProductCateList(Long parentId) {
        PmsProductCategoryExample example = new PmsProductCategoryExample();
        example.createCriteria()
                .andShowStatusEqualTo(1)
                .andParentIdEqualTo(parentId);
        example.setOrderByClause("sort desc");
        return productCategoryMapper.selectByExample(example);
    }
```

## 调整 品牌制作商直供 顺序

修改 sms_home_brand  表的顺序

```
<select id="getRecommendBrandList" resultMap="com.macro.mall.mapper.PmsBrandMapper.BaseResultMap">
        SELECT b.*
        FROM
            sms_home_brand hb
            LEFT JOIN pms_brand b ON hb.brand_id = b.id
        WHERE
            hb.recommend_status = 1
            AND b.show_status = 1
        ORDER BY
            hb.sort DESC
        LIMIT #{offset}, #{limit}
    </select>
```

## 商城App首页

http://localhost:8085/home/content

品牌制造商直供 新鲜好物 人气推荐 等都在这个接口返回

## 前端UI框架

import ElementUI from 'element-ui'  
import 'element-ui/lib/theme-chalk/index.css'  
import locale from 'element-ui/lib/locale/lang/zh-CN' // lang i18n  

用了 element-ui

## 打包



## 品牌列表使用id倒排序

pmsBrandExample.setOrderByClause("id desc");

## 修复访问首页有时会空页面问题

貌似没问题了

## 提交订单 接口 报错修复

http://localhost:8085/order/generateOrder

原因：rabbitmq
解决：安装rabbitmq

必须先安装 Erlang  
https://www.erlang.org/  
下载安装包，安装  
https://github.com/erlang/otp/releases/download/OTP-27.0/otp_win64_27.0.exe

必须把计算机名改成没中文没空格的名字，否者会有各种 用到计算机名的配置、文件创建  

下载 RabbitMQ 安装包 安装  
https://www.rabbitmq.com/  
去掉Service

D:\RabbitMQ-Server\rabbitmq_server-3.13.4\sbin  
rabbitmq-plugins.bat enable rabbitmq_management  
rabbitmq-server.bat

http://localhost:15672/ 账号密码 guest guest

1. 访问 Admin Tab，创建帐号 mall mall 设置角色为管理员
2. 创建虚拟 host ，Name 为 /mall
3. 访问 mall 用户设置页，给 mall 用户配置该虚拟 host 的权限

## 成员账号密码分析

```java
// http://localhost:8085/sso/login
// SSO 单点登录 Single Sign-On (SSO)
// 会员相关 Member 接口 UmsMember...
// portal/controller/UmsMemberController.java
// 数据库表 ums_member

// 可以调register接口，注册一个
    @ApiOperation("会员注册")
    // 限制POST 使用curl或postman工具
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    @ResponseBody
    // 用户名 密码 手机号 手机验证码
    public CommonResult register(@RequestParam String username,
                                 @RequestParam String password,
                                 @RequestParam String telephone,
                                 @RequestParam String authCode) {
// chrome 开发者工具 网络 找到 login 右键 以 powershell 方式复制
// 修改url和请求参数，telephone 和 authCode 乱写，代码改逻辑，直接通过
```

```
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Mobile Safari/537.36"
Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8085/sso/register" `
-Method "POST" `
-WebSession $session `
-Headers @{
"Accept"="*/*"
  "Accept-Encoding"="gzip, deflate, br, zstd"
  "Accept-Language"="zh-CN,zh;q=0.9"
  "Origin"="http://localhost:8060"
  "Referer"="http://localhost:8060/"
  "Sec-Fetch-Dest"="empty"
  "Sec-Fetch-Mode"="cors"
  "Sec-Fetch-Site"="same-site"
  "sec-ch-ua"="`"Not/A)Brand`";v=`"8`", `"Chromium`";v=`"126`", `"Google Chrome`";v=`"126`""
  "sec-ch-ua-mobile"="?1"
  "sec-ch-ua-platform"="`"Android`""
} `
-ContentType "application/x-www-form-urlencoded;charset=UTF-8" `
-Body "username=xiaoming&password=xiaoming&telephone=13500000000&authCode=1234"
```

```java
// com.macro.mall.portal.service.impl.UmsMemberServiceImpl.register
@Override
public void register(String username, String password, String telephone, String authCode) {
    //验证验证码
    if (!verifyAuthCode(authCode, telephone)) {
        // 注释这行代码，注册好后，改回去
        // Asserts.fail("验证码错误");
    }
    // ...
}
```

## 去掉前台登录时"获取体验账号"

mall-app-web/pages/public/login.vue

```html
<!--<button class="confirm-btn2" @click="toRegist" >获取体验账号</button>-->
```

## 后台订单列表id倒排序

```xml
<!-- http://localhost:8080/order/list?pageNum=1&pageSize=10-->
<!-- controller/OmsOrderController.java-->
<!-- service/impl/OmsOrderServiceImpl.java-->
<!-- dao/OmsOrderDao.java-->
<!-- resources/dao/OmsOrderDao.xml-->
<select id="getList" resultMap="com.macro.mall.mapper.OmsOrderMapper.BaseResultMap">
    SELECT *
    FROM
    oms_order
    WHERE
    delete_status = 0
    <if test="queryParam.orderSn!=null and queryParam.orderSn!=''">
        AND order_sn = #{queryParam.orderSn}
    </if>
    <if test="queryParam.status!=null">
        AND `status` = #{queryParam.status}
    </if>
    <if test="queryParam.sourceType!=null">
        AND source_type = #{queryParam.sourceType}
    </if>
    <if test="queryParam.orderType!=null">
        AND order_type = #{queryParam.orderType}
    </if>
    <if test="queryParam.createTime!=null and queryParam.createTime!=''">
        AND create_time LIKE concat(#{queryParam.createTime},"%")
    </if>
    <if test="queryParam.receiverKeyword!=null and queryParam.receiverKeyword!=''">
        AND (
        receiver_name LIKE concat("%",#{queryParam.receiverKeyword},"%")
        OR receiver_phone LIKE concat("%",#{queryParam.receiverKeyword},"%")
        )
    </if>
    /* added by zhouhuajian */
    order by id desc
</select>

```

## 后台商品列表id倒排序

```java
// http://localhost:8080/product/list?pageNum=1&pageSize=5
// controller/PmsProductController.java
// service/impl/PmsProductServiceImpl.java
@Override
public List<PmsProduct> list(PmsProductQueryParam productQueryParam, Integer pageSize, Integer pageNum) {
    PageHelper.startPage(pageNum, pageSize);
    PmsProductExample productExample = new PmsProductExample();

    // added by zhouhuajian
    productExample.setOrderByClause("id desc");
    
    // ...
}

```

## 解决添加品牌Logo出错问题

问题：MinIO搭建
解决：搭建MinIO

https://dl.min.io/server/minio/release/windows-amd64/minio.exe  
放到 D:\MinIO  
把 data 目录放项目里面 一起保存到git仓库
D:\MinIO\minio.exe server ...\shop-com\minio-data --console-address ":9001"
```
API: http://192.168.31.195:9000  http://192.168.30.1:9000  http://192.168.31.1:9000  http://127.0.0.1:9000
   RootUser: minioadmin
   RootPass: minioadmin
WebUI: http://192.168.31.195:9001 http://192.168.30.1:9001 http://192.168.31.1:9001 http://127.0.0.1:9001
   RootUser: minioadmin
   RootPass: minioadmin
```

mall-admin/src/main/resources/application-dev.yml

```yml
minio:
  endpoint: http://localhost:9000 #MinIO服务所在地址
  bucketName: mall #存储桶名称
  accessKey: minioadmin #访问的key
  secretKey: minioadmin #访问的秘钥
```

http://192.168.31.195:9001 访问管理平台

## 修改前台后端请求基础URL

//配置API请求的基础路径  
// export const API_BASE_URL = 'http://localhost:8085';  
（备注：改了会很麻烦）

## 修改后台登录 去掉账号密码默认值

mall-admin-web/src/views/login/index.vue

```
   created() {
      this.loginForm.username = getCookie("username");
      this.loginForm.password = getCookie("password");
      if(this.loginForm.username === undefined||this.loginForm.username==null||this.loginForm.username===''){
        this.loginForm.username = 'admin';
      }
      if(this.loginForm.password === undefined||this.loginForm.password==null){
        this.loginForm.password = '';
      }
      // added by zhouhuajian
      this.loginForm.username = '';
      this.loginForm.password = '';
    },
```

## 修改后台 host 和 port

```
localhost 为 admin.shop.com
8089 为 80

mall-admin-web/config/index.js

//    host: 'localhost', // can be overwritten by process.env.HOST
//    port: 8090, // can be overwritten by process.env.PORT, if port is in use, a free one will be determined
host: 'admin.shop.com',
port: 80,
```

## 修复后台用户退出报错

```
http://localhost:8080/admin/logout
500 Internal Server Error

问题：缺少redis
解决：搭建redis，并配置好，重启
https://github.com/tporadowski/redis/releases/
Redis-x64-5.0.14.1.zip
双击redis-server.exe运行
不需要改配置，重启
```

## 数据库表

https://www.macrozheng.com/mall/foreword/mall_foreword_01.html#mall%E6%95%B0%E6%8D%AE%E5%BA%93%E8%A1%A8%E6%A6%82%E8%A7%88

```
数据库表前缀说明
cms_*：内容管理模块相关表  (content)
oms_*：订单管理模块相关表  (order)
pms_*：商品模块相关表    (product)
sms_*：营销模块相关表
ums_*：会员模块相关表  (user)

ms可能是manage system
```

## 后台二次开发

```
1. 登录页面 去掉"获取体验账号"按钮
index.vue
<!-- <el-button style="width: 45%" type="primary" @click.native.prevent="handleTry">
        获取体验账号
      </el-button> -->
2. 菜单去掉 “学习教程” “视频教程”  
  index.js
   {
      name: 'document',
      path: 'https://www.macrozheng.com',
      meta: {title: '学习教程', icon: 'document'}
    },
    {
      name: 'video',
      path: 'https://www.macrozheng.com/mall/catalog/mall_video.html',
      meta: {title: '视频教程', icon: 'video'}
    },
3. 首页去掉 学习教程 视频教程 点Star支持项目      
4. 首页去掉 mall全套学习教程连载中！
 <!--
    <el-card class="mine-layout">
      <div style="text-align: center">
        <img width="150px" height="150px" src="http://macro-oss.oss-cn-shenzhen.aliyuncs.com/mall/banner/qrcode_for_macrozheng_258.jpg">
      </div>
      <div style="text-align: center">mall全套学习教程连载中！</div>
      <div style="text-align: center;margin-top: 5px"><span class="color-main">关注公号</span>，第一时间获取。</div>
    </el-card>
    -->
5. 出现近7天销售总额
6. 修改默认头像
要改数据库ums_admin表的数据 admin icon改为
```

## 修改 admin 密码为 admin

```
权限-》用户列表
http://localhost:8090/#/ums/admin
找到admin编辑 改密码为admin 保存
退出会报错，暂未修复，可换个浏览器重新登录，当然清缓存也可以
```


## 项目搭建

**商城后台后端搭建**

```
插件安装 Lombok

git clone https://github.com/macrozheng/mall

删掉 mall/.git 避免仓库嵌套问题

File -> Project Structure -> + -> Import module -> 选择 mall 的 pom.xml

mall-admin
运行 com.macro.mall.MallAdminApplication 的 main 方法

会报错 问题是数据库没线上
安装 5.7 MySQL 可使用XAMPP里的MySQL临时拿来用 账号root密码空
创建数据库 mall
导入 document/sql/mall.sql
 
mall-admin/src/main/resources/application-dev.yml
修改password为空
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/mall?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&useSSL=false
    username: root
#    password: root
    password:
重启mall-admin/src/main/java/com/macro/mall/MallAdminApplication.java

访问 接口文档 http://localhost:8080/swagger-ui/
```

**商城后台前端项目搭建**

```
部署文档 https://github.com/macrozheng/mall-admin-web

git clone https://github.com/macrozheng/mall-admin-web
或 git clone git@github.com:macrozheng/mall-admin-web.git

删掉mall-admin-web\.git避免仓库嵌套

下载node并安装：https://nodejs.org/dist/v12.14.0/node-v12.14.0-x64.msi
备注：不能安装最新版本，安装文档的版本来

cd mall-admin-web
npm install 下载依赖
npm run dev 运行项目
访问 http://localhost:8090

初始账号admin密码macro123
```

**前台后端项目搭建**

```
文档 https://github.com/macrozheng/mall-app-web

启动 mall-portal/src/main/java/com/macro/mall/portal/MallPortalApplication.java

数据库报错 修改数据库配置
application-dev.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/mall?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&useSSL=false
    username: root
#    password: root
    password: 
重启

2024-06-26 18:17:07.619  INFO 26224 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8085 (http)
2024-06-26 18:17:07.631  INFO 26224 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]

MongoDB RabbitMQ 报错   
需要时再修复
```

**商城前台前端项目搭建**

```
文档 https://github.com/macrozheng/mall-app-web

git clone git@github.com:macrozheng/mall-app-web.git

删除mall-app-web/.git

本项目使用了uni-app专用开发工具HBuilder X（App开发版）开发，下载地址：https://www.dcloud.io/hbuilderx.html
HBuilderX打开mall-app-web.
运行->运行到浏览器->Chrome，会自动访问http://localhost:8060/#/
开发者工具 -> 浏览器改为手机模式
```