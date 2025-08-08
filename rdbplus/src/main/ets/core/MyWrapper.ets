import { Wrapper } from "./Wrapper"
import { relationalStore } from "@kit.ArkData"


export class MyWrapper extends Wrapper {
  /**
   * 静态工厂方法，生成一个MyWrapper对象
   */
  static build(parent: Wrapper): MyWrapper {
    let x = parent as MyWrapper
    const myWrapper = new MyWrapper();
    myWrapper.selectSql = x.selectSql
    myWrapper.groupSql = x.groupSql
    myWrapper.havingSql = x.havingSql
    myWrapper.orderList = x.orderList
    myWrapper.whereList = x.whereList
    myWrapper.valueList = x.valueList
    myWrapper.updateList = x.updateList
    myWrapper.updateValueList = x.updateValueList
    return myWrapper
  }

  /**
   * 获取select
   */
  getSelect(): string {
    return this.selectSql
  }

  /**
   * 获取where后的条件
   */
  getWhere(): string {
    let sql = '1=1 ' + this.whereList.join(" ")
    return sql
  }

  /**
   * 获取所有占位符对应参数
   */
  getValue(): relationalStore.ValueType[] {
    return this.valueList
  }

  /**
   * 得到排序sql
   */
  getOrder(): string {
    if (this.orderList.length == 0) {
      return ''
    } else {
      return 'order by ' + this.orderList.join(',')
    }
  }

  /**
   * 得到分组sql
   */
  getGroup(): string {
    if (this.groupSql == '') {
      return ''
    } else {
      let sql = this.groupSql
      if (this.havingSql != '') {
        sql += ` ${this.havingSql}`
      }
      return sql
    }
  }

  /**
   * 拼接set语句
   */
  getUpdate() {
    return this.updateList.join(",")
  }

  /**
   * 获取更新的占位符参数
   */
  getUpdateValue() {
    return this.updateValueList
  }
}