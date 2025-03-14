import jsPDF from "jspdf";
import q from "q";
import QRCode from "qrcode";
import { logo } from "./logo";
import { bois } from "./bois";
import uploadS3 from "./upload_to_s3";
import { arrow } from "./arrow";

interface pdfData {
  datauristring: string;
  url?: any;
}

const generatePlipPdf = async (
  unique_identifier: string,
  name: string,
  isBoisWidget: boolean
): Promise<pdfData> => {
  if (!unique_identifier) {
    const msg = "Invalid unique_identifier";

    console.error(`Error: ${msg}`);
    throw new Error(msg);
  }

  const doc = new jsPDF("p", "px", "a4");
  const docWidth = doc.internal.pageSize.width;
  const docHeight = doc.internal.pageSize.height;
  const margin = 10;
  const cellHeight = 18;
  const formWidth = docWidth - 2 * margin;
  const cellSignatureWidth = 100;
  const cellSignatureHeight = 3 * cellHeight;
  const imgWidth = 48;
  const imgHeight = 48;

  //qrcode
  const uiQRCode = await QRCode.toDataURL(unique_identifier);

  //header
  doc.setFontSize(7);
  doc.setFont("helvetica", "normal");
  doc.text(
    `Enviar para: NOSSAS CIDADES, CAIXA POSTAL: 34033, CEP 22460970 - Rio de Janeiro RJ`,
    docWidth - 230,
    8
  );
  doc.addImage(isBoisWidget ? bois : logo, "JPEG", 10, 10, imgWidth, imgHeight);
  doc.addImage(
    uiQRCode,
    "JPEG",
    docWidth - margin - imgWidth,
    12,
    imgWidth,
    imgHeight
  );
  doc.setFontSize(10.8);
  doc.setFont("helvetica", "bold");
  doc.text(`Projeto de Lei Amazônia de Pé`, 220, 20, { align: "center" });
  doc.setFont("helvetica", "normal");
  doc.setFontSize(8.8);
  doc.text(
    `Dispõe sobre a destinação das terras públicas cobertas por florestas ou outras formas de vegetação na
  Amazônia Legal, priorizando a conservação ambiental e a justiça social, determina a vedação e inativação do
  registro no Sistema de Cadastro Ambiental Rural (Sicar) nas situações que especifica, e dá outras providências.`,
    220,
    31,
    { align: "center" }
  );
  doc.setFont("helvetica", "bold");
  doc.text(`Saiba mais em amazoniadepe.org.br`, 220, 54, { align: "center" });

  doc.cell(margin, 62, 90, 5, ``, 1, "left");

  //background color
  let top = 121;
  for (let i = 0; i < 5; i++) {
    doc.setFillColor(243, 243, 243);
    doc.rect(10, top, formWidth, cellSignatureHeight, "F");
    top = top + 2 * cellSignatureHeight;
  }

  let barTop = 121;
  let arrowTop = 69;
  for (let i = 0; i < 10; i++) {
    doc.setFontSize(10);
    doc.setFont("helvetica", "bold");
    doc.text("         /         /         ", 110, barTop - 18);
    doc.setFont("helvetica", "normal");
    doc.setFontSize(5);
    doc.text("(ASSINATURA OU IMPRESSÃO DIGITAL)", 23, barTop - 3);
    doc.setFont("helvetica", "normal");
    doc.setFontSize(6);
    // doc.text("(OU NÚMERO DO TÍTULO DE ELEITOR):", 239, barTop - 11.5);

    // ArrowIcon
    doc.addImage(arrow, 'JPEG', 75, arrowTop, 5, 6);
    doc.addImage(arrow, 'JPEG', 36, arrowTop, 5, 6);
    barTop = barTop + 3 * cellHeight;
    arrowTop = cellSignatureHeight + arrowTop;

    doc.setFontSize(6);
    doc.setFont("helvetica", "bold");
    doc.cell(
      margin,
      134,
      100,
      cellSignatureHeight,
      `                        ASSINE AQUI`,
      2,
      "left"
    );

    doc.setFont("helvetica", "bold");
    doc.setFontSize(5);

    doc.setFontSize(6);
    doc.cell(
      margin,
      110,
      formWidth - cellSignatureWidth,
      cellHeight,
      `NOME COMPLETO (Por extenso e legível, sem abreviar):`,
      2,
      "right"
    );
    doc.cell(
      margin,
      134,
      formWidth - cellSignatureWidth,
      cellHeight,
      "",
      2,
      "left"
    );

    doc.setFont("helvetica", "normal");

    doc.cell(
      cellSignatureWidth + margin,
      158,
      (formWidth - cellSignatureWidth) / 5,
      cellHeight,
      `DATA DE NASCIMENTO:`,
      4,
      "center"
    );

    
    doc.cell(
      (formWidth - cellSignatureWidth) / 4,
      158,
      formWidth - cellSignatureWidth - (formWidth - cellSignatureWidth) / 5,
      cellHeight,
      "NOME COMPLETO DA MÃE:",
      4,
      "center"
    );

    doc.cell(
      cellSignatureWidth + margin,
      134,
      (formWidth - cellSignatureWidth) / 1.5,
      cellHeight,
      `CIDADE:`,
      3,
      "right"
    );

    doc.cell(
      cellSignatureWidth + margin,
      134,
      (formWidth - cellSignatureWidth) / 3,
      cellHeight,
      `ESTADO:`,
      3,
      "right"
    );
  }

  //footer
  doc.setFontSize(7);
  doc.setFont("helvetica", "normal");
  doc.text(`${unique_identifier}`, 10, docHeight - 5);

  const deferred = q;
  const file = await deferred.resolve(doc.output("datauristring"));
  // console.log("FILEEE", file)
  const url = await uploadS3(`${file}`, `${name}-${unique_identifier}.pdf`);
  return {
    datauristring: file,
    url,
  };
};

export default generatePlipPdf;
