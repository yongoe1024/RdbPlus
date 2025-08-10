import { relationalStore } from "@kit.ArkData"

export interface BuildParams<T> {
  // 类型
  class: new () => T,
  config: relationalStore.StoreConfig
}

