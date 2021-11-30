import jsPDF from "jspdf";
import q from "q";
import logger from "../logger";
import { Plip } from '../plip'

const generatePlipSheet = async (body: Plip): Promise<string> => {

  if (!body.unique_identifier) {
    const msg = 'Invalid unique_identifier'

    logger.error(`Error: ${msg}`);
    throw new Error(msg);
  }

  const doc = new jsPDF();
  const deferred = q;

  doc.setFontSize(22);
  doc.text(`Plip sheet: ${body.unique_identifier}`, 20, 20);

  return await deferred.resolve(doc.output('datauristring'));
}

export default generatePlipSheet;