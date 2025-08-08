export class Page<T> {
  total: number = 0
  current: number = 1
  size: number = 10
  record: T[] = []

  constructor(total: number, current: number, size: number, record: T[]) {
    this.total = total
    this.current = current
    this.size = size
    this.record = record
  }
}
