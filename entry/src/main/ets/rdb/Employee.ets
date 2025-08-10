import { Table, TableField, FieldType } from "rdbplus"

@Table({ tableName: 't_emp' })
export class Employee {
  /**
   * id，数据库字段为id
   */
  @TableField({ name: 'id', type: FieldType.NUMBER, isPrimaryKey: true })
  id?: number
  /**
   * 名字，数据库字段为name，同名可省略TableField.name
   */
  @TableField({ type: FieldType.TEXT, })
  name?: string
  /**
   * 年龄，数据库字段为age，myAge与数据库字段age互相映射
   */
  @TableField({ name: 'age', type: FieldType.NUMBER, })
  myAge?: number

  /**
   * 其他字段，会被sql忽略，不参与操作
   */
  other?: number
}