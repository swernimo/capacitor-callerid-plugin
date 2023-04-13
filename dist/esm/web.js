import { WebPlugin } from '@capacitor/core';
export class CallerIdWeb extends WebPlugin {
    async addContacts(options) {
        console.log('caller id plugin', options);
        return;
    }
    async checkStatus() {
        console.log("always returning false for caller id: check status on web");
        return { value: false };
    }
}
//# sourceMappingURL=web.js.map