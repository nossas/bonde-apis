const mS3Instance = {
  upload: jest.fn().mockReturnThis(),
  promise: jest.fn(),
};

jest.mock('aws-sdk/clients/s3', () => {
  return  jest.fn(() => mS3Instance) ;
});

import uploadS3 from './upload_to_s3';

process.env.AWS_ACCESS_KEY = 'admin',
process.env.AWS_SECRET_KEY = 'admin',

describe('test uploadtoS3', () => {
  it('should send to upload correctly', async () => {

    mS3Instance.promise.mockResolvedValueOnce('ok');
    await uploadS3('data:application/pdf;filename=generated.pdf;base64,ok' , 'teste');
    expect(mS3Instance.upload).toBeCalledWith({ Bucket: 'plip-dev', Key: 'teste', Body: Buffer.from('ok','base64'), ContentType: "application/pdf" });
  });
});
