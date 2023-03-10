import { WebPlugin } from '@capacitor/core';

import type { CallerIdPlugin } from './definitions';

export class CallerIdWeb extends WebPlugin implements CallerIdPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
