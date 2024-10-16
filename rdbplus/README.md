# rdb-plus 使用文档

## 简介

这是一个sqlite的增强工具，无需编写sql代码，通过继承BaseMapper类，一行搞定增删改查，为简化开发、提高效率而生。

## 下载安装

`ohpm i rdbplus`  
OpenHarmony ohpm
环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://ohpm.openharmony.cn/#/cn/help/downloadandinstall)

## 使用案例

https://gitee.com/yongoe/RdbPlus/tree/main/entry/src/main/ets

https://github.com/yongoe1024/RdbPlus/tree/main/entry/src/main/ets

## 功能介绍

| 函数名         | 介绍               |
|-------------|------------------|
| count       | 统计结果的行数          |
| selectByMap | select查询，返回Map数组 |
| list        | select查询         |
| page        | select分页查询       |
| getById     | 根据主键ID查询         |
| insert      | 插入一条记录           |
| updateById  | 根据主键ID更新数据       |
| update      | 通过指定条件更新数据       |
| deleteById  | 根据主键ID删除数据       |
| delete      | 通过指定条件删除数据       |

## 引入教程

1. 首先引入ohpm依赖：`ohpm i rdbplus`
2. 创建一个数据库表对应的实体类，推荐ts格式，比如`Employee.ts`
3. 创建一个Model类，比如 `EmpModel.ets`
4. 直接在页面中`new出EmpModel`，就可以随意调用EmpModel的方法，无需编写sql代码

### 第一步：创建实体类

推荐在`src/main/ets/entity`路径中，创建ts文件`Employee.ts`

```typescript
export class Employee {
  id: number
  name: string

  constructor() {
  }
}
```

### 第二步：创建Model类

推荐在`src/main/ets/model`路径中，创建ets文件`EmpModel.ets`

1. 首先创建`EmpModel类`，然后继承`BaseMapper`，传入泛型`Employee`
2. 创建构造函数，调用super方法。  
   第一个参数是`一个对象`，包含`表名`、`主键字段名`两项内容  
   第二个参数是`箭头函数`:`(res: relationalStore.ResultSet)=> T`，返回一个泛型对象，本意是为了从ResultSet中得到一行数据  
   第三个参数是`可选值`，传入`relationalStore.StoreConfig`，比如数据库名、安全级别等。默认库名name: 'demo.db'

```typescript
import { Employee } from '../entity/Employee'
import { relationalStore } from '@kit.ArkData'
import { BaseMapper } from 'rdbplus'

const getRow = (res: relationalStore.ResultSet) => {
  const emp = new Employee()
  emp.id = res.getLong(res.getColumnIndex('id'))
  emp.name = res.getString(res.getColumnIndex('name'))
  return emp
}

export class EmpModel extends BaseMapper<Employee> {
  constructor() {
    super(
      { tableName: 't_emp', primaryKey: 'id' },
      getRow,
      // 可选参数
      { name: 'demo.db', securityLevel: relationalStore.SecurityLevel.S1 }
    )
  }
}
```

### 第三步：页面中调用

```
import { EmpModel } from '../model/EmpModel'

@Entry
@Component
struct Index {
  empModel = new EmpModel()

  build()
  {
    Button('查询全部数据').onClick(() => {
      // 查询全部
       let list:1 Employee[]  = await this.empModel.list()
      // 条件查询
       let list2: Employee[]  = await this.empModel.list(new Wapper().eq('name', '李四'))
    })
  }
}


```

### 建表、连接查询等复杂SQl，采用手写SQL方法

1. 调用`EmpModel`对象中的`getDbHelper()`方法，得到一个`DBHelper`
2. DBHelper包含两个函数：`execDML`、`execDQL`，分别是数据操纵函数（DML）、数据查询函数（DQL）

#### 示例

在`EmpModel.ets`中，添加一个函数`createTable`

```javascript
export class EmpModel extends BaseMapper<Employee> {
    ...其余省略
    ...

    async createTable() {
        // 删除旧表（可选）
        await this.getDbHelper().execDML(`DROP TABLE t_emp;`, [])
        // 调用DML方法，创建表
        await this.getDbHelper().execDML(
            `create table if not exists "t_emp" (
          id integer primary key autoincrement,
          name varchar(20)
      )`, [])
        // 调用DML方法，插入一条数据
        await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['第一条数据'])
        // 调用DQL方法，查询数据库
        const res = await this.getDbHelper().execDQL(`SELECT * FROM user left join student ....后续省略;`, [])
    }
}
```

## API介绍

本章内容的前提条件是：已经实现了一个Model类，例如`EmpModel`

### getDbHelper

获取一个DbHelper对象，直接进行SQL语句的调用

1. 调用`EmpModel`中的`getDbHelper()`函数，得到一个`DBHelper`对象
2. DBHelper包含两个函数：`execDML`、`execDQL`，分别是数据操纵函数（DML）、数据查询函数 （DQL）

本示例和上面的`建表、连接查询等复杂SQl，采用手写SQL方法`一致

```javascript
// 在`EmpModel.ets`中，添加一个函数`createTable`
export class EmpModel extends BaseMapper<Employee> {
    ...其余省略
    ...

    async createTable() {
        // 删除旧表（可选）
        await this.getDbHelper().execDML(`DROP TABLE t_emp;`, [])
        // 调用DML方法，创建表
        await this.getDbHelper().execDML(
            `create table if not exists "t_emp" (
          id integer primary key autoincrement,
          name varchar(20)
      )`, [])
        // 调用DML方法，插入一条数据
        await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['第一条数据'])
        // 调用DQL方法，查询数据库
        const res = await this.getDbHelper().execDQL(`SELECT * FROM user left join student ....后续省略;`, [])
    }
}
```

### count

统计结果的行数

| 入参             | 说明      |
|----------------|---------|
| wapper: Wapper | 可选：搜索条件 |

| 返回值    | 说明  |
|--------|-----|
| number | 统计数 |

```typescript
const num:number = await this.empModel.count(new Wapper())
```

### selectByMap

select查询，返回Map数组

| 入参             | 说明      |
|----------------|---------|
| wapper: Wapper | 可选：搜索条件 |

| 返回值                                      | 说明    |
|------------------------------------------|-------|
| Map<string, relationalStore.ValueType>[] | Map数组 |

```typescript
const mapList = await this.empModel.selectByMap(new Wapper().eq('name', '111'))
```

### list

select查询，返回对象数组

| 入参             | 说明      |
|----------------|---------|
| wapper: Wapper | 可选：搜索条件 |

| 返回值 | 说明     |
|-----|--------|
| T[] | 泛型T的数组 |

```typescript
 const list = await this.empModel.list(new Wapper().eq('name', '111'))
```

### page

select分页查询，返回Page分页对象

| 入参             | 说明      |
|----------------|---------|
| wapper: Wapper | 可选：搜索条件 |

| 返回值     | 说明        |
|---------|-----------|
| Page<T> | 泛型T的Page类 |

| Page类   | 说明   |
|---------|------|
| total   | 总数   |
| current | 当前页  |
| size    | 每页数量 |
| record  | 结果集  |

```typescript
const page = await this.empModel.page(1, 10)
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

根据主键ID查询

| 入参            | 说明  |
|---------------|-----|
| id: ValueType | 主键值 |

| 返回值            | 说明                    |
|----------------|-----------------------|
| T 或  undefined | 查到返回结果，未查到返回undefined |

```typescript
this.empModel.getById(14)
```

### insert

插入一条记录

| 入参     | 说明       |
|--------|----------|
| obj: T | 一个泛型T的对象 |

| 返回值  | 说明     |
|------|--------|
| void | 失败抛出异常 |

```typescript
const emp = new Employee()
emp.name = '新添加的'
// id没赋值，因为是自增
this.empModel.insert(emp)
```

### updateById

根据主键ID更新数据

| 入参     | 说明              |
|--------|-----------------|
| obj: T | 一个泛型T的对象，主键不能为空 |

| 返回值     | 说明                 |
|---------|--------------------|
| void | 失败抛出异常 |

```typescript
const emp = new Employee()
emp.id = 20
emp.name = '根据id修改'
this.empModel.updateById(emp)
```

### update

通过指定条件更新数据

| 入参             | 说明   |
|----------------|------|
| wapper: Wapper | 更新条件 |

| 返回值     | 说明                 |
|---------|--------------------|
| void | 失败抛出异常 |

```typescript
this.empModel.update(new Wapper().set('name', '修改为bbb').eq('name', 'name等于aaa'))
```

### deleteById

根据主键ID删除数据

| 入参            | 说明  |
|---------------|-----|
| id: ValueType | 主键值 |

| 返回值     | 说明                 |
|---------|--------------------|
| void | 失败抛出异常 |

```typescript
this.empModel.deleteById(5)
```

### delete

通过指定条件删除数据

| 入参             | 说明   |
|----------------|------|
| wapper: Wapper | 删除条件 |

| 返回值     | 说明                 |
|---------|--------------------|
| void | 失败抛出异常 |

```typescript
this.empModel.delete(new Wapper().eq('name', '111'))
```

## 条件构造器介绍

### set

在update语句中，用于指定要修改的列及其新值  
更新`name`等于`张三`的数据，将`name`值更改为`李四`

```typescript
new Wapper()
  .set('name', '李四')
  .eq('name', '张三')
```

### eq

等于  
查询`name`等于`王二`，并且`age`为`18`的数据

```typescript
new Wapper().eq('name', '王二').eq('age', 18)
```

### notEq

不等于   
查询`name`不等于`王二`的数据

```typescript
new Wapper().notEq('name', '王二')
```

### lt

小于  
查询`age`小于`50`的数据

```typescript
new Wapper().lt('age', 50)
```

### lte

小于等于  
查询`age`小于等于`50`的数据

```typescript
new Wapper().lte('age', 50)
```

### gt

大于  
查询`age`大于`50`的数据

```typescript
new Wapper().gt('age', 50)
```

### gte

大于等于  
查询`age`大于等于`50`的数据

```typescript
new Wapper().gte('age', 50)
```

### in

设置单个字段的值，在给定的集合中  
查询`age`在`18、19、20`之中的数据

```typescript
new Wapper().in('age', [18, 19, 20])
```

### notIn

设置单个字段的值，不在给定的集合中  
查询`age`不在`18、19、20`之中的数据

```typescript
new Wapper().notIn('age', [18, 19, 20])
```

### between

设置单个字段的 BETWEEN 条件  
查询 age 在 18-60之间的数据

```typescript
new Wapper().between('age', 18, 60)

```

### notBetween

设置单个字段的 NOT BETWEEN 条件  
查询 age 不在 18-60之间的数据

```typescript
new Wapper().notBetween('age', 18, 60)

```

### like

单个字段的模糊匹配条件  
查询 `name` 字段的第一个字符是`张`的数据

```typescript
new Wapper().like('name', '张%')
```

查询 `title` 字段`你好`结尾的数据

```typescript
new Wapper().like('title', '%你好')
```

### notLike

单个字段的非模糊匹配条件  
查询 `name` 的第一个字符不是`张`的数据

```typescript
new Wapper().notLike('name', '张%')
```

### isNull

单个字段为null  
查询 `title` 等于null的数据

```typescript
new Wapper().isNull('title')
```

### isNotNull

单个字段不为null  
查询 `title` 不等于null的数据

```typescript
new Wapper().isNotNull('title')
```

### orderByAsc

将查询结果根据某字段进行升序排序，可以多次调用，按顺序拼接order内容   
将查询结果根据id升序排列

```typescript
new Wapper().orderByAsc('id')
```

### orderByDesc

将查询结果根据某字段进行降序排序，可以多次调用，按顺序拼接order内容  
将查询结果根据id降序排列

```typescript
new Wapper().orderByDesc('id')
```

### groupBy

设置查询结果的分组条件。通过指定一个或多个字段

```typescript
new Wapper().groupBy('id', 'name')
```

生成的sql

```
SELECT * FROM user GROUP BY id, name
```

### having

设置 HAVING 子句，过滤分组后的结果。通常与 GROUP BY 一起使用，用于对分组后的数据进行条件筛选

```typescript
new Wapper().groupBy('name').having(`name != '张三'`)
```

生成的sql

```
SELECT * FROM user GROUP BY name HAVING name != '张三'
```

### or

用于在查询条件中添加 OR 逻辑。通过调用 or 方法，可以改变后续查询条件的连接方式，从默认的 AND 连接变为 OR 连接

```typescript
new Wapper().eq('name', '111')
  .or(new Wapper().eq('name', '222').eq('age', 18))
```

生成SQL为

```
name = '111' or ( name = '222' and age=18 )
```

### and

用于在查询条件中添加 AND 逻辑。通过调用 and 方法，可以创建 AND 嵌套条件，即在一个 AND 逻辑块中包含多个查询条件

```typescript
new Wapper()
  .eq('name', '111')
  .and(new Wapper().notEq('name', '222'))
```

生成SQL为

```
name = '111' and ( name != '222' )
```

### select

由默认的 select * 更改为指定内容  
注：若添加了额外内容，例如函数、别名，建议使用selectByMap方法，从Map中取出结果

```typescript
//指定字段
new Wapper().select('id,name,age')
//使用函数
new Wapper().select('count(*),sum(age)')
//字段别名
new Wapper().select('age as nianling')
```

## 其他功能

#### 多数据源

参考如下示例

```typescript
import { Employee } from '../entity/Employee'
import { relationalStore } from '@kit.ArkData'
import { BaseMapper, MapperParam } from 'rdbplus'

// 实现一个 getRow
const getRow = (res: relationalStore.ResultSet) => {
  const emp = new Employee()
  emp.id = res.getLong(res.getColumnIndex('id'))
  emp.name = res.getString(res.getColumnIndex('name'))
  return emp
}

export class EmpModel extends BaseMapper<Employee> {
  // 构造函数，仅接收参数，将参数传给super
  private constructor(param: MapperParam, getRow: (res: relationalStore.ResultSet) => Employee,
    config?: relationalStore.StoreConfig) {
    super(param, getRow, config)
  }

  // 手动 new出EmpModel，第三个参数可设置数据库名
  // 数据库1
  static getDemo1DB(): EmpModel {
    return new EmpModel(
      { tableName: 't_emp', primaryKey: 'id' },
      getRow,
      {
        name: 'Demo1DB.db',
        securityLevel: relationalStore.SecurityLevel.S1
      }
    )
  }

  // 数据库2
  static getDemo2DB(): EmpModel {
    return new EmpModel(
      { tableName: 't_emp', primaryKey: 'id' },
      getRow,
      {
        name: 'Demo2DB.db',
        securityLevel: relationalStore.SecurityLevel.S1
      }
    )
  }
}
```

#### 事务

暂未实现

## 贡献代码

使用过程中发现任何问题都可以提 `Issue`，也欢迎您发 `PR`

https://gitee.com/yongoe/RdbPlus

https://github.com/yongoe1024/RdbPlus `(以github为主)`

## 开源协议

本项目基于 [MIT License](https://mit-license.org)
