//【信息弹窗工具】
//  自定义的功能工具，没有布局概念
//  都是独立的，提供解构导入使用
//  这里要负责系统中，各种信息弹窗
//===============================================

//导入资源
import promptAction from '@ohos.promptAction'

/**
 * 短通知
 * @param message 提示文本
 * @param time    停留时间
 */
export function showToast(message: string, time: number = 3000) {
  promptAction.showToast({
    message,
    duration: time
  })
}

export function showDialog(msg: string, title: string = '系统提示', callBack = () => {
}) {
  promptAction.showDialog({
    title: title,
    message: msg
  })
  //弹窗没有按钮，确定对应then，取消或外部点击对应的catch
  //委托：将一个函数，作为参数，交付给另一个函数去执行
    .catch(callBack)
}


//确认对话框
export function alertDialog(msg: string, submit: () => void, title: string = '系统提示') {
  AlertDialog.show({
    title,
    message: msg,
    secondaryButton: {
      value: '取消', action: () => {
      }
    },
    primaryButton: { value: '确定', action: () => submit() }
  })
}




