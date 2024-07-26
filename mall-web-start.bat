@REM net start MariaDB
cd mall-admin-web
start npm run dev
@REM redis
D:
cd D:\Redis-x64-5.0.14.1
start redis-server.exe
@REM minio
start D:\MinIO\minio.exe server C:\Users\zhouhuajian\Desktop\pytest-selenium\shop-com\minio-data --console-address ":9001"
@REM rabbitmq
cd D:\RabbitMQServer\rabbitmq_server-3.13.4\sbin
@REM start rabbitmq-server.bat