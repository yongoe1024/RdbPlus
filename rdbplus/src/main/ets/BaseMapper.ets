import { relationalStore, ValueType } from "@kit.ArkData";
import { SQLUtils } from "./utils/SQLUtils";
import { Connection } from "./utils/Connection";
import { Wapper } from "./Wapper";
import { Page } from "./Page";

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
   * @param wapper 查询条件
   * @returns 行数
   */
  async count(wapper: Wapper, db?: Connection): Promise<number> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sql = this.sqlUtils.count(wapper.getWhere(), wapper.getGroup(), wapper.getOrder())
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, wapper.getWhereValue()
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
   * 查询得到Map
   * @param wapper 查询条件
   * @returns Map
   */
  async selectByMap(wapper: Wapper, db?: Connection): Promise<Map<string, relationalStore.ValueType>[]> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sql = this.sqlUtils.list(wapper.getSelect(), wapper.getWhere(), wapper.getGroup(), wapper.getOrder())
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, wapper.getWhereValue()
    )
    const columnNames: Array<string> = res.columnNames
    const list: Map<string, relationalStore.ValueType>[] = []
    while (res.goToNextRow()) {
      const map: Map<string, relationalStore.ValueType> = new Map()
      columnNames.forEach((name) => {
        map.set(name, res.getValue(res.getColumnIndex(name)))
      })
      list.push(map)
    }
    res.close()
    if (isClose) {
      await db.close()
    }
    return list
  }

  /**
   * 查询list
   * @param wapper 查询条件
   * @returns 实体类的数组
   */
  async list(wapper: Wapper, db?: Connection): Promise<T[]> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sql = this.sqlUtils.list(wapper.getSelect(), wapper.getWhere(), wapper.getGroup(), wapper.getOrder())
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, wapper.getWhereValue()
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
   * @param wapper 查询条件
   * @returns Page类
   */
  async page(current: number, size: number, wapper: Wapper, db?: Connection): Promise<Page<T>> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const count: number = await this.count(wapper, db)
    const sql =
      this.sqlUtils.page(wapper.getSelect(), wapper.getWhere(), wapper.getGroup(), wapper.getOrder(), current, size)
    const res: relationalStore.ResultSet = await db.execDQL(
      sql, wapper.getWhereValue()
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
   * @param wapper 更新条件
   * @returns 无返回值
   */
  async update(wapper: Wapper, db?: Connection): Promise<void> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sql = this.sqlUtils.update(wapper.getUpdate(), wapper.getWhere())
    await db.execDML(
      sql, [...wapper.getUpdateValue(), ...wapper.getWhereValue()]
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
   * @param wapper 删除条件
   * @returns 无返回值
   */
  async delete(wapper: Wapper, db?: Connection): Promise<void> {
    let isClose: boolean = true
    if (db == undefined) {
      db = await this.getConnection()
    } else {
      isClose = false
    }
    const sql = this.sqlUtils.delete(wapper.getWhere())
    await db.execDML(
      sql, wapper.getWhereValue()
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

