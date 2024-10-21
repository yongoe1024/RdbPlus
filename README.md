# rdb-plus 使用文档

## 简介

这是一个sqlite的增强工具，无需编写sql代码，通过继承BaseMapper类，一行搞定增删改查，为简化开发、提高效率而生。（类似Mybatis-plus）

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
3. 创建一个mapper类，比如 `EmpMapper.ets`
4. 直接在页面中`new出EmpMapper`，就可以调用增删改查的方法，无需编写SQL代码

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

### 第二步：创建Mapper类

推荐在`src/main/ets/mapper`路径中，创建ets文件`EmpMapper.ets`

1. 首先创建`EmpMapper类`，然后继承`BaseMapper`，传入泛型`Employee`
2. 创建构造函数，调用super方法。  
   第一个参数是`一个对象`，包含`表名`、`主键字段名`两项内容  
   第二个参数是`回调函数`:`(res: relationalStore.ResultSet)=> T`，返回一个泛型对象，本意是为了从ResultSet中得到一行数据  
   第三个参数是`可选值`，传入`relationalStore.StoreConfig`，比如数据库名、安全级别等。默认库名`demo.db`

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

export class EmpMapper extends BaseMapper<Employee> {
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
import { EmpMapper } from '../mapper/EmpMapper'

@Entry
@Component
struct Index {
  empMapper = new EmpMapper()

  build()
  {
    Button('查询全部数据').onClick(() => {
       // 查询全部
       let list:1 Employee[]  = await this.empMapper.list(new Wapper())
       // 条件查询
       let list2: Employee[]  = await this.empMapper.list(new Wapper().eq('name', '李四'))
       // 统计总数
       const num:number = await this.empMapper.count(new Wapper())
    })
  }
}
```

### 建表、连接查询等复杂SQl，采用手写SQL方法

1. 调用`EmpMapper`对象中的`getConnection()`方法，得到一个`Connection`对象
2. `Connection`有两个函数：`execDML`、`execDQL`  
   `execDML`是数据操纵函数，执行创建、添加、修改 语句  
   `execDQL`是数据查询函数，执行查询语句

#### 示例

在`EmpMapper.ets`中，添加一个函数`createTable`，用来创建表

```javascript
export class EmpMapper extends BaseMapper<Employee> {
    ...其余省略
    ...

    async createTable() {
        const db = await this.getConnection()
        await db.execDML(`DROP TABLE IF EXISTS t_emp  ;`)
        await db.execDML(
            `create table if not exists "t_emp" (
          id integer primary key autoincrement,
          name varchar(20)
      )`)
        await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['111'])
        await db.close()
    }
}
```

## API介绍

以下代码示例的前提条件是：已经实现了一个mapper类，例如`EmpMapper`

### count

统计结果的行数

| 入参             | 说明   |
|----------------|------|
| wapper: Wapper | 搜索条件 |

| 返回值    | 说明  |
|--------|-----|
| number | 统计值 |

```typescript
// 统计总数
const num:number = await this.empMapper.count(new Wapper())
```

### selectByMap

查询，返回Map数组

| 入参             | 说明   |
|----------------|------|
| wapper: Wapper | 搜索条件 |

| 返回值                                      | 说明    |
|------------------------------------------|-------|
| Map<string, relationalStore.ValueType>[] | Map数组 |

```typescript
// 查询name等于111的数据，封装成Map返回
const mapList = await this.empMapper.selectByMap(new Wapper().eq('name', '111'))
```

### list

查询，返回对象数组

| 入参             | 说明   |
|----------------|------|
| wapper: Wapper | 搜索条件 |

| 返回值 | 说明     |
|-----|--------|
| T[] | 泛型T的数组 |

```typescript
// 查询name等于111的数据，返回数组
const list = await this.empMapper.list(new Wapper().eq('name', '111'))
```

### page

分页查询，返回Page（分页对象）

| 入参             | 说明   |
|----------------|------|
| wapper: Wapper | 搜索条件 |

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
const page = await this.empMapper.page(1, 10)
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
| T 或  undefined | 存在返回结果，不存在返回undefined |

```typescript
// 查询主键ID等于14的数据
this.empMapper.getById(14)
```

### insert

插入一条记录

| 入参     | 说明       |
|--------|----------|
| obj: T | 一个泛型T的对象 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
const emp = new Employee()
emp.name = '新添加的'
// 如果是自增，id可以不用赋值
this.empMapper.insert(emp)
```

### updateById

根据主键ID更新数据

| 入参     | 说明              |
|--------|-----------------|
| obj: T | 一个泛型T的对象，主键不能为空 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
const emp = new Employee()
emp.id = 20
emp.name = '张三'
// 根据主键id修改
this.empMapper.updateById(emp)
```

### update

通过指定条件更新数据

| 入参             | 说明   |
|----------------|------|
| wapper: Wapper | 更新条件 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
// 将name等于张三的数据，改为name等于李四
this.empMapper.update(new Wapper().set('name', '李四').eq('name', '张三'))
```

### deleteById

根据主键ID删除数据

| 入参            | 说明  |
|---------------|-----|
| id: ValueType | 主键值 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
// 删除主键ID等于5的数据
this.empMapper.deleteById(5)
```

### delete

通过指定条件删除数据

| 入参             | 说明   |
|----------------|------|
| wapper: Wapper | 删除条件 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

```typescript
// 删除name等于111的数据
this.empMapper.delete(new Wapper().eq('name', '111'))
```

### getConnection

获取一个数据库连接`Connection`对象，直接进行SQL语句的调用  
参考上面的`建表、连接查询等复杂SQl，采用手写SQL方法`

#### Connection 介绍

##### init

获取一个新的数据库连接

| 入参                                  | 说明    |
|-------------------------------------|-------|
| config: relationalStore.StoreConfig | 数据库配置 |

| 返回值        | 说明           |
|------------|--------------|
| Connection | Connection对象 |

#### execDML

`execDML`是数据操纵函数（DML），执行创建、添加、修改语句

| 入参          | 说明                                  |
|-------------|-------------------------------------|
| sql: string | SQL语句                               |
| params      | 数组，SQL语句中参数的值。该值与sql参数语句中的`？`占位符相对应 |

| 返回值  | 说明       |
|------|----------|
| void | 执行失败抛出异常 |

#### execDQL

`execDQL`是数据查询函数，执行查询语句

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

### rollBack

回滚事务

### close

关闭当前的Connection连接

## 条件构造器介绍

### set

在update语句中，用于指定要修改的列及其新值

```typescript
// 更新`name`等于`张三`的数据，将`name`值更改为`李四`
new Wapper()
  .set('name', '李四')
  .eq('name', '张三')
```

### eq

等于

```typescript
// 查询`name`等于`王二`，并且`age`为`18`的数据
new Wapper().eq('name', '王二').eq('age', 18)
```

### notEq

不等于

```typescript
// 查询`name`不等于`王二`的数据
new Wapper().notEq('name', '王二')
```

### lt

小于

```typescript
// 查询`age`小于`50`的数据
new Wapper().lt('age', 50)
```

### lte

小于等于

```typescript
// 查询`age`小于等于`50`的数据
new Wapper().lte('age', 50)
```

### gt

大于

```typescript
// 查询`age`大于`50`的数据
new Wapper().gt('age', 50)
```

### gte

大于等于

```typescript
// 查询`age`大于等于`50`的数据
new Wapper().gte('age', 50)
```

### in

设置单个字段的值，在给定的集合中

```typescript
// 查询`age`在`18、19、20`之中的数据
new Wapper().in('age', [18, 19, 20])
```

### notIn

设置单个字段的值，不在给定的集合中

```typescript
// 查询`age`不在`18、19、20`之中的数据
new Wapper().notIn('age', [18, 19, 20])
```

### between

设置单个字段的 BETWEEN 条件

```typescript
// 查询 age 在 18-60之间的数据
new Wapper().between('age', 18, 60)

```

### notBetween

设置单个字段的 NOT BETWEEN 条件

```typescript
// 查询 age 不在 18-60之间的数据
new Wapper().notBetween('age', 18, 60)

```

### like

单个字段的模糊匹配条件

```typescript
// 匹配 `name` 的第一个字是`张`的数据
new Wapper().like('name', '张%')
```

### notLike

单个字段的非模糊匹配条件

```typescript
// 匹配 `name` 的第一个字，不是`张`的数据
new Wapper().notLike('name', '张%')
```

### isNull

单个字段为null

```typescript
// 查询 `title` 等于null的数据
new Wapper().isNull('title')
```

### isNotNull

单个字段不为null

```typescript
// 查询 `title` 不等于null的数据
new Wapper().isNotNull('title')
```

### orderByAsc

将查询结果根据某字段进行升序排序，可以多次调用，按顺序拼接order内容

```typescript
// 将查询结果根据id升序排列
new Wapper().orderByAsc('id')
```

### orderByDesc

将查询结果根据某字段进行降序排序，可以多次调用，按顺序拼接order内容

```typescript
// 将查询结果根据id降序排列
new Wapper().orderByDesc('id')
```

### groupBy

设置查询结果的分组条件。通过指定一个或多个字段

```typescript
// 依次根据id、name进行分组
new Wapper().groupBy('id', 'name')
```

生成的sql

```
SELECT * FROM user GROUP BY id, name
```

### having

设置 HAVING 子句，过滤分组后的结果。通常与 GROUP BY 一起使用，用于对分组后的数据进行条件筛选

```typescript
// 根据name分组，过滤分组条件是name不等于张三
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

默认查询为： `select *`
调用select函数，将默认的 `*` 更改为指定内容  
注：若添加了额外内容，例如聚合函数、字段别名，建议使用`selectByMap`方法，将结果从Map中取出

```typescript
//指定字段
new Wapper().select('id,name,age')
//使用函数
new Wapper().select('count(*),sum(age)')
//字段别名
new Wapper().select('age as nianling')
```

## 其他功能

### 多数据源

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

export class EmpMapper extends BaseMapper<Employee> {
  // 构造函数，仅接收参数，将参数传给super
  private constructor(config: relationalStore.StoreConfig) {
    super({ tableName: 't_emp', primaryKey: 'id' }, getRow, config)
  }

  // 手动 new出EmpMapper
  // 数据库1
  static getDemo1DB(): EmpMapper {
    return new EmpMapper(
      {
        name: 'Demo1DB.db',
        securityLevel: relationalStore.SecurityLevel.S1
      }
    )
  }

  // 数据库2
  static getDemo2DB(): EmpMapper {
    return new EmpMapper(
      {
        name: 'Demo2DB.db',
        securityLevel: relationalStore.SecurityLevel.S1
      }
    )
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
  empMapper = new EmpMapper()

  build() {

    Row() {

      Button('事务成功').onClick(async (event: ClickEvent) => {
      
        // 获取一个db连接
        const db = await this.empMapper.getConnection()
        try {
          //开启事务
          db.beginTransaction()
          const emp = new Employee()
          emp.name = '事务'
          // 将 db 传进去，保持所有操作在同一连接上
          this.empMapper.insert(emp, db)
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
        const db = await this.empMapper.getConnection()
        try {
          db.beginTransaction()
          const emp = new Employee()
          emp.name = '事务失败'
          // 将 db 传进去，保持所有操作在同一连接上
          this.empMapper.insert(emp, db)
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
