import config from "../../config";
import S3 from 'aws-sdk/clients/s3';
import logger from "../../logger";

const uploadS3 = async (file: any, fileName: string) => {
  console.log(config.awsAccessKey)
  const s3 = new S3({
    accessKeyId: config.awsAccessKey,
    secretAccessKey: config.awsSecretKey,
    endpoint: config.awsEndpoint,
    sslEnabled: false,
    s3ForcePathStyle: true
  });
  
  const uploadFile = Buffer.from(file.replace("data:application/pdf;filename=generated.pdf;base64,", ""), 'base64');

  const uploadParams = {
    Bucket: config.awsBucket,
    Key: fileName,
    Body: uploadFile,
    ContentType: "application/pdf"
  };

  try {
    const data = await s3.upload(uploadParams).promise();
    logger.info(`Upload Success! ${data.Location}`)
    return data.Location;
  } catch (err) {
    logger.error(`Upload Failed! ${err}`)
    throw new Error(`${err}`);
  }
}

export default uploadS3;
