import { TableParams } from "../model/TableParams";

/**
 * 类装饰器
 */
export function Table(options: TableParams) {
  return function (target: ESObject) {
    target.__tableMeta__ = options;
  };
}