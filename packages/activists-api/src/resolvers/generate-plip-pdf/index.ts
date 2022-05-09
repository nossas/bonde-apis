import jsPDF from "jspdf";
import q from "q";
import QRCode from 'qrcode';
import { logo } from "./logo";

const generatePlipPdf = async (unique_identifier: string, state: string, expected_signatures: number): Promise<string> => {
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
  const formWidth = docWidth - (2 * margin);
  const cellSignatureWidth = 100;
  const cellSignatureHeight = 3 * cellHeight;
  const imgWidth = 48;
  const imgHeight = 48;

  //qrcode
  const uiQRCode = await QRCode.toDataURL(unique_identifier);

  const numberOfPages = expected_signatures / 10;
  for (let j = 0; j < numberOfPages; j++) {

    if (j > 0) {
      doc.cellAddPage();
    }

    //header
    doc.addImage(logo, 'JPEG', 10, 5, imgWidth, imgHeight);
    doc.addImage(uiQRCode, 'JPEG', (docWidth - margin - imgWidth), 5, imgWidth, imgHeight);
    doc.setFontSize(11);
    doc.setFont("helvetica", "bold");
    doc.text(`Projeto de Lei Amazônia de Pé`, 220, 13, { align: 'center' });
    doc.setFont("helvetica", 'normal');
    doc.setFontSize(9);
    doc.text(`Dispõe sobre a destinação de terras públicas cobertas por vegetação, a vedação do registro,
    suspensão de validade e inativação do Cadastro Ambiental Rural (CAR) de imóveis rurais em áreas
    protegidas e em florestas públicas não destinadas nas condições que especifica e dá outras providências.`, 220, 24, { align: 'center' });
    doc.setFont("helvetica", "bold");
    doc.text(`Saiba mais em amazoniadepe.org.br`, 220, 48, { align: 'center' });
    doc.setFontSize(6);
    doc.setFont("helvetica", 'normal');
    doc.cell(margin, 62, (formWidth / 2), 12, `ESTADO: ${state}`, 0, 'left');
    doc.cell(formWidth, 62, formWidth / 2, 12, `MUNICÍPIO:`, 0, 'left');
    doc.cell(margin, 100, 90, 5, ``, 1, 'left');

    //background color
    let top = 133;
    for (let i = 0; i < 5; i++) {
      doc.setFillColor(243, 243, 243)
      doc.rect(10, top, formWidth, cellSignatureHeight, "F");
      top = top + (2 * cellSignatureHeight);
    }

    let barTop = 133
    for (let i = 0; i < 10; i++) {
      doc.setFontSize(10);
      doc.text('            /            /            ', 10, barTop);
      barTop = barTop + 3 * cellHeight;

      doc.setFontSize(6);
      doc.cell(margin, 110, (formWidth - cellSignatureWidth),
        cellHeight, `NOME COMPLETO (Por extenso e legível, sem abreviar):`, 2, 'left');

      doc.cell((formWidth - cellSignatureWidth), 110, 100, cellSignatureHeight,
        `ASSINATURA OU IMPRESSÃO DIGITAL`, 2, 'right');
      doc.cell(margin, 134, (formWidth - cellSignatureWidth), cellHeight, ``, 2, 'left');

      doc.cell(margin, 134, (formWidth - cellSignatureWidth),
        cellHeight, `ENDEREÇO (Completo, legível, sem abreviar, com CEP):`, 3, 'left');

      doc.cell(margin, 158, (formWidth - cellSignatureWidth) / 4,
        cellHeight, `DATA DE NASCIMENTO:`, 4, 'center');

      doc.cell((formWidth - cellSignatureWidth) / 4, 158,
        (formWidth - cellSignatureWidth) - ((formWidth - cellSignatureWidth) / 2),
        cellHeight, `NÚMERO DO TÍTULO DE ELEITOR (Ou nome completo da mãe):`, 4, 'left');

      doc.cell((formWidth - cellSignatureWidth) - ((formWidth - cellSignatureWidth) / 2), 158,
        (formWidth - cellSignatureWidth) / 4,
        cellHeight, `WHATSAPP (Com DDD):`, 4, 'left');
    }

    //footer
    doc.setFontSize(7);
    doc.setFont("helvetica", "normal");
    doc.text(`${unique_identifier}`, 10, docHeight - 5);
    doc.text(`Enviar para: NOSSAS CIDADES, CAIXA POSTAL: 34033, CEP 22460970 - Rio de Janeiro RJ`, docWidth - 230, docHeight - 5);
  }

  const deferred = q;
  return await deferred.resolve(doc.output('datauristring'));
}

export default generatePlipPdf;

