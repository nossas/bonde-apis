import jsPDF from "jspdf";
import q from "q";
import QRCode from 'qrcode'; 
import { logo } from "./logo";

const generatePlipPdf = async (unique_identifier: string, state : string): Promise<string> => {
  if (!unique_identifier) {
    const msg = 'Invalid unique_identifier'
  
    console.error(`Error: ${msg}`);
    throw new Error(msg);
  }
    
  const doc = new jsPDF('p', 'px', 'a4');
  const docWidth = doc.internal.pageSize.width;
  const docHeight = doc.internal.pageSize.height;
  const margin = 10; 
  const cellHeight = 18;
  const formWidth = docWidth-(2*margin);
  const cellSignatureHeight = 100;
  const imgWidth = 56; 
  const imgHeight = 48;
   
  //qrcode
  const uiQRCode = await QRCode.toDataURL(unique_identifier); 
 
  //header
  doc.addImage(logo, 'JPEG', 10, 5,imgWidth,imgHeight);
  doc.addImage(uiQRCode, 'JPEG', (docWidth - margin - imgWidth), 5,imgWidth,imgHeight);
  doc.setFontSize(8.5);
  doc.setFont( "helvetica" ,"bold");
  doc.text( `Lista de Apoio ao Projeto de Lei de Iniciativa Popular nº13.567`,226,15, { align:'center' });
  doc.setFont( "helvetica", 'normal');
  doc.setFontSize(8);
  doc.text( `Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet
    dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit
    lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit.\nSaiba mais em www.sitedaplip.org`,226,25, { align:'center' });
  
  //form
  doc.setFontSize(6);
  doc.setFont( "helvetica", 'bold');
  doc.cell(margin,60,(formWidth/2),12,`ESTADO: ${state}`,0,'left');
  doc.cell(formWidth,60,formWidth/2,12,`MUNICÍPIO:`,0,'left');
  doc.cell(margin,100,90,5,``,1,'left');
  
  for (let i = 0; i < 10; i++) {
    doc.cell(margin,110,(formWidth-cellSignatureHeight),
      cellHeight,`NOME COMPLETO: (Por extenso e legível, sem abreviar)`,2,'left');
    
    doc.cell((formWidth-cellSignatureHeight ),110,100,54,
      `ASSINATURA OU IMPRESSÃO DIGITAL`,2,'right');
    doc.cell(margin,134,(formWidth-cellSignatureHeight),cellHeight,``,2,'left'); 

    doc.cell(margin,134,(formWidth-cellSignatureHeight),
      cellHeight,`ENDEREÇO: (Completo, legível, sem abreviar, com CEP)`,3,'left');

    doc.cell(margin,158,(formWidth-cellSignatureHeight)/4,
      cellHeight,`DATA DE NASCIMENTO: `,4,'left');

    doc.cell((formWidth-cellSignatureHeight)/4,158,
      (formWidth-cellSignatureHeight)-((formWidth-cellSignatureHeight)/4),
      cellHeight,`NÚMERO DO TÍTULO DE ELEITOR: (Ou nome completo da mãe)`,4,'left');
  }
  
  const deferred = q;
  
  //footer
  doc.setFontSize(7);
  doc.setFont( "helvetica" ,"normal");
  doc.text( `${unique_identifier}`,10 , docHeight - 5);
  doc.text( `Enviar para: Nome do Destinatário, Av. N2 - Bloco 16, CEP 70165-900, DF`,docWidth -183 , docHeight - 5);
 
  return await deferred.resolve(doc.output('datauristring'));
}
export default generatePlipPdf;

