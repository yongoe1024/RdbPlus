import { Employee } from '../entity/Employee'
import { relationalStore } from '@kit.ArkData'
import { BaseMapper } from 'rdbplus'

const getRow = (res: relationalStore.ResultSet) => {
  const emp = new Employee()
  emp.id = res.getLong(res.getColumnIndex('id'))
  emp.name = res.getString(res.getColumnIndex('name'))
  return emp
}

export class EmpModel extends BaseMapper<Employee> {
  private static empModel: EmpModel

  // 单例模式
  static getInstance(): EmpModel {
    if (!EmpModel.empModel) {
      EmpModel.empModel = new EmpModel()
    }
    return EmpModel.empModel
  }

  private constructor() {
    super({ tableName: 't_emp', primaryKey: 'id' },
      getRow,
      {
        name: 'demo.db',
        securityLevel: relationalStore.SecurityLevel.S1
      }
    )
  }

  async createTable() {
    const db = await this.getConnection()
    await db.execDML(`DROP TABLE IF EXISTS t_emp  ;`, [])
    await db.execDML(
      `create table if not exists "t_emp" (
          id integer primary key autoincrement,
          name varchar(20)
      )`, [])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['111'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['111'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['111'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['222'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['333'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['444'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['555'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['666'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['777'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['888'])

    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['111a'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['222b'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['333c'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['444d'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['555e'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['666f'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['777g'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['888h'])
    await db.execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, [null])
    await db.close()
  }
}