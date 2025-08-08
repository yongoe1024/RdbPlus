import { relationalStore } from "@kit.ArkData"

export interface SqlData {
  sql: string
  values: relationalStore.ValueType[]
}