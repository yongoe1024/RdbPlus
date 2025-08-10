import { relationalStore } from "@kit.ArkData";
import { Connection } from "./core/Connection";
import { Wrapper } from "./core/Wrapper";
import { Page } from "./model/Page";
import { BuildParams } from "./model/BuildParams";
import { getColumnMeta, getEntityMeta } from "./core/DecoratorUtils";
import { SqlUtils } from "./core/SqlUtils";
import { MyWrapper } from "./core/MyWrapper";

export class BaseMapper<T> {
  private config: relationalStore.StoreConfig
  private sqlUtils: SqlUtils<T>
  private getRow: (res: relationalStore.ResultSet) => T

  public static build<T>(param: BuildParams<T>): BaseMapper<T> {
    let tableName = getEntityMeta(param.class)
    let columnsMeta = getColumnMeta(param.class)
    // 校验参数
    if (tableName && columnsMeta.length > 0) {
    } else {
      console.error('rdb BaseMapper build 失败，实体类缺少装饰器')
      throw new Error('实体类缺少装饰器')
    }
    //-------
    let getRow: (res: relationalStore.ResultSet) => T = (res: relationalStore.ResultSet) => {
      let obj = new param.class()
      let result: ESObject = obj
      let columnNames = res.columnNames
      for (let i = 0; i < columnNames.length; i++) {
        let e = columnNames[i]
        result[e] = res.getValue(res.getColumnIndex(e))
      }
      return result as T
    }
    let sqlUtil = new SqlUtils<T>(tableName, columnsMeta)
    return new BaseMapper(param.config, sqlUtil, getRow)
  }

  private constructor(config: relationalStore.StoreConfig, sqlUtils: SqlUtils<T>,
    getRow: (res: relationalStore.ResultSet) => T) {
    this.config = config;
    this.sqlUtils = sqlUtils;
    this.getRow = getRow;
  }

  /**
   * 获取新连接
   */
  async getConnection(): Promise<Connection> {
    return Connection.create(this.config)
  }

  /**
   * 统计行数
   * @param wrapper 查询条件
   * @returns 行数
   */
  async count(wrapper: Wrapper = new Wrapper(), db?: Connection): Promise<number> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    let myWrapper = MyWrapper.build(wrapper)
    const sql = this.sqlUtils.count(myWrapper.getWhere(),
      myWrapper.getGroup(),
      myWrapper.getOrder())
    const res: relationalStore.ResultSet = await db.execDQL(sql, myWrapper.getValue())
    res.goToFirstRow()
    let a = res.columnNames
    const count: number = res.getLong(0)
    res.close()
    if (isClose) {
      await db.close()
    }
    return count
  }

  /**
   * 查询得到对象
   * @param wrapper 查询条件
   * @returns 对象数组
   */
  async getObject(wrapper: Wrapper = new Wrapper(), db?: Connection): Promise<ESObject[]> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    let myWrapper = MyWrapper.build(wrapper)
    const sql = this.sqlUtils.list(myWrapper.getSelect(),
      myWrapper.getWhere(),
      myWrapper.getGroup(),
      myWrapper.getOrder())
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, myWrapper.getValue()
    )
    const columnNames: Array<string> = res.columnNames
    const list: ESObject[] = []
    while (res.goToNextRow()) {
      let obj: ESObject = {}
      columnNames.forEach((name) => {
        obj[name] = res.getValue(res.getColumnIndex(name))
      })
      list.push(obj)
    }
    res.close()
    if (isClose) {
      await db.close()
    }
    return list
  }

  /**
   * 传入SQL，查询得到对象
   * @param sql sql语句
   * @param params 占位符参数
   * @returns 对象数组
   */
  async getObjectBySql(sql: string, params: relationalStore.ValueType[], db?: Connection): Promise<ESObject[]> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const res: relationalStore.ResultSet = await db.execDQL(sql, params)
    const columnNames: Array<string> = res.columnNames
    const list: ESObject[] = []
    while (res.goToNextRow()) {
      let obj: ESObject = {}
      columnNames.forEach((name) => {
        obj[name] = res.getValue(res.getColumnIndex(name))
      })
      list.push(obj)
    }
    res.close()
    if (isClose) {
      await db.close()
    }
    return list
  }

  /**
   * 查询list
   * @param wrapper 查询条件
   * @returns 实体类的数组
   */
  async getList(wrapper: Wrapper = new Wrapper(), db?: Connection): Promise<T[]> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    let myWrapper = MyWrapper.build(wrapper)
    const sql = this.sqlUtils.list(myWrapper.getSelect(),
      myWrapper.getWhere(),
      myWrapper.getGroup(),
      myWrapper.getOrder())
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, myWrapper.getValue()
    )
    const list: T[] = []
    while (res.goToNextRow()) {
      let obj: T = this.getRow(res)
      list.push(obj)
    }
    res.close()
    if (isClose) {
      await db.close()
    }
    return list
  }

  /**
   * 查询第一个数据
   * @param wrapper 查询条件
   * @returns 实体类的数组
   */
  async getOne(wrapper: Wrapper = new Wrapper(), db?: Connection): Promise<T | undefined> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    let myWrapper = MyWrapper.build(wrapper)
    const sql = this.sqlUtils.getOne(myWrapper.getSelect(),
      myWrapper.getWhere(),
      myWrapper.getGroup(),
      myWrapper.getOrder())
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, myWrapper.getValue()
    )
    let one: T | undefined = undefined
    if (res.goToNextRow()) {
      one = this.getRow(res)
    }
    res.close()
    if (isClose) {
      await db.close()
    }
    return one
  }

  /**
   * 分页查询
   * @param current 页数
   * @param size 每页大小
   * @param wrapper 查询条件
   * @returns Page类
   */
  async getPage(current: number, size: number, wrapper: Wrapper = new Wrapper(), db?: Connection): Promise<Page<T>> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const count: number = await this.count(wrapper, db)
    let myWrapper = MyWrapper.build(wrapper)
    const sql = this.sqlUtils.page(myWrapper.getSelect(),
      myWrapper.getWhere(),
      myWrapper.getGroup(),
      myWrapper.getOrder(),
      current, size)
    const res: relationalStore.ResultSet = await db.execDQL(sql, myWrapper.getValue())
    const list: T[] = []
    while (res.goToNextRow()) {
      list.push(this.getRow(res))
    }
    res.close()
    if (isClose) {
      await db.close()
    }
    let page: Page<T> = new Page(count, current, size, list)
    return page
  }

  /**
   * 根据主键查询
   * @param id 主键
   * @returns 返回实体类
   */
  async getById(id: relationalStore.ValueType, db?: Connection): Promise<T | undefined> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sqlData = this.sqlUtils.getById(id)
    const res: relationalStore.ResultSet = await db.execDQL(sqlData.sql, sqlData.values)
    let entity: T | undefined = undefined
    if (res.goToFirstRow()) {
      entity = this.getRow(res)
    }
    res.close()
    if (isClose) {
      await db.close()
    }
    return entity
  }


  /**
   * 添加一行数据
   * @param obj 实体类
   * @returns 无返回值
   */
  async insert(obj: T, db?: Connection): Promise<void> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sqlData = this.sqlUtils.insert(obj)
    await db.execDML(sqlData.sql, sqlData.values)
    if (isClose) {
      await db.close()
    }
  }

  /**
   * 添加一组数据
   * @param obj 实体类
   * @returns 无返回值
   */
  async insertBatch(list: T[], db?: Connection): Promise<void> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sqlData = this.sqlUtils.insertBatch(list)
    await db.execDML(sqlData.sql, sqlData.values)
    if (isClose) {
      await db.close()
    }
  }

  /**
   * 更新，手动set更新字段
   * @param wrapper 更新条件
   * @returns 无返回值
   */
  async update(wrapper: Wrapper, db?: Connection): Promise<void> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    let myWrapper = MyWrapper.build(wrapper)
    const sql = this.sqlUtils.update(myWrapper.getUpdate(), myWrapper.getWhere())
    await db.execDML(sql, [...myWrapper.getUpdateValue(), ...myWrapper.getValue()])
    if (isClose) {
      await db.close()
    }
  }

  /**
   * 根据主键更新
   * @param obj 实体类，id不可以为空
   * @returns 无返回值
   */
  async updateById(obj: T, db?: Connection): Promise<void> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sqlData = this.sqlUtils.updateById(obj)
    await db.execDML(sqlData.sql, sqlData.values)
    if (isClose) {
      await db.close()
    }
  }

  /**
   * 条件删除
   * @param wrapper 删除条件
   * @returns 无返回值
   */
  async delete(wrapper: Wrapper, db?: Connection): Promise<void> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    let myWrapper = MyWrapper.build(wrapper)
    const sql = this.sqlUtils.delete(myWrapper.getWhere())
    await db.execDML(sql, myWrapper.getValue())
    if (isClose) {
      await db.close()
    }
  }

  /**
   * 根据主键删除
   * @param id 主键
   * @returns 无返回值
   */
  async deleteById(id: relationalStore.ValueType, db?: Connection): Promise<void> {
    let isClose: boolean = true
    if (db === undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sqlData = this.sqlUtils.deleteById(id)
    await db.execDML(sqlData.sql, sqlData.values)
    if (isClose) {
      await db.close()
    }
  }
}

