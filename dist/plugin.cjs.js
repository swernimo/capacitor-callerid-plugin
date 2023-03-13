'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var core = require('@capacitor/core');

const CallerId = core.registerPlugin('CallerId', {
    web: () => Promise.resolve().then(function () { return web; }).then(m => new m.CallerIdWeb()),
});

class CallerIdWeb extends core.WebPlugin {
    async addContacts(options) {
        console.log('ECHO', options);
        return;
    }
}

var web = /*#__PURE__*/Object.freeze({
    __proto__: null,
    CallerIdWeb: CallerIdWeb
});

exports.CallerId = CallerId;
//# sourceMappingURL=plugin.cjs.js.map
