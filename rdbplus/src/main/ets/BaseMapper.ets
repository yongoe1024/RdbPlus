import { relationalStore, ValueType } from "@kit.ArkData";
import { SQLUtils } from "./utils/SQLUtils";
import { Connection } from "./utils/Connection";
import { Wrapper } from "./Wrapper";
import { Page } from "./Page";
import { AnyObject } from "./AnyObject";

export class BaseMapper<T> {
  private config: relationalStore.StoreConfig
  private sqlUtils: SQLUtils<T>
  private getRow: (res: relationalStore.ResultSet) => T

  constructor(param: MapperParam, getRow: (res: relationalStore.ResultSet) => T, config: relationalStore.StoreConfig = {
    name: 'demo.db',
    securityLevel: relationalStore.SecurityLevel.S1  //安全级别
  }) {
    this.sqlUtils = new SQLUtils(param.tableName, param.primaryKey)
    this.getRow = getRow
    this.config = config
  }

  /**
   * 获取新连接
   */
  async getConnection() {
    return await Connection.init(this.config)
  }

  /**
   * 统计行数
   * @param wrapper 查询条件
   * @returns 行数
   */
  async count(wrapper: Wrapper, db?: Connection): Promise<number> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sql = this.sqlUtils.count(wrapper.getWhere(), wrapper.getGroup(), wrapper.getOrder())
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, wrapper.getWhereValue()
    )
    res.goToFirstRow()
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
  async getObject(wrapper: Wrapper, db?: Connection): Promise<AnyObject[]> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sql = this.sqlUtils.list(wrapper.getSelect(), wrapper.getWhere(), wrapper.getGroup(), wrapper.getOrder())
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, wrapper.getWhereValue()
    )
    const columnNames: Array<string> = res.columnNames
    const list: AnyObject[] = []
    while (res.goToNextRow()) {
      let obj: AnyObject = {}
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
  async getObjectBySql(sql: string, params: relationalStore.ValueType[], db?: Connection): Promise<AnyObject[]> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, params
    )
    const columnNames: Array<string> = res.columnNames
    const list: AnyObject[] = []
    while (res.goToNextRow()) {
      let obj: AnyObject = {}
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
  async getList(wrapper: Wrapper, db?: Connection): Promise<T[]> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sql = this.sqlUtils.list(wrapper.getSelect(), wrapper.getWhere(), wrapper.getGroup(), wrapper.getOrder())
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, wrapper.getWhereValue()
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
   * 分页查询
   * @param current 页数
   * @param size 每页大小
   * @param wrapper 查询条件
   * @returns Page类
   */
  async getPage(current: number, size: number, wrapper: Wrapper, db?: Connection): Promise<Page<T>> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const count: number = await this.count(wrapper, db)
    const sql =
      this.sqlUtils.page(wrapper.getSelect(), wrapper.getWhere(), wrapper.getGroup(), wrapper.getOrder(), current, size)
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, wrapper.getWhereValue()
    )
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
  async getById(id: ValueType, db?: Connection): Promise<T | undefined> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const mapperData = this.sqlUtils.getById(id)
    const res: relationalStore.ResultSet = await db.execDQL(
      mapperData.sql, mapperData.values
    )
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
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const mapperData = this.sqlUtils.insert(obj)
    await db.execDML(
      mapperData.sql, mapperData.values
    )
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
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sql = this.sqlUtils.update(wrapper.getUpdate(), wrapper.getWhere())
    await db.execDML(
      sql, [...wrapper.getUpdateValue(), ...wrapper.getWhereValue()]
    )
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
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const mapperData = this.sqlUtils.updateById(obj)
    await db.execDML(
      mapperData.sql, mapperData.values
    )
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
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sql = this.sqlUtils.delete(wrapper.getWhere())
    await db.execDML(
      sql, wrapper.getWhereValue()
    )
    if (isClose) {
      await db.close()
    }
  }

  /**
   * 根据主键删除
   * @param id 主键
   * @returns 无返回值
   */
  async deleteById(id: ValueType, db?: Connection): Promise<void> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const mapperData = this.sqlUtils.deleteById(id)
    await db.execDML(
      mapperData.sql, mapperData.values
    )
    if (isClose) {
      await db.close()
    }
  }
}

export interface MapperParam {
  tableName: string
  primaryKey: string
}

