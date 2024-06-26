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
```