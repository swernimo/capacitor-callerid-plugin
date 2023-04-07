var capacitorCallerId = (function (exports, core) {
    'use strict';

    const CallerId = core.registerPlugin('CallerId', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.CallerIdWeb()),
    });

    class CallerIdWeb extends core.WebPlugin {
        async addContacts(options) {
            console.log('caller id plugin', options);
            return;
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        CallerIdWeb: CallerIdWeb
    });

    exports.CallerId = CallerId;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
