# Spring Boot 商城项目源码分析

https://www.macrozheng.com/  
https://www.macrozheng.com/admin/index.html#/login  
https://github.com/macrozheng/mall  
https://github.com/macrozheng/mall-admin-web  
https://www.macrozheng.com/mall/deploy/mall_deploy_windows.html

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