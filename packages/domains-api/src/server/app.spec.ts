import app from "./app";
import request from "supertest";

describe("Test the root path", () => {
  it("should response the GET method", async () => {
    const response = await request(app).get("/");
    expect(response.statusCode).toBe(404);
  });
  it("should response the POST method to create certificate", async () => {
    const response = await request(app).post("/events/create-certificate");
    expect(response.statusCode).toBe(400);
  });
  it("should response the POST method to check certificate", async () => {
    const response = await request(app).post("/events/check-certificate");
    expect(response.statusCode).toBe(400);
  });
  // it("should response the POST method to check page", async () => {
  //   const response = await request(app).post("/actions/check-page");
  //   expect(response.statusCode).toBe(400);
  // });
});