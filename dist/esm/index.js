import { registerPlugin } from '@capacitor/core';
const CallerId = registerPlugin('CallerId', {
    web: () => import('./web').then(m => new m.CallerIdWeb()),
});
export * from './definitions';
export { CallerId };
//# sourceMappingURL=index.js.map