import { WebPlugin } from '@capacitor/core';
import type { ICallerIdContact } from './ICallerIdContact';
import type { CallerIdPlugin } from './definitions';
export declare class CallerIdWeb extends WebPlugin implements CallerIdPlugin {
    addContacts(options: {
        contacts: ICallerIdContact[];
    }): Promise<void>;
    checkStatus(): Promise<{
        value: boolean;
    }>;
}
