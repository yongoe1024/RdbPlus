import { relationalStore } from "@kit.ArkData"

export interface BuildParams<T> {
  // 类型
  class: new () => T,

  // 数据库名
  dbName: string
  // 安全级别
  securityLevel: relationalStore.SecurityLevel
}

