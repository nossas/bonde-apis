import jsPDF from "jspdf";
import q from "q";
import logger from "../logger";

interface BodyInput {
  input: {
    unique_identifier: string
  }
}

const generatePlipSheet = async (body: BodyInput): Promise<string> => {

  if (!body.input.unique_identifier) {
    const msg = 'Invalid unique_identifier'

    logger.error(`Error: ${msg}`);
    throw new Error(msg);
  }

  const doc = new jsPDF();
  const deferred = q;

  doc.setFontSize(22);
  doc.text(`Plip sheet: ${body.input.unique_identifier}`, 20, 20);

  return await deferred.resolve(doc.output('datauristring'));
}

export default generatePlipSheet;