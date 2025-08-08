import { relationalStore } from "@kit.ArkData"

/**
 * 构造查询参数
 */
export class Wrapper {
  protected selectSql: string = '*'
  protected groupSql: string = ''
  protected havingSql: string = ''
  protected orderList: string[] = []
  protected whereList: string[] = []
  protected valueList: relationalStore.ValueType[] = []
  protected updateList: string[] = []
  protected updateValueList: relationalStore.ValueType[] = []

  constructor() {
  }


  /**
   * update set 修改某字段
   * @param field 字段
   * @param value 值
   * @returns Wrapper
   */
  set(field: string, value: relationalStore.ValueType) {
    this.updateList.push(`${field} = ?`)
    this.updateValueList.push(value)
    return this
  }

  /**
   * 等于
   * @param field 字段
   * @param value 值
   * @returns Wrapper
   */
  eq(field: string, value: relationalStore.ValueType): Wrapper {
    this.whereList.push(`and ${field} = ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 不等于
   * @param field 字段
   * @param value 值
   * @returns Wrapper
   */
  notEq(field: string, value: relationalStore.ValueType): Wrapper {
    this.whereList.push(`and ${field} != ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 字段的值，在给定的集合中
   * @param field 字段
   * @param value 值的数组
   * @returns Wrapper
   */
  in(field: string, value: relationalStore.ValueType[]): Wrapper {
    const str = new Array(value.length).fill('?').join(',')
    this.whereList.push(`and ${field} in (${str})`)
    this.valueList.push(...value)
    return this
  }

  /**
   * 字段的值，不在给定的集合中
   * @param field 字段
   * @param value 值的数组
   * @returns Wrapper
   */
  notIn(field: string, value: relationalStore.ValueType[]): Wrapper {
    const str = new Array(value.length).fill('?').join(',')
    this.whereList.push(`and ${field} not in (${str})`)
    this.valueList.push(...value)
    return this
  }

  /**
   * 小于
   * @param field 字段
   * @param value 值
   * @returns Wrapper
   */
  lt(field: string, value: relationalStore.ValueType): Wrapper {
    this.whereList.push(`and ${field} < ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 小于等于
   * @param field 字段
   * @param value 值
   * @returns Wrapper
   */
  lte(field: string, value: relationalStore.ValueType): Wrapper {
    this.whereList.push(`and ${field} <= ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 大于
   * @param field 字段
   * @param value 值
   * @returns Wrapper
   */
  gt(field: string, value: relationalStore.ValueType): Wrapper {
    this.whereList.push(`and ${field} > ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 大于等于
   * @param field 字段
   * @param value 值
   * @returns Wrapper
   */
  gte(field: string, value: relationalStore.ValueType): Wrapper {
    this.whereList.push(`and ${field} >= ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 设置单个字段的 BETWEEN 条件
   * @param field 字段
   * @param start 起始值
   * @param end 结束值
   * @returns Wrapper
   */
  between(field: string, start: relationalStore.ValueType, end: relationalStore.ValueType): Wrapper {
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
   * @returns Wrapper
   */
  notBetween(field: string, start: relationalStore.ValueType, end: relationalStore.ValueType): Wrapper {
    this.whereList.push(`and ${field} not between ? and ?`)
    this.valueList.push(start)
    this.valueList.push(end)
    return this
  }

  /**
   * 单个字段的模糊匹配条件
   * @param field 字段
   * @param value 值
   * @returns Wrapper
   */
  like(field: string, value: relationalStore.ValueType): Wrapper {
    this.whereList.push(`and ${field} like ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 单个字段的非模糊匹配条件
   * @param field 字段
   * @param value 值
   * @returns Wrapper
   */
  notLike(field: string, value: relationalStore.ValueType): Wrapper {
    this.whereList.push(`and ${field} not like ?`)
    this.valueList.push(value)
    return this
  }

  /**
   * 单个字段为null
   * @param field 字段
   * @returns Wrapper
   */
  isNull(field: string): Wrapper {
    this.whereList.push(`and ${field} is null`)
    return this
  }

  /**
   * 单个字段不为null
   * @param field 字段
   * @returns Wrapper
   */
  isNotNull(field: string): Wrapper {
    this.whereList.push(`and ${field} is not null`)
    return this
  }

  /**
   * 对某字段排序-升序。可以调用多次，按顺序拼接SQL
   * @param field 字段
   * @returns Wrapper
   */
  orderByAsc(field: string): Wrapper {
    this.orderList.push(`${field} asc`)
    return this
  }

  /**
   * 对某字段排序-降序。可以调用多次，按顺序拼接SQL
   * @param field 字段
   * @returns Wrapper
   */
  orderByDesc(field: string): Wrapper {
    this.orderList.push(`${field} desc`)
    return this
  }

  /**
   * 分组查询，一般用object接收，实体类接收会导致没组只接收第一个
   * @param fields 可以传多个字段
   * @returns Wrapper
   */
  groupBy(...fields: string[]): Wrapper {
    const column = fields.join(',')
    this.groupSql = `group by ${column}`
    return this
  }

  /**
   * 过滤分组后的结果
   * @param sql having后面的sql条件
   * @returns Wrapper
   */
  having(sql: string): Wrapper {
    this.havingSql = `having ${sql}`
    return this
  }

  /**
   * 在查询条件中添加 OR 逻辑，传入的wrapper仅用来拼接where条件
   * @param wrapper 一个新的Wrapper
   * @returns Wrapper
   */
  or(wrapper: Wrapper): Wrapper {
    this.whereList.push('or (1=1 ')
    this.whereList.push(...wrapper.whereList)
    this.whereList.push(')')
    this.valueList.push(...wrapper.valueList)
    return this
  }

  /**
   * 在查询条件中添加 and 逻辑，传入的wrapper仅用来拼接where条件
   * @param wrapper 一个新的Wrapper
   * @returns Wrapper
   */
  and(wrapper: Wrapper): Wrapper {
    this.whereList.push('and (1=1 ')
    this.whereList.push(...wrapper.whereList)
    this.whereList.push(')')
    this.valueList.push(...wrapper.valueList)
    return this
  }

  /**
   * 仅查询指定字段的数据
   * @param sql sql语句
   * @returns Wrapper
   */
  select(...field: string[]): Wrapper {
    this.selectSql = field.join(',')
    return this
  }

  /**
   * 仅查询指定SQL
   * @param sql sql语句
   * @returns Wrapper
   */
  selectSQL(sql: string): Wrapper {
    this.selectSql = sql
    return this
  }
}