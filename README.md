# Spring Boot 商城项目源码分析

https://www.macrozheng.com/  
https://www.macrozheng.com/admin/index.html#/login  
https://github.com/macrozheng/mall  
https://github.com/macrozheng/mall-admin-web  
https://www.macrozheng.com/mall/deploy/mall_deploy_windows.html

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