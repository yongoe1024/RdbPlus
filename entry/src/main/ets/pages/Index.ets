/**
 * @author yongoe
 * @since 2024/10/15
 */
import { Wrapper } from 'rdbplus'
import { Employee } from './Employee'
import { EmpMapper } from './EmpMapper'
import { showDialog } from './MessageDialog'

@Entry
@Component
struct Index {
  mapper = EmpMapper.getInstance()

  build() {

    Flex({ wrap: FlexWrap.Wrap }) {
      Button('初始化').onClick(() => {
        EmpMapper.createTable()
        showDialog('初始化完成，查看日志')
      })

      Button('count').onClick(async () => {
        showDialog(JSON.stringify(await this.mapper.count(new Wrapper()), null, 2))
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
        showDialog(JSON.stringify(page, null, 2))
      })

      Button('得到对象 name=123').onClick(async () => {
        const res: ESObject = await this.mapper.getObject(new Wrapper().eq('name', '123'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('sql得到对象 count(*)').onClick(async () => {
        const res: ESObject = await this.mapper.getObjectBySql('select count(*) from t_emp', [])
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('getById id=3').onClick(async () => {
        const res = await this.mapper.getById(3)
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('等于 name==123').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().eq('name', '123'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('不等于 name!==123').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().notEq('name', '123'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('in 123 124').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().in('name', ['123', '124']))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('notIn 123 124').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().notIn('name', ['123', '124']))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('lt id<2').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().lt('id', 2))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('lte id<=2').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().lte('id', 2))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('gt id>2').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().gt('id', 2))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('gte id>=2').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().gte('id', 2))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('between id 2-4').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().between('id', 2, 4))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('notBetween id 2-4').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().notBetween('id', 2, 4))
        showDialog(JSON.stringify(res, null, 2))
      })

      Divider()
        .width('100%')
        .height(40)
        .color('#000')

      Button('like name 12').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().like('name', '12%'))
        showDialog(JSON.stringify(res, null, 2))
      })

      Button('notLike name 12').onClick(async () => {
        const res = await this.mapper.getList(new Wrapper().notLike('name', '12%'))
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
        .height(40)
        .color('#000')

      // 可以用getList，类型仅在编译期限制
      Button('groupBy age=18 每种的数量').onClick(async () => {
        const res: ESObject[] = await this.mapper.getObject(new Wrapper()
          .groupBy('age')
          .select('age', 'count(*)'))
        showDialog(JSON.stringify(res, null, 2))
      })
      // 可以用getList，类型仅在编译期限制
      Button('having age!=30 每种的数量').onClick(async () => {
        const res: ESObject[] =
          await this.mapper.getObject(new Wrapper()
            .select('age', 'count(*)')
            .groupBy('age')
            .having(`age != 30`))
        showDialog(JSON.stringify(res, null, 2))
      })

      Divider()
        .width('100%')
        .height(40)
        .color('#000')

      Button('批量添加').onClick(async () => {
        const emp: Employee[] = [
          {
            name: '123',
            age: 18
          },
          {
            name: '124',
            age: 18
          },
          {
            name: '张三',
            age: 20
          },
          {
            name: '李四',
            age: 20
          },
          {
            name: '网二',
            age: 21
          },
          {
            name: undefined,
            age: undefined
          },
          {
            name: 'age是undefined',
            age: undefined
          },
          {
            name: undefined,
            age: 30
          },
        ]
        await this.mapper.insertBatch(emp)
        showDialog('成功')
      })

      Button('id=3 => name=修改 updateById').onClick(async () => {
        const emp = new Employee()
        emp.id = 3
        emp.name = '修改'
        await this.mapper.updateById(emp)
        showDialog('成功')
      })

      Button('name=修改 => 使用set修改 update').onClick(async () => {
        await this.mapper.update(new Wrapper().set('name', '使用set修改').eq('name', '修改'))
        showDialog('成功')
      })

      Button('删除 name 使用set修改').onClick(async () => {
        await this.mapper.delete(new Wrapper().eq('name', '使用set修改'))
        showDialog('成功')
      })

      Button('deleteById id =3').onClick(async () => {
        await this.mapper.deleteById(3)
        showDialog('成功')
      })

      Divider()
        .width('100%')
        .height(40)
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

