import { TableFieldParams } from "../model/TableFieldParams";

type Class = new (...args: any[]) => any;

/**
 * 获取实体类的元数据
 */
export function getEntityMeta(Type: Class): string {
  return (Type as any).__tableMeta__.tableName || '';
}

/**
 * 获取字段上的元数据
 */
export function getColumnMeta(Type: Class): TableFieldParams[] {
  return (Type as any).__tableFieldMeta__;
}