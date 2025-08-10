import { relationalStore } from '@kit.ArkData'
import { BaseMapper } from 'rdbplus'
import { Employee } from './Employee'

/**
 * 多数据源示例
 */
export class MapperMultiple {
  private static mapper1: BaseMapper<Employee>
  private static mapper2: BaseMapper<Employee>

  // 单例模式 db1
  static getInstance1DB() {
    if (!MapperMultiple.mapper1) {
      MapperMultiple.mapper1 = BaseMapper.build<Employee>({
        class: Employee,
        config: {
          name: 'RdbTest1.db', // 数据库文件名
          securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
        }
      })
    }
    return MapperMultiple.mapper1
  }

  // 单例模式 db2
  static getInstance2DB() {
    if (!MapperMultiple.mapper2) {
      MapperMultiple.mapper2 = BaseMapper.build<Employee>({
        class: Employee,
        config: {
          name: 'RdbTest2.db', // 数据库文件名
          securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
        }
      })
    }
    return MapperMultiple.mapper2
  }
}