import { generateJWT } from "./utils";

describe('generateJWT', () => {

  it('create a valid JWT', () => {
    const user = {
      id: 123,
      admin: false,
      is_admin: false,
    }
    const token = generateJWT(user);

    // console.log("JWT: ", token);
    expect(!!token).toBe(true);
  })
})