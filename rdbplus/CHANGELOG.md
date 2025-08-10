# 版本记录

## 3.1.0

1. 优化初始化方法
2. 更新REAMDE中案例，所有查询都用try-catch捕获异常信息
3. 增加了版本管理version、备份数据库、还原数据库、删除数据库等函数

## 3.0.1

1. 优化文档
2. 增加初始化失败的判断

## 3.0.0

史诗级升级，使用API `5.1.0(18)` 及以上，使用装饰器全自动解析对象，初始化操作简化

## 2.0.1

1. 优化生成的sql

## 2.0.0

1. 优化文档
2. 使用最新API 5.0.3(15)

## 1.0.8

由于DevEco Studio NEXT Beta1（5.0.3.800）版本开始，项目useNormalizedOHMUrl字段默认为true  
为了保持统一，rdbplus也设置为true，并构建字节码格式的HAR

## 1.0.7

以release模式构建HAR  
根据文档 https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-hvigor-build-har-V5#section19788284410  
将本项目工程级build-profile.json5的useNormalizedOHMUrl为false

## 1.0.6

1. 添加了函数：getObject、getObjectBySql，查询得到Object对象类型
2. 将list更名为getList，page更名为getPage，
3. 更新了README文档

## 1.0.5

1. 修改了updateById与insert中对undefined的判断
2. 更新了README文档

## 1.0.4

1. 优化了README文档

## 1.0.3

1. 完善了事务功能

## 1.0.2

1. 优化了README文档

## 1.0.1

1. 优化了README文档

## 1.0.0 初版

1. 发布1.0.0初版