import { relationalStore } from '@kit.ArkData'
import { BaseMapper, Connection } from 'rdbplus'
import { Employee } from './Employee'

export class EmpMapper {
  private static mapper: BaseMapper<Employee>

  // 单例模式
  static getInstance() {
    if (!EmpMapper.mapper) {
      EmpMapper.mapper = BaseMapper.build<Employee>({
        class: Employee,
        config: {
          name: 'RdbTest.db', // 数据库文件名
          securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
        }
      })
    }
    return EmpMapper.mapper
  }

  /**
   * 创建表
   * 修改表结构需要控制版本
   * 修改后数据库版本增加，且无法降低版本
   */
  static async createTable() {
    let db: Connection | undefined = undefined
    try {
      db = await EmpMapper.getInstance().getConnection()
      console.log('createTable 首次打开 版本 0');
      // 初始默认 0
      if (db.version === 0) {
        await db.execDML(
          `create table if not exists "t_emp" (
              id integer primary key autoincrement,
              name varchar(20)
          )`, [])
        db.version = 1
        console.log('createTable 创建表后 版本 1')
      }
      if (db.version === 1) {
        // 添加字段
        db.execDML('ALTER TABLE t_emp ADD COLUMN  age integer');
        db.version = 2;
        console.log('createTable 修改后 版本 2')
      }
      if (db.version === 2) {
        // 以此类推
        console.log('createTable 最终版本 2')
      }
    } catch (e) {
      console.error(e)
    } finally {
      db?.close()
    }
  }
}