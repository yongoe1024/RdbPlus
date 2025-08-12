/**
 * @author yongoe
 * @since 2024/10/15
 */
import { Connection, Wrapper } from 'rdbplus'
import { Employee } from '../rdb/Employee'
import { EmpMapper } from '../rdb/EmpMapper'
import { showDialog } from '../rdb/MessageDialog'

@Entry
@Component
struct Index {
  mapper = EmpMapper.getInstance()

  build() {

    Flex({ wrap: FlexWrap.Wrap }) {
      Button('删除数据库').onClick((event: ClickEvent) => {
        Connection.deleteRdbStore('RdbTest.db')
        showDialog('删除数据库')
      })
      Button('初始化').onClick(async () => {
        try {
          await EmpMapper.createTable()
          showDialog('初始化完成，查看日志')
        } catch (e) {
          console.error(e)
        }
      })

      Button('count').onClick(async () => {
        try {
          let num = await this.mapper.count(new Wrapper())
          showDialog(num + '')
        } catch (e) {
          console.error(e)
        }
      })

      Button('page').onClick(async () => {
        try {
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
        } catch (e) {
          console.error(e)
        }
      })

      Button('getObject name=123').onClick(async () => {
        try {
          const res: ESObject = await this.mapper.getObject(new Wrapper().eq('name', '123'))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('getObjectBySql count(*)').onClick(async () => {
        try {
          const res: ESObject = await this.mapper.getObjectBySql('select count(*) from t_emp', [])
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('getById(3)').onClick(async () => {
        try {
          const res = await this.mapper.getById(3)
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('getList(name=123)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().eq('name', '123'))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('getList(name!==123)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().notEq('name', '123'))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('in[123 124]').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().in('name', ['123', '124']))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('notIn[123 124]').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().notIn('name', ['123', '124']))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('lt(id<2)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().lt('id', 2))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('lte(id<=2)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().lte('id', 2))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('gt(id>2)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().gt('id', 2))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('gte(id>=2)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().gte('id', 2))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('between id[2 4]').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().between('id', 2, 4))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('notBetween id[2 4]').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().notBetween('id', 2, 4))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Divider()
        .width('100%')
        .height(20)
        .color('#000')

      Button('like name(12%)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().like('name', '12%'))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('notLike name(12%)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().notLike('name', '12%'))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('isNull(name)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().isNull('name'))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('isNotNull(name)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().isNotNull('name'))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('orderByAsc(id)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().orderByAsc('id'))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('orderByDesc(id)').onClick(async () => {
        try {
          const res = await this.mapper.getList(new Wrapper().orderByDesc('id'))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Divider()
        .width('100%')
        .height(20)
        .color('#000')

      Button('groupBy age=18 count(*)').onClick(async () => {
        try {
          const res: ESObject[] = await this.mapper.getObject(new Wrapper()
            .groupBy('age')
            .select('age', 'count(*)'))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Button('having age!=30 count(*)').onClick(async () => {
        try {
          const res: ESObject[] =
            await this.mapper.getObject(new Wrapper()
              .select('age', 'count(*)')
              .groupBy('age')
              .having(`age != 30`))
          showDialog(JSON.stringify(res, null, 2))
        } catch (e) {
          console.error(e)
        }
      })

      Divider()
        .width('100%')
        .height(20)
        .color('#000')

      Button('批量添加8条').onClick(async () => {
        try {
          const emp: Employee[] = [
            {
              name: '123',
              myAge: 18
            },
            {
              name: '124',
              myAge: 18
            },
            {
              name: '张三',
              myAge: 20
            },
            {
              name: '李四',
              myAge: 20
            },
            {
              name: '网二',
              myAge: 21
            },
            {
              name: undefined,
              myAge: undefined
            },
            {
              name: 'age是undefined',
              myAge: undefined
            },
            {
              name: undefined,
              myAge: 30
            },
          ]
          let num = await this.mapper.insertBatch(emp)
          showDialog('成功' + num)
        } catch (e) {
          console.error(e)
        }
      })

      Button('首次updateById(3)').onClick(async () => {
        try {
          const emp = new Employee()
          emp.id = 3
          emp.name = 'updateById'
          let num = await this.mapper.updateById(emp)
          showDialog('成功' + num)
        } catch (e) {
          console.error(e)
        }
      })

      Button('再次修改update').onClick(async () => {
        try {
          let num = await this.mapper.update(new Wrapper().set('name', 'update使用set修改')
            .set('id', 100)
            .eq('name', 'updateById'))
          showDialog('成功' + num)
        } catch (e) {
          console.error(e)
        }
      })

      Button('删除id=3').onClick(async () => {
        try {
          let num = await this.mapper.delete(new Wrapper().eq('id', 3))
          showDialog('成功' + num)
        } catch (e) {
          console.error(e)
        }
      })

      Button('deleteById id=3').onClick(async () => {
        try {
          let num = await this.mapper.deleteById(3)
          showDialog('成功' + num)
        } catch (e) {
          console.error(e)
        }
      })

      Divider()
        .width('100%')
        .height(20)
        .color('#000')

      Button('事务成功').onClick(async () => {
        // 获取一个db连接
        this.mapper.getConnection()
          .then(async db => {
            try {
              db.beginTransaction()
              const emp = new Employee()
              emp.name = '事务'
              emp.myAge = 44
              // 将 db 传进去，保持所有操作在同一连接上
              let num = await this.mapper.insert(emp, db)
              //提交事务
              db.commit()
              showDialog('成功' + num)
            } catch (e) {
              // 回滚
              db.rollBack()
            } finally {
              // 关闭连接
              db.close()
            }
          })
          .catch(() => {
            console.log('db获取失败')
          })
      })

      Button('事务失败').onClick(async () => {
        // 获取一个db连接
        this.mapper.getConnection()
          .then(async db => {
            try {
              db.beginTransaction()
              const emp = new Employee()
              emp.name = '事务失败'
              // 将 db 传进去，保持所有操作在同一连接上
              await this.mapper.insert(emp, db)
              // 抛出异常
              throw new Error('我的异常,事务失败')
            } catch (e) {
              // 回滚
              db.rollBack()
              console.error(e)
            } finally {
              // 关闭连接
              db.close()
            }
          })
          .catch(() => {
            console.log('db获取失败')
          })
      })
    }
    .width('100%')
    .height('100%')

  }
}

