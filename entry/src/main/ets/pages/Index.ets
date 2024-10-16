/**
 * @author yongoe
 * @since 2024/10/15
 */
import { Wapper } from 'rdbplus'
import { Employee } from '../entity/Employee'
import { EmpModel } from '../model/EmpModel'
import { showDialog } from '../utils/MessageDialog'

@Entry
@Component
struct Index {
  empModel = EmpModel.getInstance()

  build() {

    Flex({ wrap: FlexWrap.Wrap }) {
      Button('初始化').onClick(() => {
        this.empModel.createTable()
        showDialog('初始化完成，查看日志')
      })

      Button('count').onClick(async () => {
        showDialog(JSON.stringify(await this.empModel.count()))
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
        showDialog(JSON.stringify(page))
      })

      Button('map').onClick(async () => {
        const res = await this.empModel.selectByMap(new Wapper().eq('name', '111'))
        let str = ''
        res.forEach((value) => {
          value.forEach((value, key) => {
            str += `${key}: ${value}\n`
          });
        })
        showDialog(str)
      })

      Button('等于').onClick(async () => {
        const res = await this.empModel.list(new Wapper().eq('name', '111'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('不等于').onClick(async () => {
        const res = await this.empModel.list(new Wapper().notEq('name', '111'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('in').onClick(async () => {
        const res = await this.empModel.list(new Wapper().in('name', ['111', '222']))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('notIn').onClick(async () => {
        const res = await this.empModel.list(new Wapper().notIn('name', ['111', '222']))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('lt').onClick(async () => {
        const res = await this.empModel.list(new Wapper().lt('name', '333'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('lte').onClick(async () => {
        const res = await this.empModel.list(new Wapper().lte('name', '333'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('gt').onClick(async () => {
        const res = await this.empModel.list(new Wapper().gt('name', '333'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('gte').onClick(async () => {
        const res = await this.empModel.list(new Wapper().gte('name', '333'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('between').onClick(async () => {
        const res = await this.empModel.list(new Wapper().between('name', '333', '555'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('notBetween').onClick(async () => {
        const res = await this.empModel.list(new Wapper().notBetween('name', '333', '555'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Divider()
        .width('100%')
        .height(10)
        .color('#000')

      Button('like').onClick(async () => {
        const res = await this.empModel.list(new Wapper().like('name', '333%'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('notLike').onClick(async () => {
        const res = await this.empModel.list(new Wapper().notLike('name', '333%'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('isNull').onClick(async () => {
        const res = await this.empModel.list(new Wapper().isNull('name'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('isNotNull').onClick(async () => {
        const res = await this.empModel.list(new Wapper().isNotNull('name'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('orderByAsc').onClick(async () => {
        const res = await this.empModel.list(new Wapper().orderByAsc('id'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('orderByDesc').onClick(async () => {
        const res = await this.empModel.list(new Wapper().orderByDesc('id'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Divider()
        .width('100%')
        .height(10)
        .color('#000')

      Button('groupBy').onClick(async () => {
        const res = await this.empModel.list(new Wapper().groupBy('name'))
        showDialog(JSON.stringify(res, null, 2))

      })
      Button('having').onClick(async () => {
        const res = await this.empModel.list(new Wapper().groupBy('name').having(`name != '333'`))
        showDialog(JSON.stringify(res, null, 2))
      })
      Button('or').onClick(async () => {
        const res = await this.empModel.list(new Wapper().eq('name', '111').or(new Wapper().eq('name', '222')))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('and').onClick(async () => {
        const res = await this.empModel.list(new Wapper()
          .eq('name', '111')
          .and(new Wapper().notEq('name', 222))
        )
        showDialog(JSON.stringify(res, null, 2))
      })

      Divider()
        .width('100%')
        .height(10)
        .color('#000')

      Button('添加').onClick(async () => {
        const emp = new Employee()
        emp.name = '新添加的'
        showDialog(JSON.stringify(await this.empModel.insert(emp)))
      })

      Button('id=20,updateById').onClick(async () => {
        const emp = new Employee()
        emp.id = 20
        emp.name = '根据id修改'
        showDialog(JSON.stringify(await this.empModel.updateById(emp)))
      })

      Button('修改').onClick(async () => {
        const boo = await this.empModel.update(new Wapper().set('name', '使用set修改').eq('name', '根据id修改'))
        showDialog(JSON.stringify(boo))
      })

      Button('删除').onClick(async () => {
        const boo = await this.empModel.delete(new Wapper().eq('name', '111'))
        showDialog('name==111被删除', JSON.stringify(boo))

      })

      Button('删除byId').onClick(async () => {
        const boo = await this.empModel.deleteById(5)
        showDialog('id==5被删除', JSON.stringify(boo))
      })

    }
    .width('100%')
    .height('100%')

  }
}

