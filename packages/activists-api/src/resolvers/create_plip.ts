import logger from "../logger";
import { PlipInput, IActionData, IBaseAction } from '../types';
import * as ActionsAPI from '../graphql-api/actions';
import makeActionResolver from './action';
import crypto from 'crypto';
import generatePlipPdf from './generate-plip-pdf';

export const create_plip = async ({ action, widget }: IBaseAction<PlipInput>): Promise<IActionData> => {

  const boisWidgetId = 79520; // id da plip https://www.odesafiodosbumbas.com/
  const isBoisWidget = widget.id === boisWidgetId;
  const name = action?.name || ''
  const state = action?.state || '';
  const expected_signatures = action?.expected_signatures || 10;
  const unique_identifier = crypto.createHash("sha1").update(`${action?.email}${state}${expected_signatures}` || '').digest("hex");
  const pdf_data = await generatePlipPdf(unique_identifier, name, isBoisWidget);


  const { id, errors } = await ActionsAPI.plip({
    widget_id: widget.id,
    //activist_id: activist.id,
    cached_community_id: widget.block.mobilization.community.id,
    mobilization_id: widget.block.mobilization.id,
    unique_identifier: unique_identifier,
    pdf_data: pdf_data.url,
    expected_signatures: expected_signatures,
    state: state,
    form_data: action || {}
  });

  logger.child({ id, unique_identifier, errors }).info('plip');

  return {
    data: {
      plip_id: id,
      //transforma pdf data para base64 para anexar ao email
      pdf_data: pdf_data,
      filename: `${action?.name}.pdf`
    },
  };
};

export default makeActionResolver(create_plip);
