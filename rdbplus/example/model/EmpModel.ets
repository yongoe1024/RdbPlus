import { Employee } from '../entity/Employee'
import { relationalStore } from '@kit.ArkData'
import { BaseMapper } from 'rdbplus'

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
      (res: relationalStore.ResultSet) => {
        const emp = new Employee()
        emp.id = res.getLong(res.getColumnIndex('id'))
        emp.name = res.getString(res.getColumnIndex('name'))
        return emp
      },
      {
        name: 'demo.db',
        securityLevel: relationalStore.SecurityLevel.S1
      }
    )
  }

  async createTable() {
    await this.getDbHelper().execDML(`DROP TABLE t_emp;`, [])
    await this.getDbHelper().execDML(
      `create table if not exists "t_emp" (
          id integer primary key autoincrement,
          name varchar(20)
      )`, [])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['111'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['111'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['111'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['222'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['333'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['444'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['555'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['666'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['777'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['888'])

    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['111a'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['222b'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['333c'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['444d'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['555e'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['666f'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['777g'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, ['888h'])
    await this.getDbHelper().execDML(`INSERT INTO t_emp (id,name)  VALUES (null, ? );`, [null])

  }
}