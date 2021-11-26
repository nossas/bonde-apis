import jsPDF from "jspdf";
import q from "q";
import logger from "../logger";
const generatePlipSheet = async (body: any) => {
    
    if(!body.input.unique_identifier){
        const msg = 'Invalid unique_identifier'
        logger.error(`Error: ${msg}`);
        throw new Error(msg);
    }
    
    const doc = new jsPDF();
    const deferred  = q;
    
    doc.setFontSize(22);
    doc.text( `Plip sheet: ${body.input.unique_identifier}` ,20, 20);
    const data: string = await deferred.resolve(doc.output('datauristring'));
    return data
}

export default generatePlipSheet;