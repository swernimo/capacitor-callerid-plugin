import { WebPlugin } from '@capacitor/core';

import type { ICallerIdContact } from './ICallerIdContact';
import type { CallerIdPlugin } from './definitions';

export class CallerIdWeb extends WebPlugin implements CallerIdPlugin {

  async addContacts(options: { contacts: ICallerIdContact[] }): Promise<void> {
    console.log('caller id plugin', options);
    return;
  }

  async checkStatus(): Promise<boolean> {
    console.log("always returning false for caller id: check status on web");
    return false;
  }
}
