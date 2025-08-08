/**
 * 将一个对象转为具体的class实例（可使用类方法）
 */
export function copyInstance<T>(target, sources): T {
  return Object.assign(target, sources);
}