import { IBaseAction } from '../../types';
import pipeline from './pipeline';
import previous from './previous';
import next from './next';

// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
export default <T>(fn: (args: IBaseAction<any>) => Promise<any>) =>
  pipeline<T>(previous, fn, next)
;