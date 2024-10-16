/**
 * @author yongoe
 * @since 2024/10/15
 */
import { Wapper } from 'rdbplus'
import { Employee } from '../entity/Employee'
import { EmpModel } from '../model/EmpModel'

@Entry
@Component
struct Index {
  empModel = EmpModel.getInstance()

  build() {

    Flex({ wrap: FlexWrap.Wrap }) {
      Button('初始化').onClick(() => {
        this.empModel.createTable()
      })

      Button('count').onClick(async () => {
        his.empModel.count()
      })

      Button('page').onClick(async () => {
        const page = await this.empModel.page(1,10)
        // 总数
        const total = page.total
        // 当前页
        const current = page.current
        // 每页条数
        const size = page.size
        // 结果集
        const record = page.record
      })

      Button('map').onClick(async () => {
        const res = await this.empModel.selectByMap(new Wapper().eq('name', '111'))
        let str = ''
        res.forEach((value) => {
          value.forEach((value, key) => {
            str += `${key}: ${value}\n`
          });
        })
      })

      Button('等于').onClick(async () => {
        const res = await this.empModel.list(new Wapper().eq('name', '111'))
      })

      Button('不等于').onClick(async () => {
        const res = await this.empModel.list(new Wapper().notEq('name', '111'))
      })

      Button('in').onClick(async () => {
        const res = await this.empModel.list(new Wapper().in('name', ['111', '222']))
      })

      Button('notIn').onClick(async () => {
        const res = await this.empModel.list(new Wapper().notIn('name', ['111', '222']))
      })

      Button('lt').onClick(async () => {
        const res = await this.empModel.list(new Wapper().lt('name', '333'))
      })

      Button('lte').onClick(async () => {
        const res = await this.empModel.list(new Wapper().lte('name', '333'))
      })

      Button('gt').onClick(async () => {
        const res = await this.empModel.list(new Wapper().gt('name', '333'))
      })

      Button('gte').onClick(async () => {
        const res = await this.empModel.list(new Wapper().gte('name', '333'))
      })

      Button('between').onClick(async () => {
        const res = await this.empModel.list(new Wapper().between('name', '333', '555'))
      })

      Button('notBetween').onClick(async () => {
        const res = await this.empModel.list(new Wapper().notBetween('name', '333', '555'))
      })

      Divider()
        .width('100%')
        .height(10)
        .color('#000')

      Button('like').onClick(async () => {
        const res = await this.empModel.list(new Wapper().like('name', '333%'))
      })

      Button('notLike').onClick(async () => {
        const res = await this.empModel.list(new Wapper().notLike('name', '333%'))
      })

      Button('isNull').onClick(async () => {
        const res = await this.empModel.list(new Wapper().isNull('name'))
      })

      Button('isNotNull').onClick(async () => {
        const res = await this.empModel.list(new Wapper().isNotNull('name'))
      })

      Button('orderByAsc').onClick(async () => {
        const res = await this.empModel.list(new Wapper().orderByAsc('id'))
      })

      Button('orderByDesc').onClick(async () => {
        const res = await this.empModel.list(new Wapper().orderByDesc('id'))
      })

      Divider()
        .width('100%')
        .height(10)
        .color('#000')

      Button('groupBy').onClick(async () => {
        const res = await this.empModel.list(new Wapper().groupBy('name'))

      })
      Button('having').onClick(async () => {
        const res = await this.empModel.list(new Wapper().groupBy('name').having(`name != '333'`))
      })
      Button('or').onClick(async () => {
        const res = await this.empModel.list(new Wapper().eq('name', '111').or(new Wapper().eq('name', '222')))
      })

      Button('and').onClick(async () => {
        const res = await this.empModel.list(new Wapper()
          .eq('name', '111')
          .and(new Wapper().notEq('name', 222))
        )
      })

      Divider()
        .width('100%')
        .height(10)
        .color('#000')

      Button('添加').onClick(async () => {
        const emp = new Employee()
        emp.name = '新添加的'
        await this.empModel.add(emp)
      })

      Button('id=20,updateById').onClick(async () => {
        const emp = new Employee()
        emp.id = 20
        emp.name = '根据id修改'
        await this.empModel.updateById(emp)
      })

      Button('修改').onClick(async () => {
        const boo = await this.empModel.update(new Wapper().set('name', '使用set修改').eq('name', '根据id修改'))
      })

      Button('删除').onClick(async () => {
        const boo = await this.empModel.delete(new Wapper().eq('name', '111'))

      })

      Button('删除byId').onClick(async () => {
        const boo = await this.empModel.deleteById(5)
        showDialog('id==5被删除', JSON.stringify(boo))

      Button('批量删除').onClick(async () => {
        const boo = await this.empModel.deleteByIds([10, 11])
      })

    }
    .width('100%')
    .height('100%')

  }
}

