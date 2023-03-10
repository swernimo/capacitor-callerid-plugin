import { registerPlugin } from '@capacitor/core';

import type { CallerIdPlugin } from './definitions';

const CallerId = registerPlugin<CallerIdPlugin>('CallerId', {
  web: () => import('./web').then(m => new m.CallerIdWeb()),
});

export * from './definitions';
export { CallerId };
