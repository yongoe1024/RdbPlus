import { Table, TableField, FieldType } from "rdbplus"

@Table({ tableName: 't_emp' })
export class Employee {
  /**
   * id
   */
  @TableField({ name: 'id', type: FieldType.NUMBER, isPrimaryKey: true })
  id?: number
  /**
   * 名字
   */
  @TableField({ name: 'name', type: FieldType.TEXT, })
  name?: string
  /**
   * 年龄
   */
  @TableField({ name: 'age', type: FieldType.NUMBER, })
  age?: number
}