import express from "express";
import logger from "./logger";
import clientGraphql from "./clientGraphql";
import generatePlipSheet from "./resolvers/generate_plip_sheet";

const app = express();
app.use(express.json());
const PORT = process.env.PORT || 3000;

const queryInsertPlip = `insert_plips(objects: {form_data: ""}) {
  returning {
    unique_identifier
  }
}`

export interface Plip {
  email: string
  state: string
  unique_identifier: string
  form_data: string
}

const plipCreate = async (input: Plip): Promise<Plip> => {
  const { data, errors } = await clientGraphql({
    query: queryInsertPlip,
    variables: { input }
  });

  logger.child({ data, errors }).info('plip');
  return data.insert_plips.returning[0];
};

app.post('/plip-generate-sheet', async (req, res) => {

  if (!req.body.input) {
    logger.error(`Invalid request ${req.body}`);
    return res.status(404).json({ error: "Invalid request" });
  }

  try {
    const plipCreated: Promise<Plip> = plipCreate(req.body.input)
    logger.info(`Generate file data for plip sheet ${JSON.stringify(req.body)}`);
    const data = await generatePlipSheet(await plipCreated);

    return res.json({
      pdf_data: data
    })
  } catch (err) {
    return res.status(500).json(`${err}`);
  }
});

app.listen(Number(PORT), "0.0.0.0", () => {
  logger.info(`Server listen on port ${PORT}`);
});