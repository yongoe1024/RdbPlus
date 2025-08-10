import { relationalStore } from "@kit.ArkData"

export interface BuildParams<T> {
  class: new () => T,
  config: relationalStore.StoreConfig
}

