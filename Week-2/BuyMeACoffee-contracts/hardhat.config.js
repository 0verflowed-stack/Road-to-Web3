require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

const { GOERLI_URL, PRIVAT_KEY } = process.env;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    goerli: {
      url: GOERLI_URL,
      accounts: [`0x${PRIVAT_KEY}`]
    }
  }
};
