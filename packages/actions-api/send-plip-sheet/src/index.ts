import express from "express";
import generatePlipSheet from "./generate-file"; 
import uploadFileToS3 from "./upload-file";
const app = express();
app.use(express.json());
const PORT = process.env.PORT || 3000;
app.post('/plip-generate-file', async (req, res) => {

    const file = generatePlipSheet(req.body.input);
    await uploadFileToS3(file);
    return res.json({
      status: file
    })
  
  });

  app.listen(Number(PORT), "0.0.0.0", () => {
    console.log(`Server listen on port ${PORT}`);
  });