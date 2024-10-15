/**
 * SQl语句生成工具
 */
export class SQLUtils<T> {
  private tableName: string = ''
  private primaryKey: string = ''

  constructor(tableName: string, primaryKey: string) {
    this.tableName = tableName
    this.primaryKey = primaryKey
  }

  list(selectSql: string = '*', whereSql: string, groupSql: string = '', orderSql: string = '') {
    let sql = `select ${selectSql} from ${this.tableName} where ${whereSql} ${groupSql} ${orderSql};`
    return sql
  }

  count(whereSql: string, groupSql: string = '', orderSql: string = '') {
    let sql = `select count(*) as count from ${this.tableName} where ${whereSql} ${groupSql} ${orderSql};`
    return sql
  }

  page(selectSql: string = '*', whereSql: string, groupSql: string = '', orderSql: string = '', current: number,
    size: number,) {
    let sql =
      `select ${selectSql} from ${this.tableName} where ${whereSql} ${groupSql} ${orderSql} limit ${(current - 1) *
        size},${size};`
    return sql
  }


  getById(id: any) {
    let sql = `select * from ${this.tableName} where ${this.primaryKey};`
    return {
      sql: sql,
      values: [id]
    } as MapperData
  }

  add(obj: T) {
    let fields: string[] = []
    let values: any[] = []
    Object.entries(obj).forEach(([k, v]) => {
      fields.push(k)
      values.push(v)
    })
    let sql = `INSERT INTO ${this.tableName} (${fields.toString()}) VALUES (${fields.fill('?')});`
    return {
      sql: sql,
      values: values
    } as MapperData
  }

  updateById(obj: T) {
    let idValue: any
    let fields: string[] = []
    let values: any[] = []
    Object.entries(obj).forEach(([k, v]) => {
      if (k == this.primaryKey) {
        idValue = v
        return
      }
      fields.push(k)
      values.push(v)
    })
    //补全id的值
    values.push(idValue)
    let param = ''
    for (let i = 0; i < fields.length; i++) {
      if (i == fields.length - 1) {
        param += `${fields[i]}=?`
      } else {
        param += `${fields[i]}=?,`
      }
    }
    let sql = `update ${this.tableName} set ${param} where ${this.primaryKey} = ?;`
    return {
      sql: sql,
      values: values
    } as MapperData
  }

  update(setSql: string, whereSql: string) {
    let sql = `update ${this.tableName} set ${setSql} where ${whereSql};`
    return sql
  }

  deleteById(id: any) {
    let sql = `delete from ${this.tableName} where ${this.primaryKey}=?;`
    return {
      sql: sql,
      values: [id]
    } as MapperData
  }

  delete(whereSql: string) {
    let sql = `delete from ${this.tableName} where ${whereSql};`
    return sql
  }
}

export interface MapperData {
  sql: string
  values: any[]
}

export class Page<T> {
  total: number = 0
  current: number = 1
  size: number = 10
  record: T[] = []

  constructor(total: number, current: number, size: number, record: T[]) {
    this.total = total
    this.current = current
    this.size = size
    this.record = record
  }
}
