import {
  Action,
  Previous,
  Next,
  Resolver,
  IBaseActionArgs,
  IResolverData
} from '../../types';

export default <T extends any>(previous: Previous, action: Action, next: Next): Resolver =>
  async (_: void, args: IBaseActionArgs): Promise<IResolverData> => {
    /** Resolver function base */
    // Previous function process activist and widget
    const { activist, widget } = await previous(args);

    // Implementation action to resolve Widget
    const opts = { action: args.input, activist, widget };
    const { data, syncronize } = await action<T>(opts);

    // Post action to implement notify
    // Add data to insert PLIP attachment in post-action
    await next(opts, syncronize, data);

    // Resolve method
    return { data };
  }
;