type ValueType = null | number | string | boolean | Uint8Array | Float32Array | bigint;

/**
 * 构造查询参数
 */
export class Wapper {
  private selectSql: string | undefined = undefined
  private groupSql: string | undefined = undefined
  private havingSql: string | undefined = undefined
  private orderList: string[] = []
  private whereList: string[] = []
  private valueList: ValueType[] = []
  private updateList: string[] = []
  private updateValueList: ValueType[] = []

  /**
   * update set 修改某字段
   * @param field 字段
   * @param value 值
   * @returns Wapper
   */
  set(field: string, value: ValueType) {
    this.updateList.push(`${field} = ?`)
    this.updateValueList.push(value)
    return this
  }

  /**
   * 等于
   * @param field 字段
   * @param value 值
   * @returns Wapper
   */
  eq(field: string, value: ValueType): Wapper {
    this.whereList.push(`and ${field} = ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 不等于
   * @param field 字段
   * @param value 值
   * @returns Wapper
   */
  notEq(field: string, value: ValueType): Wapper {
    this.whereList.push(`and ${field} != ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 字段的值，在给定的集合中
   * @param field 字段
   * @param value 值的数组
   * @returns Wapper
   */
  in(field: string, value: ValueType[]): Wapper {
    const str = new Array(value.length).fill('?').join(',')
    this.whereList.push(`and ${field} in (${str})`)
    Array.prototype.push.apply(this.valueList, value);
    return this
  }

  /**
   * 字段的值，不在给定的集合中
   * @param field 字段
   * @param value 值的数组
   * @returns Wapper
   */
  notIn(field: string, value: ValueType[]): Wapper {
    const str = new Array(value.length).fill('?').join(',')
    this.whereList.push(`and ${field} not in (${str})`)
    Array.prototype.push.apply(this.valueList, value);
    return this
  }

  /**
   * 小于
   * @param field 字段
   * @param value 值
   * @returns Wapper
   */
  lt(field: string, value: ValueType): Wapper {
    this.whereList.push(`and ${field} < ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 小于等于
   * @param field 字段
   * @param value 值
   * @returns Wapper
   */
  lte(field: string, value: ValueType): Wapper {
    this.whereList.push(`and ${field} <= ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 大于
   * @param field 字段
   * @param value 值
   * @returns Wapper
   */
  gt(field: string, value: ValueType): Wapper {
    this.whereList.push(`and ${field} > ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 大于等于
   * @param field 字段
   * @param value 值
   * @returns Wapper
   */
  gte(field: string, value: ValueType): Wapper {
    this.whereList.push(`and ${field} >= ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 设置单个字段的 BETWEEN 条件
   * @param field 字段
   * @param start 起始值
   * @param end 结束值
   * @returns Wapper
   */
  between(field: string, start: ValueType, end: ValueType): Wapper {
    this.whereList.push(`and ${field} between ? and ?`)
    this.valueList.push(start)
    this.valueList.push(end)
    return this
  }

  /**
   * 设置单个字段的 NOT BETWEEN 条件
   * @param field 字段
   * @param start 起始值
   * @param end 结束值
   * @returns Wapper
   */
  notBetween(field: string, start: ValueType, end: ValueType): Wapper {
    this.whereList.push(`and ${field} not between ? and ?`)
    this.valueList.push(start)
    this.valueList.push(end)
    return this
  }

  /**
   * 单个字段的模糊匹配条件
   * @param field 字段
   * @param value 值
   * @returns Wapper
   */
  like(field: string, value: ValueType): Wapper {
    this.whereList.push(`and ${field} like ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 单个字段的非模糊匹配条件
   * @param field 字段
   * @param value 值
   * @returns Wapper
   */
  notLike(field: string, value: ValueType): Wapper {
    this.whereList.push(`and ${field} not like ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 单个字段为null
   * @param field 字段
   * @returns Wapper
   */
  isNull(field: string): Wapper {
    this.whereList.push(`and ${field} is null`)
    return this
  }

  /**
   * 单个字段不为null
   * @param field 字段
   * @returns Wapper
   */
  isNotNull(field: string): Wapper {
    this.whereList.push(`and ${field} is not null`)
    return this
  }

  /**
   * 对某字段排序-升序。可以调用多次，按顺序拼接SQL
   * @param field 字段
   * @returns Wapper
   */
  orderByAsc(field: string): Wapper {
    this.orderList.push(`${field} asc`)
    return this
  }

  /**
   * 对某字段排序-降序。可以调用多次，按顺序拼接SQL
   * @param field 字段
   * @returns Wapper
   */
  orderByDesc(field: string): Wapper {
    this.orderList.push(`${field} desc`)
    return this
  }

  /**
   * 分组查询
   * @param fields 可以传多个字段
   * @returns Wapper
   */
  groupBy(...fields: string[]): Wapper {
    const column = fields.join(',')
    this.groupSql = `group by ${column}`
    return this
  }

  /**
   * 过滤分组后的结果
   * @param sql having后面的sql条件
   * @returns Wapper
   */
  having(sql: string): Wapper {
    this.havingSql = `having ${sql}`
    return this
  }

  /**
   * 在查询条件中添加 OR 逻辑，传入的wapper仅用来拼接where条件
   * @param wapper 一个新的Wapper
   * @returns Wapper
   */
  or(wapper: Wapper): Wapper {
    this.whereList.push('or (1=1 ')
    Array.prototype.push.apply(this.whereList, wapper.whereList);
    this.whereList.push(')')
    Array.prototype.push.apply(this.valueList, wapper.valueList);
    return this
  }

  /**
   * 在查询条件中添加 and 逻辑，传入的wapper仅用来拼接where条件
   * @param wapper 一个新的Wapper
   * @returns Wapper
   */
  and(wapper: Wapper): Wapper {
    this.whereList.push('and (1=1 ')
    Array.prototype.push.apply(this.whereList, wapper.whereList);
    this.whereList.push(')')
    Array.prototype.push.apply(this.valueList, wapper.valueList);
    return this
  }

  /**
   * 仅查询指定字段的数据
   * @param sql sql语句
   * @returns Wapper
   */
  select(sql: string): Wapper {
    this.selectSql = sql
    return this
  }

  /**
   * 不对外使用
   */
  getSelect(): string | undefined {
    return this.selectSql
  }

  /**
   * 不对外使用
   */
  getWhere(): string {
    let sql = '1=1 ' + this.whereList.join(" ")
    return sql
  }

  /**
   * 不对外使用
   */
  getWhereValue(): ValueType[] {
    return this.valueList
  }

  /**
   * 不对外使用
   */
  getOrder(): string | undefined {
    if (this.orderList.length == 0) {
      return undefined
    } else {
      return 'order by ' + this.orderList.join(',')
    }
  }

  /**
   * 不对外使用
   */
  getGroup(): string | undefined {
    if (this.groupSql == undefined) {
      return undefined
    } else {
      let sql = this.groupSql
      if (this.havingSql != undefined) {
        sql += ` ${this.havingSql}`
      }
      return sql
    }
  }

  /**
   * 不对外使用
   */
  getUpdate() {
    return this.updateList.join(",")
  }

  /**
   * 不对外使用
   */
  getUpdateValue() {
    return this.updateValueList
  }
}