import fetch from './client';

export const UserFilterQuery =`
  query users ($where: users_bool_exp!) {
    users (where: $where) {
      id
      email
      first_name
      last_name
      admin
      is_admin
      encrypted_password
      reset_password_token
    }
  }
`

type User = {
  first_name: string
}

export const find = async (params: any): Promise<User[]> => {
  let where = {}
  Object.keys(params).forEach((field) => {
    where = Object.assign(where, { [field]: { _eq: params[field] } })
  })
  const resp = await fetch({ query: UserFilterQuery, variables: { where } });
  
  return resp.data.users
}