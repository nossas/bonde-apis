import jsPDF from "jspdf";
import q from "q";
const generatePlipSheet = async (body: any) => {
    const doc = new jsPDF();
    const deferred  = q;
    
    doc.setFontSize(22);
    doc.text( `Plip sheet: ${body.input.unique_identifier}` ,20, 20);
    const file_data: string = await deferred.resolve(doc.output('datauristring'));
    
    return file_data
}

export default generatePlipSheet;