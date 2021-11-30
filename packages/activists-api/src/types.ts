export type Activist = {
  id: number
  email: string
  name: string
  first_name?: string
  last_name?: string
  phone?: string
  city?: string
  state?: string
};

export type ActivistPressure = {
  id: number
  created_at: string
  activist?: Activist
};

export type Community = {
  id: number
  name: string
  mailchimp_api_key?: string
  mailchimp_list_id?: string
  email_template_from?: string
};

export type Mobilization = {
  id: number
  name: string
  community: Community
};

export type Block = {
  mobilization: Mobilization
};

export type GroupTarget = {
  identify: string
  label: string
  targets: string[]
  email_subject?: string
  email_body?: string
}

export type Widget = {
  id: number
  settings: any
  kind: string
  block: Block
  pressure_targets?: GroupTarget[]
};

export type ActivistInput = {
  email: string
  name: string
  first_name?: string
  last_name?: string
  phone?: string
  city?: string
  state?: string
};

export type Field = {
  uid: string
  kind: string
  label: string
  placeholder: string
  required: boolean
  value: string
};

export type FormEntryInput = {
  fields: Field[]
}

export interface IBaseAction<T> {
  action?: T
  activist: Activist
  widget: Widget
}

export interface IBaseActionArgs {
  input?: any
  activist: ActivistInput
  widget_id: number
}

export interface IPreviousData {
  activist: Activist
  widget: Widget
}

export interface IActionData {
  data: any
  syncronize?: DoneAction
}

export interface IResolverData {
  data: any
}

export type DoneAction = () => Promise<any>;
export type Resolver = (_: void, args: IBaseActionArgs) => Promise<IResolverData>;
export type Previous = (args: IBaseActionArgs) => Promise<IPreviousData>;
export type Action = <T>(args: IBaseAction<T>) => Promise<IActionData>;
export type Next = <T>(args: IBaseAction<T>, done?: DoneAction, data?: any) => Promise<any>;