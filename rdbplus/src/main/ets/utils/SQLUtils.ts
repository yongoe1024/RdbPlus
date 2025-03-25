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
    let sql = `select * from ${this.tableName} where ${this.primaryKey} = ?;`
    return {
      sql: sql,
      values: [id]
    } as MapperData
  }

  insert(obj: T) {
    let fields: string[] = []
    let values: any[] = []
    Object.entries(obj).forEach(([k, v]) => {
      if (v == undefined) {
        fields.push(k)
        values.push(null)
        return
      }
      fields.push(k)
      values.push(v)
    })
    let sql = `INSERT INTO ${this.tableName} (${fields.toString()}) VALUES (${fields.fill('?')});`
    return {
      sql: sql,
      values: values
    } as MapperData
  }

  insertNative(obj: T) {
    /**
     * // 以下三种方式可用  要将obj转换为以下三种方式之一
     {
     'NAME': value6,
     'AGE': value7,
     'SALARY': value8,
     'CODES': value9,
     'IDENTITY': value10,
     };
     {
     NAME: value6,
     AGE: value7,
     SALARY: value8,
     CODES: value9,
     IDENTITY: value10,
     };
     {
     "NAME": value6,
     "AGE": value7,
     "SALARY": value8,
     "CODES": value9,
     "IDENTITY": value10,
     };
     */
    let valuesBucket = {}
    Object.entries(obj).forEach(([k, v]) => {
      valuesBucket[k] = v
    })
    return {
      tableName: this.tableName,
      valuesBucket: valuesBucket
    } as NativeSqlData
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
      if (v == undefined) {
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

export interface NativeSqlData {
  tableName: string
  valuesBucket: any
}