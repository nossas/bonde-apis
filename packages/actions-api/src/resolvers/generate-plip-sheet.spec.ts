import generatePlipSheet from "./generate_plip_sheet"

describe("generate data file with unique_identifier", () => {

  const body = {
      email: "teste@email.com",
      state: "",
      form_data: "",
      unique_identifier: '0b30ce76-f321-4c71-9168-b6bc98d843ee'
    
  }
  it("should return file data", async () => {
    const data = await generatePlipSheet(body);
    expect(data).toBeDefined;
  });
  /* const body2 = {
       input :{
           
       }
   }
  /* it("should return error", async () => {
       const data = await generatePlipSheet(body2);
       expect(data).toThrowError('Invalid unique_identifier');
   });*/

});