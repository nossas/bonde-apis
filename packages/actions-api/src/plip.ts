import clientGraphql from "./clientGraphql";
import logger from "./logger";

export interface ActionPlipSheetInput {
  widget_id: number
  community_id: number
  mobilization_id: number
  name: string
  email: string
  state: string
  whatsapp: string
}

export interface PlipInput {
  widget_id: number
  community_id?: number
  mobilization_id?: number
  form_data: string
  }

export interface Plip {
    id: number
    unique_identifier: string
    form_data: string
  }

const queryInsertPlip = `mutation InsertPlip($plip: plips_insert_input!) {
  insert_plips_one(object: $plip) {
    id
    unique_identifier
  }
}
`
const queryUpdatePlip = `mutation UpdatePlipPdfData($id: Int!, $pdf_data: bytea) {
  update_plips(where: {id: {_eq: $id}}, _set: {pdf_data: $pdf_data}) {
    returning {
        id
        unique_identifier
        form_data
    }
  }
}`

export const plipCreate = async (input: ActionPlipSheetInput): Promise<Plip> => {

    const plip: PlipInput = {
      widget_id: input.widget_id,
      //community_id: input.community_id,
      //mobilization_id: input.mobilization_id,
      form_data: JSON.stringify({name: input.name,
        email: input.email,
        state: input.state,
        whatsapp: input.whatsapp})
    }
    const { data, errors } = await clientGraphql({
      query: queryInsertPlip,
      variables: { plip }
    });
  
    logger.child({ data, errors }).info('plip');
    return data.insert_plips_one;
  };
  
  export const plipUpdate = async (id: number, pdf_data: string): Promise<Plip> => {
    const { data, errors } = await clientGraphql({
      query: queryUpdatePlip,
      variables: { id, pdf_data }
    });
  
    logger.child({ data, errors }).info('update pdf data plip');
    return data.update_plips.returning[0];
  };