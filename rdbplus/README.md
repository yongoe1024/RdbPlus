# rdb-plus 使用文档
- [简介](#简介)
- [版本说明](#版本说明)
- [下载安装](#下载安装)
- [使用案例](#使用案例)
- [功能介绍](#功能介绍)
- [引入教程](#引入教程)
  - [初始化](#初始化)
  - [第一步：创建实体类](#第一步创建实体类)
  - [第二步：创建Mapper类](#第二步创建mapper类)
  - [第三步：页面中调用](#第三步页面中调用)
  - [建表、连接查询等复杂SQl，采用手写SQL方法](#建表连接查询等复杂sql采用手写sql方法)
- [API介绍](#api介绍)
  - [count](#count)
  - [getObject](#getobject)
  - [getObjectBySql](#getobjectbysql)
  - [getList](#getlist)
  - [getOne](#getone)
  - [getPage](#getpage)
  - [getById](#getbyid)
  - [insert](#insert)
  - [insertBatch](#insertbatch)
  - [updateById](#updatebyid)
  - [update](#update)
  - [deleteById](#deletebyid)
  - [delete](#delete)
  - [getConnection](#getconnection)
- [条件构造器介绍](#条件构造器介绍)
- [其他功能](#其他功能)
  - [多数据源](#多数据源)
  - [事务](#事务)
- [贡献代码](#贡献代码)
- [开源协议](#开源协议)


## 简介

SQLite的ORM框架，无需编写sql代码，通过装饰器解析表结构，一行搞定增删改查

已在`哈啰出行`、`一汽奥迪`等APP中使用

QQ交流群：1056151960

## 版本说明

3.0.0 使用API `5.1.0(18)` 编译

经过测试，在低版本系统也可运行

[工程版本升级教程](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-integrated-project-migration)

## 下载安装

`ohpm i rdbplus`  
OpenHarmony ohpm
环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://ohpm.openharmony.cn/#/cn/help/downloadandinstall)

## 使用案例

https://gitee.com/yongoe/RdbPlus/tree/main/entry/src/main/ets

https://github.com/yongoe1024/RdbPlus/tree/main/entry/src/main/ets


## 功能介绍

| 函数名            | 介绍                    |
|----------------|-----------------------|
| count          | 查询符合条件的记录总数           |
| getList        | 查询符合条件的记录             |
| getPage        | 分页查询符合条件的记录           |
| getOne         | 查询第一个符合条件的记录          |
| getObject      | 查询符合条件的记录，返回对象数组      |
| getObjectBySql | 输入SQL查询符合条件的记录，返回对象数组 |
| getById        | 根据主键查询                |
| insert         | 插入一条记录                |
| insertBatch    | 插入多条记录                |
| updateById     | 根据主键更新数据              |
| update         | 更新符合条件的记录             |
| deleteById     | 根据主键删除                |
| delete         | 删除符合条件的记录             |

## 引入教程

1. 首先引入ohpm依赖：`ohpm i rdbplus`
2. 在`EntryAbility` 的 `onWindowStageCreate` 中调用 `Connection.init()` 进行初始化
3. 创建一个数据库表对应的ets类，并用装饰器`@Table`、`@TableField`标注
4. 创建一个class，用来做单例模式
5. 直接在页面中获取实例，就可以调用增删改查的方法，无需编写SQL代码

### 初始化

在`EntryAbility` 的 `onWindowStageCreate` 中调用 `Connection.init()` 进行初始化

传入两个参数：Context、日志DbLogger（可空）

rdbplus提供了`DbLogger`，可以自行继承`Logger`接口构造日志对象

```typescript
export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {

    windowStage.loadContent('pages/Index', (err) => {
      windowStage.getMainWindow().then(res => {
        Connection.init(res.getUIContext().getHostContext(), new DbLogger())
      })
    });
  }
}
```

### 第一步：创建实体类

1. 创建`Employee.ets`，字段名要与数据库字段一一对应
2. 数据库没有的字段，不需要标注`@TableField`，
3. 当数据库表中有字段，而class没有，不影响结果，数据库返回的结果，都可以正常从返回结果中取出来
4. 数据表字段类型与class字段类型不一致，不影响结果，ets的类型仅在编译期限制（建议类型保持一致）

```typescript
import { Table, TableField, FieldType } from "rdbplus"

@Table({ tableName: 't_emp' })
export class Employee {
  /**
   * id
   */
  @TableField({ name: 'id', type: FieldType.NUMBER, isPrimaryKey: true })
  id?: number
  /**
   * 名字
   */
  @TableField({ name: 'name', type: FieldType.TEXT, })
  name?: string
  /**
   * 年龄
   */
  @TableField({ name: 'age', type: FieldType.NUMBER, })
  age?: number
}
```

### 第二步：创建Mapper类

1. 创建static变量 `private static mapper: BaseMapper<Employee>`
2. 使用 `BaseMapper.build()` 创建实例，三个参数分别为`Employee实体类`，`数据库名`，`安全级别`

```typescript
import { relationalStore } from '@kit.ArkData'
import { BaseMapper } from 'rdbplus'
import { Employee } from './Employee'

export class EmpMapper {
  private static mapper: BaseMapper<Employee>

  // 单例模式
  static getInstance() {
    if (!EmpMapper.mapper) {
      EmpMapper.mapper = BaseMapper.build<Employee>({
        class: Employee,
        dbName: '表名',
        securityLevel: relationalStore.SecurityLevel.S1
      })
    }
    return EmpMapper.mapper
  }

  /**
   * 可以从实例中获取Connection，直接操作SQL语句
   */
  static async createTable() {
    const db = await EmpMapper.getInstance().getConnection()
    await db.execDML(`DROP TABLE IF EXISTS t_emp  ;`, [])
    await db.execDML(
      `create table if not exists "t_emp" (
          id integer primary key autoincrement,
          name varchar(20),
          age integer
      )`, [])
    await db.close()
  }
}
```

### 第三步：页面中调用

```
@Entry
@Component
struct Index {
  mapper = EmpMapper.getInstance()

  build() {
     Button('初始化').onClick(() => {
        EmpMapper.createTable()
      })
      
    Button('等于 name==123').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().eq('name', '123'))
      })
  }
}
```

### 建表、连接查询等复杂SQl，采用手写SQL方法

1. 调用`EmpMapper`对象中的`getConnection()`方法，得到一个`Connection`对象
2. `Connection`有两个函数：`execDML`、`execDQL`  
   `execDML`是数据操纵函数，执行创建、添加、修改 语句  
   `execDQL`是数据查询函数，执行查询语句

## API介绍

### count

查询符合条件的记录总数

| 入参               | 说明   |
|------------------|------|
| wrapper: Wrapper | 查询条件 |

| 返回值    | 说明  |
|--------|-----|
| number | 统计值 |

```typescript
const num:number = await this.mapper.count(new Wrapper())
```

### getObject

查询符合条件的记录，返回一个对象

| 入参               | 说明   |
|------------------|------|
| wrapper: Wrapper | 搜索条件 |

| 返回值        | 说明   |
|------------|------|
| EsObject[] | 对象数组 |

```typescript
const res: ESObject = await this.mapper.getObject(new Wrapper().eq('name', '123'))
```

### getObjectBySql

传入SQL，查询符合条件的记录，返回对象数组

| 入参                                  | 说明    |
|-------------------------------------|-------|
| sql: string                         | sql语句 |
| params: relationalStore.ValueType[] | 占位符参数 |

| 返回值        | 说明   |
|------------|------|
| EsObject[] | 对象数组 |

```typescript
const res: ESObject = await this.mapper.getObjectBySql('select count(*) from t_emp where age = ? ', [13])
```

### getList

查询符合条件的记录，返回对象数组

| 入参               | 说明   |
|------------------|------|
| wrapper: Wrapper | 搜索条件 |

| 返回值 | 说明   |
|-----|------|
| T[] | 对象数组 |

```typescript
const res = await this.mapper.getList(new Wrapper().eq('name', '123'))
```

### getOne

查询符合条件的第一条数据

| 入参               | 说明   |
|------------------|------|
| wrapper: Wrapper | 搜索条件 |

| 返回值 | 说明   |
|-----|------|
| T   | 实体对象 |

```typescript
const res = await this.mapper.getOne(new Wrapper().eq('name', '123'))
```

### getPage

分页查询符合条件的记录，返回分页结果

| 入参               | 说明   |
|------------------|------|
| wrapper: Wrapper | 搜索条件 |

| 返回值     | 说明     |
|---------|--------|
| Page<T> | 分页查询结果 |

| Page    | 说明   |
|---------|------|
| total   | 总数   |
| current | 当前页  |
| size    | 每页数量 |
| record  | 结果集  |

```typescript
// 查询第一页的数据，返回Page对象
const page = await this.mapper.getPage(1, 10)
// 总数
const total = page.total
// 当前页
const current = page.current
// 每页条数
const size = page.size
// 结果集
const record = page.record
```

### getById

根据主键查询，返回一个实体对象

| 入参            | 说明  |
|---------------|-----|
| id: ValueType | 主键值 |

| 返回值           | 说明                      |
|---------------|-------------------------|
| T 或 undefined | 存在返回实体对象，不存在返回undefined |

```typescript
const res = await this.mapper.getById(3)
```

### insert

插入一条记录

注：若插入的某个字段为空，可以设置为 `undefined或null`

| 入参     | 说明   |
|--------|------|
| obj: T | 实体对象 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
const emp = new Employee()
emp.name = '新添加的'
// 如果是自增，id可以不用赋值
this.mapper.insert(emp)
```

### insertBatch

插入一组记录  
注：若插入的某个字段为空，可以设置为 `undefined或null`

| 入参        | 说明   |
|-----------|------|
| list: T[] | 实体对象 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
const emp = new Employee()
emp.name = '新添加的'
// 如果是自增，id可以不用赋值
this.mapper.insertBatch([emp])
```

### updateById

根据主键更新符合条件的记录

注：不想更新的字段必须设置为`undefined`或者不传入，其他值包括null，都会更新到数据库

| 入参     | 说明          |
|--------|-------------|
| obj: T | 一个对象，主键不能为空 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
const emp = new Employee()
emp.id = 3
emp.name = '修改'
await this.mapper.updateById(emp)
```

### update

通过指定条件更新数据

| 入参               | 说明   |
|------------------|------|
| wrapper: Wrapper | 更新条件 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
// 将name=李四的数据修改为张三
await this.mapper.update(new Wrapper()
  .set('name', '张三')
  .eq('name', '李四'))
```

### deleteById

根据主键删除数据

| 入参            | 说明  |
|---------------|-----|
| id: ValueType | 主键值 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
// 删除主键ID等于5的数据
this.mapper.deleteById(5)
```

### delete

通过指定条件删除数据

| 入参               | 说明   |
|------------------|------|
| wrapper: Wrapper | 删除条件 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
// 删除name等于111的数据
this.mapper.delete(new Wrapper().eq('name', '111'))
```

### getConnection

获取一个数据库的连接对象`Connection`，调用Connection可以直接进行SQL语句的调用

参考上面的`建表、连接查询等复杂SQl，采用手写SQL方法`

#### create

static函数，获取一个新的数据库连接

| 入参                                  | 说明    |
|-------------------------------------|-------|
| config: relationalStore.StoreConfig | 数据库配置 |

| 返回值        | 说明           |
|------------|--------------|
| Connection | Connection对象 |

#### execDML

数据操纵函数（DML），执行插入、删除、修改语句

| 入参          | 说明                                  |
|-------------|-------------------------------------|
| sql: string | SQL语句                               |
| params      | 数组，SQL语句中参数的值。该值与sql参数语句中的`？`占位符相对应 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

#### execDQL

是数据查询函数，执行select语句

| 入参          | 说明                                  |
|-------------|-------------------------------------|
| sql: string | SQL语句                               |
| params      | 数组，SQL语句中参数的值。该值与sql参数语句中的`？`占位符相对应 |

| 返回值                       | 说明          |
|---------------------------|-------------|
| relationalStore.ResultSet | 返回ResultSet |

#### beginTransaction

开启事务

#### commit

提交事务

#### rollBack

回滚事务

#### close

关闭当前的Connection连接

## 条件构造器介绍

### select

默认查询为： `select *`
调用select函数，将默认的 `*` 更改为指定字段  
注：若查询特殊字段，例如聚合统计、字段别名，建议使用`getObject/getObjectBySql`方法，将结果从any对象中取出

```typescript
const res: ESObject[] = await this.mapper.getObject(new Wrapper()
  .groupBy('age')
  .select('age', 'count(*)'))
```

### set

在update语句中，用于指定要修改的列及其新值

```typescript
// 更新`name`等于`张三`的数据，将`name`值更改为`李四`
new Wrapper()
  .set('name', '李四')
  .eq('name', '张三')
```

### eq

等于

```typescript
// 查询`name`等于`王二`，并且`age`为`18`的数据
new Wrapper().eq('name', '王二').eq('age', 18)
```

### notEq

不等于

```typescript
// 查询`name`不等于`王二`的数据
new Wrapper().notEq('name', '王二')
```

### lt

小于

```typescript
// 查询`age`小于`50`的数据
new Wrapper().lt('age', 50)
```

### lte

小于等于

```typescript
// 查询`age`小于等于`50`的数据
new Wrapper().lte('age', 50)
```

### gt

大于

```typescript
// 查询`age`大于`50`的数据
new Wrapper().gt('age', 50)
```

### gte

大于等于

```typescript
// 查询`age`大于等于`50`的数据
new Wrapper().gte('age', 50)
```

### in

设置单个字段的值，在给定的集合中

```typescript
// 查询`age`在`18、19、20`之中的数据
new Wrapper().in('age', [18, 19, 20])
```

### notIn

设置单个字段的值，不在给定的集合中

```typescript
// 查询`age`不在`18、19、20`之中的数据
new Wrapper().notIn('age', [18, 19, 20])
```

### between

设置单个字段的 BETWEEN 条件

```typescript
// 查询 age 在 18-60之间的数据
new Wrapper().between('age', 18, 60)
```

### notBetween

设置单个字段的 NOT BETWEEN 条件

```typescript
// 查询 age 不在 18-60之间的数据
new Wrapper().notBetween('age', 18, 60)
```

### like

单个字段的模糊匹配条件

```typescript
// 匹配 `name` 的第一个字是`张`的数据
new Wrapper().like('name', '张%')
```

### notLike

单个字段的非模糊匹配条件

```typescript
// 匹配 `name` 的第一个字，不是`张`的数据
new Wrapper().notLike('name', '张%')
```

### isNull

单个字段为null

```typescript
// 查询 `title` 等于null的数据
new Wrapper().isNull('title')
```

### isNotNull

单个字段不为null

```typescript
// 查询 `title` 不等于null的数据
new Wrapper().isNotNull('title')
```

### orderByAsc

将查询结果根据某字段进行升序排序，可以多次调用，按顺序拼接order内容

```typescript
// 将查询结果根据id升序排列
new Wrapper().orderByAsc('id')
```

### orderByDesc

将查询结果根据某字段进行降序排序，可以多次调用，按顺序拼接order内容

```typescript
// 将查询结果根据id降序排列
new Wrapper().orderByDesc('id')
```

### groupBy

设置查询结果的分组条件。通过指定一个或多个字段

```typescript
// 可以用getList，类型仅在编译期限制
const res: ESObject[] = await this.mapper.getObject(new Wrapper()
  .groupBy('age')
  .select('age', 'count(*)'))
```

### having

设置 HAVING 子句，过滤分组后的结果。通常与 GROUP BY 一起使用，用于对分组后的数据进行条件筛选

```typescript
// 可以用getList，类型仅在编译期限制
const res: ESObject[] = await this.mapper.getList(new Wrapper()
  .select('age', 'count(*)')
  .groupBy('age')
  .having(`age != 30`))
```

### or

用于在查询条件中添加 OR 逻辑。通过调用 or 方法，可以改变后续查询条件的连接方式，从默认的 AND 连接变为 OR 连接

```typescript
new Wrapper().eq('name', '111')
  .or(new Wrapper().eq('name', '222').eq('age', 18))
```

生成SQL为

```
where name = '111' or ( name = '222' and age=18 )
```

### and

用于在查询条件中添加 AND 逻辑，在一个 AND 逻辑块中包含多个查询条件

```typescript
new Wrapper()
  .eq('name', '111')
  .and(new Wrapper().notEq('name', '222'))
```

生成SQL为

```
where name = '111' and ( name != '222' )
```

## 其他功能

### 多数据源

参考如下示例

```typescript
import { relationalStore } from '@kit.ArkData'
import { BaseMapper } from 'rdbplus'
import { Employee } from './Employee'

/**
 * 多数据源示例
 */
export class MapperMultiple {
  private static mapper1: BaseMapper<Employee>
  private static mapper2: BaseMapper<Employee>

  // 单例模式 db1
  static getInstance1DB() {
    if (!MapperMultiple.mapper1) {
      MapperMultiple.mapper1 = BaseMapper.build<Employee>({
        class: Employee,
        dbName: 'db1',
        securityLevel: relationalStore.SecurityLevel.S1
      })
    }
    return MapperMultiple.mapper1
  }

  // 单例模式 db2
  static getInstance2DB() {
    if (!MapperMultiple.mapper2) {
      MapperMultiple.mapper2 = BaseMapper.build<Employee>({
        class: Employee,
        dbName: 'db2',
        securityLevel: relationalStore.SecurityLevel.S1
      })
    }
    return MapperMultiple.mapper2
  }
}
```

### 事务

参考如下代码

```
import { Employee } from '../entity/Employee'
import { EmpMapper } from '../mapper/EmpMapper'

@Entry
@Component
struct Index {
  mapper = new EmpMapper()

  build() {

    Row() {

      Button('事务成功').onClick(async (event: ClickEvent) => {
        // 获取一个db连接
        const db = await this.mapper.getConnection()
        try {
          //开启事务
          db.beginTransaction()
          const emp = new Employee()
          emp.name = '事务'
          // 将 db 传进去，保持所有操作在同一连接上
          this.mapper.insert(emp, db)
          //提交事务
          db.commit()
        } catch (e) {
          // 回滚
          db.rollBack()
        } finally {
          // 关闭连接
          db.close()
        }
        
      })

      Button('事务失败').onClick(async (event: ClickEvent) => {
        // 获取一个db连接
        const db = await this.mapper.getConnection()
        try {
          db.beginTransaction()
          const emp = new Employee()
          emp.name = '事务失败'
          // 将 db 传进去，保持所有操作在同一连接上
          this.mapper.insert(emp, db)
          // 抛出异常，回滚事务
          throw new Error()
          //提交事务
          db.commit()
        } catch (e) {
          // 回滚
          db.rollBack()
        } finally {
          // 关闭连接
          db.close()
        }
        
      })
    }
  }
}
```

## 贡献代码

使用过程中发现任何问题都可以提 `Issue`，也欢迎您发 `PR`

https://gitee.com/yongoe/RdbPlus

https://github.com/yongoe1024/RdbPlus `(以github为主)`

## 开源协议

本项目基于 [MIT License](https://mit-license.org)
