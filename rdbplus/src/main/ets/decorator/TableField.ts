import { TableFieldParams } from "../model/TableFieldParams";

/**
 * 字段装饰器
 */
export function TableField(options: TableFieldParams) {
  return function (target: ESObject, propertyKey: string) {
    if (!target.constructor.__tableFieldMeta__) {
      target.constructor.__tableFieldMeta__ = [];
    }
    target.constructor.__tableFieldMeta__.push({
      propertyKey,
      ...options
    });
  };
}