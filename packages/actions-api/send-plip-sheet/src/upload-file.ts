import fs from "fs";
import path from "path";
import config from "./config";
import S3 from 'aws-sdk/clients/s3';
const uploadFileToS3 = async (fileName: string) => {
    console.log(config.awsAccessKey)
    const s3 = new S3({
      accessKeyId: config.awsAccessKey,
      secretAccessKey: config.awsSecretKey,
      endpoint: config.awsRouteIp,
      sslEnabled: false,
      s3ForcePathStyle: true
      
    });
    const filePath = path.resolve('./', fileName);
    console.log(filePath);
    const file = await fs.promises.readFile(filePath);
    let url: any;
    const  uploadParams = {Bucket: "plip", Key: fileName, Body: file}; 
  
    s3.upload(uploadParams, function (err: Error, data: any) {
    console.log('cheguei');
    if (err) {
      console.log("Upload Error", err);
    } if (data) {
      //TO DO ATUALIZA CAMPO NA TABELA PLIP 
      console.log("Upload Success", data.Location);
    }
  });
   
    if(url) {
        console.log(url)
        fs.unlink(fileName, function (err){
            if (err) throw err;
            console.log('Arquivo deletado!');
        })
    }

} 

export default uploadFileToS3;