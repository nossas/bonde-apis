import jsPDF from "jspdf";
import q from "q";
import logger from "../logger";
import { PlipInput, IActionData, IBaseAction } from '../types';
import * as ActionsAPI from '../graphql-api/actions';
import makeActionResolver from './action';
import { v4 as uuidv4 } from 'uuid';

const generatePlipSheet = async (unique_identifier: string): Promise<string> => {

  if (!unique_identifier) {
    const msg = 'Invalid unique_identifier'

    logger.error(`Error: ${msg}`);
    throw new Error(msg);
  }

  const doc = new jsPDF();
  const deferred = q;

  doc.setFontSize(22);
  doc.text(`Plip sheet: ${unique_identifier}`, 20, 20);

  return await deferred.resolve(doc.output('datauristring'));
}

export const create_plip = async ({ action, widget }: IBaseAction<PlipInput>): Promise<IActionData> => {
  
  const unique_identifier = uuidv4();
  const pdf_datauristring = await generatePlipSheet(unique_identifier);

  const { id , errors } = await ActionsAPI.plip({
    widget_id: widget.id,
    //activist_id: activist.id,
    //community_id: widget.block.mobilization.community.id,
    //mobilization_id: widget.block.mobilization.id,
    unique_identifier: uuidv4(),
    pdf_data: pdf_datauristring,
    form_data: JSON.stringify({name: action?.name,
      email: action?.email,
      state: action?.state,
      whatsapp: action?.whatsapp})
  });

  logger.child({ id, unique_identifier, errors } ).info('plip');

  return {
    data: { 
      plip_id: id, 
      //transforma pdf data para base64 para anexar ao email
      pdf_data: pdf_datauristring.replace("data:application/pdf;filename=generated.pdf;base64,", ""), 
      filename: `formulario_plip_${action?.name}.pdf` 
    },
  };
};

export default makeActionResolver(create_plip);