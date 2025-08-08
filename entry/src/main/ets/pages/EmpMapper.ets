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
        dbName: 'ass',
        securityLevel: relationalStore.SecurityLevel.S1
      })
    }
    return EmpMapper.mapper
  }

  /**
   * 创建表
   */
  static async createTable() {
    try {
      const db = await EmpMapper.getInstance().getConnection()
      await db.execDML(`DROP TABLE IF EXISTS t_emp  ;`, [])
      await db.execDML(
        `create table if not exists "t_emp" (
          id integer primary key autoincrement,
          name varchar(20),
          age integer
      )`, [])
      await db.close()
    } catch (e) {
      console.error(e)
    }
  }
}