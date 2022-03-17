import app from "./app";
import request from "supertest";

describe("Test the root path", () => {
  it("should response the GET method", async () => {
    const response = await request(app).get("/");
    expect(response.statusCode).toBe(404);
  });
  it("should response the POST method to create certificate", async () => {
    const response = await request(app).post("/events/create_certificate");
    expect(response.statusCode).toBe(200);
  });
  it("should response the POST method to check certificate", async () => {
    const response = await request(app).post("/actions/check_certificate");
    expect(response.statusCode).toBe(200);
  });
  it("should response the POST method to check page", async () => {
    const response = await request(app).post("/actions/check_page");
    expect(response.statusCode).toBe(200);
  });
});