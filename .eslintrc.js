module.exports = {
  env: {
    browser: false,
    es2021: true,
    mocha: true,
    node: true,
  },
  extends: ["plugin:prettier/recommended", "plugin:node/recommended"],
  parserOptions: {
    ecmaVersion: 12,
  },
  overrides: [
    {
      files: ["hardhat.config.js"],
      globals: { task: true },
    },
  ],
  rules: {
    "node/no-unpublished-require": "off",
    "node/no-extraneous-require": "off",
    "prettier/prettier": [
      "error",
      {
        projectDependencies: false,
        devDependencies: ["test/*", "**/*.test.jsx"],
        endOfLine: "auto",
      },
    ],
  },
};
