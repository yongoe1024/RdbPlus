import { FieldType } from "./FieldType";

export interface TableFieldParams {
  // 字段名
  name: string;

  // 字段类型
  type: FieldType;

  // 是否主键
  isPrimaryKey?: boolean;
}