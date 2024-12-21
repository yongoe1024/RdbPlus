# 版本记录

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