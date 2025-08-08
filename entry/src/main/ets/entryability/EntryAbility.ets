import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { Connection, DbLogger } from 'rdbplus';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    windowStage.loadContent('pages/Index', (err) => {
      let win = windowStage.getMainWindowSync()
      Connection.init(win.getUIContext().getHostContext(), new DbLogger())
    });
  }
}