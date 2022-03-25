// eslint-disable-next-line no-undef
module.exports = {
  coverageReporters: ["lcov", "text-summary"],
  // roots: [
  //   "<rootDir>/packages/accounts-api/src",
  //   "<rootDir>/packages/activists-api/src",
  //   "<rootDir>/packages/domains-api/src",
  //   "<rootDir>/packages/notifications/src",
  //   "<rootDir>/packages/payments-api/src",
  //   "<rootDir>/packages/redes-api/src",
  // ],
  testMatch: [
    "**/__tests__/**/*.+(ts|tsx|js)",
    "**/?(*.)+(spec|test).+(ts|tsx|js)",
  ],
  transform: {
    "^.+\\.(js|jsx|ts|tsx)$": "ts-jest",
  },
  moduleNameMapper: {
    // Handle CSS imports (with CSS modules)
    // https://jestjs.io/docs/webpack#mocking-css-modules
    "^.+\\.(css|sass|scss)$": "identity-obj-proxy",

    // Handle image imports
    // https://jestjs.io/docs/webpack#handling-static-assets
    "^.+\\.(jpg|jpeg|png|gif|webp|avif|svg)$": `<rootDir>/__mocks__/style.js`,
  },
  transformIgnorePatterns: [
    "/node_modules/",
    "^.+\\.module\\.(css|sass|scss)$",
  ],
  //   testPathIgnorePatterns: [
  //   ],
  //   setupFilesAfterEnv: ["<rootDir>/packages/webpage-client/src/setupTests.ts"],
};
