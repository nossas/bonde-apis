import express from "express";
import generatePlipSheet from "./generate-file"; 

const app = express();
app.use(express.json());
const PORT = process.env.PORT || 3000;
app.post('/plip-generate-file', async (req, res) => {

    const file = await generatePlipSheet(req.body);
    
    return res.json({
      blob: file
    })
  
  });

  app.listen(Number(PORT), "0.0.0.0", () => {
    console.log(`Server listen on port ${PORT}`);
  });