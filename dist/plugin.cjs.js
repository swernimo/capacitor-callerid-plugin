'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var core = require('@capacitor/core');

const CallerId = core.registerPlugin('CallerId', {
    web: () => Promise.resolve().then(function () { return web; }).then(m => new m.CallerIdWeb()),
});

class CallerIdWeb extends core.WebPlugin {
    async addContacts(options) {
        console.log('caller id plugin', options);
        return;
    }
    async checkStatus() {
        console.log("always returning false for caller id: check status on web");
        return { value: false };
    }
}

var web = /*#__PURE__*/Object.freeze({
    __proto__: null,
    CallerIdWeb: CallerIdWeb
});

exports.CallerId = CallerId;
//# sourceMappingURL=plugin.cjs.js.map
