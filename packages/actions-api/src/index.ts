import express from "express";
import logger from "./logger";
import generatePlipSheet from "./resolvers/generate_plip_sheet"; 

const app = express();
app.use(express.json());
const PORT = process.env.PORT || 3000;

app.post('/plip-generate-plip-sheet', async (req, res) => {
 
  if (!req.body.input) {
    logger.error(`Invalid request ${req.body}`);
    return res.status(404).json({ error: "Invalid request" });
  }     
  try{
    logger.info(`Generate file data for plip sheet ${JSON.stringify(req.body)}`);
    const file = await generatePlipSheet(req.body);
    
    return res.json({
      pdf_data: file
    })
  } catch(err){
    return res.status(500).json(`${err}`);
  } 

});

app.listen(Number(PORT), "0.0.0.0", () => {
  logger.info(`Server listen on port ${PORT}`);
});