import { Logger } from './Logger';

/**
 * 日志默认实现
 **/
export class DbLogger implements Logger {
  debug(...args: string[]): void {
    console.debug('rdb ' + args.join(' '));
  }

  info(...args: string[]): void {
    console.info('rdb ' + args.join(' '));
  }

  warn(...args: string[]): void {
    console.warn('rdb ' + args.join(' '));
  }

  error(...args: string[]): void {
    console.error('rdb ' + args.join(' '));
  }
}