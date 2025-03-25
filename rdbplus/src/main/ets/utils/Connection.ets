import relationalStore from '@ohos.data.relationalStore'
import { util } from '@kit.ArkTS'

/**
 * 数据库工具
 */
export class Connection {
  id: string
  private store: relationalStore.RdbStore | undefined = undefined

  private constructor() {
    this.id = util.generateRandomUUID()
  }

  static async init(config: relationalStore.StoreConfig) {
    const db = new Connection()
    db.store = await relationalStore.getRdbStore(getContext(), config)
    console.info('connection create ', db.id)
    return db
  }

  /**
   * 执行：插入修改删除
   */
  async execDML(sql: string, params: Array<relationalStore.ValueType> = []): Promise<void> {
    try {
      console.info('DML:', sql, JSON.stringify(params))
      await this.store!.executeSql(sql, params)
    } catch (e) {
      console.error('DML语句错误', e.message, e.code, JSON.stringify(e))
      throw new Error('DML语句错误')
    }
  }

  /**
   * 执行：查询
   */
  async execDQL(sql: string, params: Array<relationalStore.ValueType> = []): Promise<relationalStore.ResultSet> {
    try {
      console.info('DQL:', sql, JSON.stringify(params))
      const res: relationalStore.ResultSet = await this.store!.querySql(sql, params)
      return res
    } catch (e) {
      console.error('DQL语句错误', e.message, e.code, JSON.stringify(e))
      throw new Error('DQL语句错误')
    }
  }

  /**
   * 执行：调用原生的insert方法
   * @param tableName 表名
   * @param data 数据
   * @returns 插入的行id 失败返回-1
   */
  async insertNative(tableName: string, data: relationalStore.ValuesBucket): Promise<number> {
    try {
      console.info('insert:', tableName, JSON.stringify(data))
      return await this.store!.insert(tableName, data)
    } catch (e) {
      console.error('insert错误', e.message, e.code, JSON.stringify(e))
      throw new Error('insert错误')
    }
  }

  beginTransaction() {
    console.info('transaction begin ', this.id)
    this.store!.beginTransaction()
  }

  commit() {
    console.info('transaction commit ', this.id)
    this.store!.commit()
  }

  rollBack() {
    console.info('transaction rollBack ', this.id)
    this.store!.rollBack()
  }

  async close() {
    console.info('connection close ', this.id)
    await this.store!.close()
  }
}

