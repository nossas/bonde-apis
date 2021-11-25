import PDFDocument from "pdfkit"; 
import fs from "fs";
const generatePlipSheet = (body: any) => {
    const name = `plip_sheet_${body.unique_identifier}.pdf`
    const doc = new PDFDocument();
    
    doc
    .fontSize(25)
    .text(`Plip Sheet: ${body.unique_identifier}`, 100, 100);
    doc.end();
    doc.pipe(fs.createWriteStream(`plip_sheet_${body.unique_identifier}.pdf`)); 
    return name; 
}

export default generatePlipSheet;

