import jsPDF from "jspdf";
import q from "q";
import fs from "fs"; 
import path from 'path';

const imageDataUri = (file: string) => {
  
  const bitmap = fs.readFileSync(path.resolve(__dirname, file));
  // convert binary data to base64 encoded string
  return Buffer.from(bitmap).toString('base64');
    
}

const generatePlipPdf = async (unique_identifier: string, state : string): Promise<string> => {
  if (!unique_identifier) {
    const msg = 'Invalid unique_identifier'
  
    console.error(`Error: ${msg}`);
    throw new Error(msg);
  }
    
  const doc = new jsPDF('p', 'px', 'a4');
  const docWidth = doc.internal.pageSize.width;
  const docHeight = doc.internal.pageSize.height;
  const logoData = imageDataUri('./logo.jpg');
  doc.addImage(logoData, 'JPEG', 10, 5,56,48);

  doc.setFontSize(10);
  doc.setFont( "helvetica" ,"bold");
  doc.text( `Lista de Apoio ao Projeto de Lei de Iniciativa Popular nº13.567`,256,15, { align:'center' });
  doc.setFont( "helvetica", 'normal');
  doc.setFontSize(9.5);
  doc.text( `Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet
    dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit
    lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit.\nSaiba mais em www.sitedaplip.org`,256,25, { align:'center' });
  //doc.setFont( "helvetica" ,"bold");
  //doc.text( `www.sitedaplip.org`,45,51, { align:'center' });
  doc.setFontSize(6);
  doc.setFont( "helvetica", 'bold');
  doc.cell(10,60,(docWidth-20)/2,12,`ESTADO: ${state}`,0,'left');
  doc.cell((docWidth-20),60,(docWidth-20)/2,12,`MUNICIPIO:`,0,'left');
  doc.cell(10,100,90,5,``,1,'left');
  for (var i = 0; i < 10; i++) {
  doc.cell(10,110,(docWidth-120),18,`NOME:`,2,'left');
  doc.cell((docWidth-120),110,100,54,`ASSINATURA DIGITAL`,2,'right');
  doc.cell(10,134,(docWidth-120),18,``,2,'left');  
  doc.cell(10,134,(docWidth-120),18,`ENDEREÇO:`,3,'left');
  doc.cell(10,158,(docWidth-120)/4,18,`DATA DE NASCIMENTO: `,4,'left');
  doc.cell((docWidth-120)/4,158,(docWidth-120)-((docWidth-120)/4),18,`TITULO DE ELEITOR:`,4,'left');
  }
  //const formData =  imageDataUri('./plip-form.png');
 // doc.addImage(formData, 'PNG', 8, 80,432,540);
    
  /*for (var i = 3; i <= 10; i++) {
      doc.setFontSize(6);
      doc.cell(docWidth -100,100,90,50,`ASSINATURA OU IMPRESSÃO DIGITAL`,i,'left');
    }*/
  const deferred = q;
  doc.setFontSize(7);
  doc.setFont( "helvetica" ,"normal");
  doc.text( `${unique_identifier}`,10 , docHeight - 5);
  doc.text( `Enviar para: Nome do Destinatário, Av. N2 - Bloco 16, CEP 70165-900, DF`,docWidth -183 , docHeight - 5);
 
  return await deferred.resolve(doc.output('datauristring'));
}
export default generatePlipPdf;

