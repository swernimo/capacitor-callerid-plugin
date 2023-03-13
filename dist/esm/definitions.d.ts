import type { ICallerIdContact } from './ICallerIdContact';
export interface CallerIdPlugin {
    addContacts(options: {
        contacts: ICallerIdContact[];
    }): Promise<void>;
}
