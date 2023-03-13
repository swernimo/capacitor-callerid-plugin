import { WebPlugin } from '@capacitor/core';

import type { ICallerIdContact } from './ICallerIdContact';
import type { CallerIdPlugin } from './definitions';

export class CallerIdWeb extends WebPlugin implements CallerIdPlugin {

  async addContacts(options: { contacts: ICallerIdContact[] }): Promise<void> {
    console.log('ECHO', options);
    return;
  }
}
