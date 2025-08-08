import relationalStore from '@ohos.data.relationalStore'
import { util } from '@kit.ArkTS'
import { Logger } from '../log/Logger'

/**
 * 数据库工具
 */
export class Connection {
  id: string
  private store?: relationalStore.RdbStore
  static context?: Context = undefined
  static logger?: Logger = undefined

  /**
   * 初始化
   */
  static init(context?: Context, logger?: Logger) {
    if (context === undefined) {
      console.error('rdb初始化失败，context为空')
      return
    }
    Connection.context = context
    Connection.logger = logger
  }

  private constructor() {
    this.id = util.generateRandomUUID()
  }

  /**
   * 创建新连接
   */
  static async create(config: relationalStore.StoreConfig): Promise<Connection> {
    if (Connection.context === undefined) {
      Connection.logger?.error('rdb创建连接失败，context为空')
      throw new Error('rdb创建连接失败，context为空')
    }
    const db = new Connection()
    db.store = await relationalStore.getRdbStore(Connection.context, config)
    Connection.logger?.info('connection create ', db.id)
    return db
  }

  /**
   * 执行：插入修改删除
   */
  async execDML(sql: string, params: Array<relationalStore.ValueType> = []): Promise<void> {
    try {
      Connection.logger?.info('DML:', sql, JSON.stringify(params))
      await this.store!.executeSql(sql, params)
    } catch (e) {
      Connection.logger?.error('DML语句错误', e.message, e.code, JSON.stringify(e))
      throw new Error('DML语句错误')
    }
  }

  /**
   * 执行：查询
   */
  async execDQL(sql: string, params: Array<relationalStore.ValueType> = []): Promise<relationalStore.ResultSet> {
    try {
      Connection.logger?.info('DQL:', sql, JSON.stringify(params))
      const res: relationalStore.ResultSet = await this.store!.querySql(sql, params)
      return res
    } catch (e) {
      Connection.logger?.error('DQL语句错误', e.message, e.code, JSON.stringify(e))
      throw new Error('DQL语句错误')
    }
  }

  /**
   * 开启事务
   */
  beginTransaction() {
    Connection.logger?.info('transaction begin ', this.id)
    this.store!.beginTransaction()
  }

  /**
   * 提交事务
   */
  commit() {
    Connection.logger?.info('transaction commit ', this.id)
    this.store!.commit()
  }

  /**
   * 回滚事务
   */
  rollBack() {
    Connection.logger?.info('transaction rollBack ', this.id)
    this.store!.rollBack()
  }

  /**
   * 关闭连接
   */
  async close() {
    Connection.logger?.info('connection close ', this.id)
    await this.store!.close()
  }
}

