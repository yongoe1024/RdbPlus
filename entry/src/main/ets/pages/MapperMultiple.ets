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
        dbName: 'db1',
        securityLevel: relationalStore.SecurityLevel.S1
      })
    }
    return MapperMultiple.mapper1
  }

  // 单例模式 db2
  static getInstance2DB() {
    if (!MapperMultiple.mapper2) {
      MapperMultiple.mapper2 = BaseMapper.build<Employee>({
        class: Employee,
        dbName: 'db2',
        securityLevel: relationalStore.SecurityLevel.S1
      })
    }
    return MapperMultiple.mapper2
  }
}