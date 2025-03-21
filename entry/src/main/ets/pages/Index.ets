/**
 * @author yongoe
 * @since 2024/10/15
 */
import { Wrapper } from 'rdbplus'
import { Employee } from '../entity/Employee'
import { EmpMapper } from '../mapper/EmpMapper'
import { showDialog } from '../utils/MessageDialog'

@Entry
@Component
struct Index {
  mapper = EmpMapper.getInstance()

  build() {

    Flex({ wrap: FlexWrap.Wrap }) {
      Button('初始化').onClick(() => {
        this.mapper.createTable()
        showDialog('初始化完成，查看日志')
      })

      Button('count').onClick(async () => {
        showDialog(JSON.stringify(await this.mapper.count(new Wrapper())))
      })

      Button('page').onClick(async () => {
        const page = await this.mapper.getPage(1, 10, new Wrapper())
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

      Button('得到对象').onClick(async () => {
        const res = await this.mapper.getObject(new Wrapper().eq('name', '111'))
        showDialog(JSON.stringify(res))
      })

      Button('sql得到对象').onClick(async () => {
        const res = await this.mapper.getObjectBySql('select  count(*) from t_emp', [])
        showDialog(JSON.stringify(res))
      })

      Button('getById').onClick(async () => {
        const res = await this.mapper.getById(1)
        showDialog(JSON.stringify(res))
      })

      Button('等于').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().eq('name', '111'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('不等于').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().notEq('name', '111'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('in').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().in('name', ['111', '222']))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('notIn').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().notIn('name', ['111', '222']))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('lt').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().lt('name', '333'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('lte').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().and(new Wrapper()).or(new Wrapper()).lte('name', '333'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('gt').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().gt('name', '333'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('gte').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().gte('name', '333'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('between').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().between('name', '333', '555'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('notBetween').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().notBetween('name', '333', '555'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Divider()
        .width('100%')
        .height(10)
        .color('#000')

      Button('like').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().like('name', '333%'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('notLike').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().notLike('name', '333%'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('isNull').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().isNull('name'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('isNotNull').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().isNotNull('name'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('orderByAsc').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().orderByAsc('id'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('orderByDesc').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().orderByDesc('id'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Divider()
        .width('100%')
        .height(10)
        .color('#000')

      Button('groupBy').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().groupBy('name'))
        showDialog(JSON.stringify(res, null, 2))

      })
      Button('having').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().groupBy('name').having(`name != '333'`))
        showDialog(JSON.stringify(res, null, 2))
      })
      Button('or').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().eq('name', '111').or(new Wrapper().eq('name', '222')))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('and').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper()
          .eq('name', '111')
          .and(new Wrapper().notEq('name', 222))
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
        showDialog(JSON.stringify(await this.mapper.insert(emp)))
      })

      Button('id=20,updateById').onClick(async () => {
        const emp = new Employee()
        emp.id = 20
        emp.name = '根据id修改'
        showDialog(JSON.stringify(await this.mapper.updateById(emp)))
      })

      Button('修改').onClick(async () => {
        const boo = await this.mapper.update(new Wrapper().set('name', '使用set修改').eq('name', '根据id修改'))
        showDialog(JSON.stringify(boo))
      })

      Button('删除').onClick(async () => {
        const boo = await this.mapper.delete(new Wrapper().eq('name', '111'))
        showDialog('name==111被删除', JSON.stringify(boo))

      })

      Button('删除byId').onClick(async () => {
        const boo = await this.mapper.deleteById(5)
        showDialog('id==5被删除', JSON.stringify(boo))
      })

      Divider()
        .width('100%')
        .height(10)
        .color('#000')

      Button('事务成功').onClick(async (event: ClickEvent) => {
        // 获取一个db连接
        const db = await this.mapper.getConnection()
        try {
          db.beginTransaction()
          const emp = new Employee()
          emp.name = '事务'
          // 将 db 传进去，保持所有操作在同一连接上
          this.mapper.insert(emp, db)
          //提交事务
          db.commit()
        } catch (e) {
          // 回滚
          db.rollBack()
        } finally {
          // 关闭连接
          db.close()
        }
      })

      Button('事务失败').onClick(async (event: ClickEvent) => {
        // 获取一个db连接
        const db = await this.mapper.getConnection()
        try {
          db.beginTransaction()
          const emp = new Employee()
          emp.name = '事务失败'
          // 将 db 传进去，保持所有操作在同一连接上
          this.mapper.insert(emp, db)
          // 抛出异常
          throw new Error('我的异常')
          //提交事务
          db.commit()
        } catch (e) {
          // 回滚
          db.rollBack()
          console.error(e.message)
        } finally {
          // 关闭连接
          db.close()
        }
      })

    }
    .width('100%')
    .height('100%')

  }
}

