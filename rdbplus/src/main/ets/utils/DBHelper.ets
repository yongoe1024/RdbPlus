import relationalStore from '@ohos.data.relationalStore'

/**
 * 数据库工具
 */
export class DBHelper {
  private config: relationalStore.StoreConfig

  constructor(config: relationalStore.StoreConfig = {
    name: 'demo.db',
    securityLevel: relationalStore.SecurityLevel.S1  //安全级别
  }) {
    this.config = config
  }


  private async getStore() {
    return await relationalStore.getRdbStore(getContext(this), this.config)
  }

  /**
   * 执行：插入修改删除
   */
  async execDML(sql: string, params: Array<relationalStore.ValueType> = []): Promise<boolean> {
    let store: relationalStore.RdbStore | undefined
    try {
      console.info('DML:', sql, JSON.stringify(params))
      store = await this.getStore()
      await store.executeSql(sql, params)
      await store.close()
      return true
    } catch (e) {
      console.error('DML语句错误', e.message, e.code, JSON.stringify(e))
      if (store) {
        await store.close()
      }
      return false
    }
  }

  /**
   * 执行：查询
   */
  async execDQL(sql: string, params: Array<relationalStore.ValueType> = []): Promise<relationalStore.ResultSet> {
    let store: relationalStore.RdbStore | undefined
    try {
      console.info('DQL:', sql, JSON.stringify(params))
      store = await this.getStore()
      const res: relationalStore.ResultSet = await store.querySql(sql, params)
      await store.close()
      return res
    } catch (e) {
      console.error('DQL语句错误', e.message, e.code, JSON.stringify(e))
      if (store) {
        await store.close()
      }
      throw new Error('DQL语句错误')
    }
  }
}

