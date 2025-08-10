import relationalStore from '@ohos.data.relationalStore'
import { util } from '@kit.ArkTS'
import { Logger } from '../log/Logger'

/**
 * 数据库工具
 */
export class Connection {
  private id: string
  private store: relationalStore.RdbStore
  private static context?: Context = undefined
  private static logger?: Logger = undefined

  set version(v: number) {
    this.store.version = v
  }

  get version() {
    return this.store.version
  }

  getStore() {
    return this.store
  }

  /**
   * 删除数据库
   */
  static async deleteRdbStore(dbName: string): Promise<void> {
    if (Connection.context === undefined) {
      Connection.logger?.error('Connection未初始化，context获取失败')
      return
    }
    relationalStore.deleteRdbStore(Connection.context, dbName)
    Connection.logger?.info('deleteRdbStore success')
  }

  /**
   * 初始化
   */
  static init(context?: Context, logger?: Logger): void {
    if (context === undefined) {
      Connection.logger?.error('Connection初始化失败，参数异常')
      return
    }
    Connection.context = context
    Connection.logger = logger
  }

  constructor(id: string, store: relationalStore.RdbStore) {
    this.id = id
    this.store = store
  }

  /**
   * 创建新连接
   */
  static async create(config: relationalStore.StoreConfig): Promise<Connection> {
    return new Promise((resolve, reject) => {
      relationalStore.getRdbStore(Connection.context, config)
        .then(store => {
          const db = new Connection(util.generateRandomUUID(), store)
          Connection.logger?.info(`connection create ${db.id}`)
          resolve(db)
        })
        .catch(() => {
          reject()
        })
    })
  }

  /**
   * 执行：插入修改删除
   */
  async execDML(sql: string, params: Array<relationalStore.ValueType> = []): Promise<void> {
    try {
      Connection.logger?.info('execDML:', sql, JSON.stringify(params))
      await this.store.executeSql(sql, params)
    } catch (e) {
      Connection.logger?.error('execDML', e.message, e.code, JSON.stringify(e))
      throw new Error('execDML 执行失败')
    }
  }

  /**
   * 执行：查询
   */
  async execDQL(sql: string, params: Array<relationalStore.ValueType> = []): Promise<relationalStore.ResultSet> {
    try {
      Connection.logger?.info('execDQL:', sql, JSON.stringify(params))
      const res: relationalStore.ResultSet = await this.store.querySql(sql, params)
      return res
    } catch (e) {
      Connection.logger?.error('execDQL', e.message, e.code, JSON.stringify(e))
      throw new Error('execDQL 执行失败')
    }
  }

  /**
   * 开启事务
   */
  beginTransaction(): void {
    Connection.logger?.info('transaction begin ', this.id)
    this.store.beginTransaction()
  }

  /**
   * 提交事务
   */
  commit(): void {
    Connection.logger?.info('transaction commit ', this.id)
    this.store.commit()
  }

  /**
   * 回滚事务
   */
  rollBack(): void {
    Connection.logger?.info('transaction rollBack ', this.id)
    this.store.rollBack()
  }

  /**
   * 关闭连接
   */
  async close(): Promise<void> {
    Connection.logger?.info('connection close ', this.id)
    this.store.close()
  }

  /**
   * 备份，默认在RdbStore同路径下备份。也可指定路径：customDir + "backup.db"
   */
  async backup(fileName: string = 'Backup.db'): Promise<void> {
    this.store.backup(fileName)
    Connection.logger?.info('backup success')
  }

  /**
   * 恢复备份
   */
  async restore(fileName: string = 'Backup.db'): Promise<void> {
    this.store.restore(fileName)
    Connection.logger?.info('restore success')
  }
}

