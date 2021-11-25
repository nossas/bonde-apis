import jsPDF from "jspdf";
import q from "q";
const generatePlipSheet = async (body: any) => {
    const name: string = `plip_sheet_${body.input.unique_identifier}.pdf`
    const doc = new jsPDF();
    const deferred  = q;
    
    doc.setFontSize(22);
    doc.text( `Plip sheet: ${body.input.unique_identifier}` ,20, 20);
    doc.save(name);
    const blob = await deferred.resolve(doc.output('datauristring'));
    
    return blob

    /* 
        fs.unlink(fileName, function (err){
            if (err) throw err;
            console.log('Arquivo deletado!');
        })
    */ 
}

export default generatePlipSheet;