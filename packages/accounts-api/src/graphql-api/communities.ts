import fetch from './client';

type Community = {
  id: number
  name: string
  city?: string
  image?: string
}

export const get = async (id: number): Promise<Community | undefined> => {
  const GetCommunity = `
    query Community ($id: Int!) {
      communities_by_pk(id: $id) {
        id
        name
        city
        image
      }
    }
  `;
  const { data }: any = fetch({ query: GetCommunity, variables: { id }});
  if (data && data.communities_by_pk) {
    return data.communities_by_pk
  }
}