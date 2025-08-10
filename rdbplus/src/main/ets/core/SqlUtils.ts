import { TableFieldParams } from "../model/TableFieldParams"
import { FieldType } from "../model/FieldType"
import { relationalStore } from "@kit.ArkData"
import { SqlData } from "../model/SqlData"

export class SqlUtils<T> {
  // 字段信息
  columns: TableFieldParams[]
  // 表名
  tableName: string
  // 主键名
  idName: string
  // 类属性名数组
  propertyKeys: string[]
  // 字段名数组
  fields: string[]
  // 字段 逗号分隔字符串
  fieldsTemp: string
  // 相对字段参数 问号，逗号分隔字符串
  valueTemp: string

  constructor(tableName: string, columns: TableFieldParams[]) {
    this.columns = columns
    this.tableName = tableName
    this.fields = []
    this.propertyKeys = []
    for (let index = 0; index < columns.length; index++) {
      if (columns[index].isPrimaryKey) {
        this.idName = columns[index].name
      }
      this.fields.push(columns[index].name)
      this.propertyKeys.push(columns[index].propertyKey)
    }
    this.fieldsTemp = this.fields.join(',')
    this.valueTemp = new Array(this.fields.length).fill('?').join(',')
  }

  list(selectSql: string, whereSql: string, groupSql: string, orderSql: string) {
    let sql = `select ${selectSql} from ${this.tableName} where ${whereSql} ${groupSql} ${orderSql} ;`
    return sql
  }

  getOne(selectSql: string, whereSql: string, groupSql: string, orderSql: string) {
    let sql = `select ${selectSql} from ${this.tableName} where ${whereSql} ${groupSql} ${orderSql} limit 1 ;`
    return sql
  }

  count(whereSql: string, groupSql: string, orderSql: string) {
    let sql = `select count(*) from ${this.tableName} where ${whereSql} ${groupSql} ${orderSql};`
    return sql
  }

  page(selectSql: string, whereSql: string, groupSql: string, orderSql: string, current: number,
    size: number,) {
    let sql =
      `select ${selectSql} from ${this.tableName} where ${whereSql} ${groupSql} ${orderSql} limit ${(current - 1) *
        size},${size};`
    return sql
  }

  getById(id: relationalStore.ValueType) {
    let sql = `select * from ${this.tableName} where ${this.idName} = ?;`
    return {
      sql: sql,
      values: [id]
    } as SqlData
  }

  insert(obj: T) {
    // 取出数据库字段
    let values: relationalStore.ValueType[] = []
    for (let propertyKey of this.propertyKeys){
      let v = obj[propertyKey]
      if (v !== undefined) {
        values.push(v)
      } else {
        values.push(null)
      }
    }
    let sql = `INSERT INTO ${this.tableName} (${this.fieldsTemp}) VALUES (${this.valueTemp});`
    return {
      sql: sql,
      values: values
    } as SqlData
  }

  insertBatch(list: T[]) {
    // 取出数据库字段
    let values: relationalStore.ValueType[] = []
    for (let item of list) {
      for (let propertyKey of this.propertyKeys) {
        let v = item[propertyKey]
        if (v !== undefined) {
          values.push(v)
        } else {
          values.push(null)
        }
      }
    }
    let insertSql = `(${this.valueTemp})`
    let insertBatchSql = new Array(list.length).fill(insertSql).join(',')
    let sql = `INSERT INTO ${this.tableName} (${this.fieldsTemp}) VALUES ${insertBatchSql};`
    return {
      sql: sql,
      values: values
    } as SqlData
  }

  updateById(obj: T) {
    let keyValue: relationalStore.ValueType = obj[this.idName]
    // 取出数据库字段
    let values: relationalStore.ValueType[] = []
    let setSql: string[] = []
    for (let i = 0; i < this.propertyKeys.length; i++) {
      let v = obj[this.propertyKeys[i]]
      // 不更新 undefined，更新null
      if (v !== undefined) {
        setSql.push(`${this.fields[i]}=?`)
        values.push(v)
      }
    }
    //补全id的值
    values.push(keyValue)
    let sql = `update ${this.tableName} set ${setSql.join(',')} where ${this.idName} = ?;`
    return {
      sql: sql,
      values: values
    } as SqlData
  }

  deleteById(id: relationalStore.ValueType) {
    let sql = `delete from ${this.tableName} where ${this.idName} = ?;`
    return {
      sql: sql,
      values: [id]
    } as SqlData
  }

  update(setSql: string, whereSql: string) {
    let sql = `update ${this.tableName} set ${setSql} where ${whereSql};`
    return sql
  }

  delete(whereSql: string) {
    let sql = `delete from ${this.tableName} where ${whereSql};`
    return sql
  }
}