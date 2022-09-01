require('dotenv').config();
require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-etherscan');

const { TESTNET_RPC, PRIVATE_KEY, POLYGONSCAN_API_KEY } = process.env;

module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: TESTNET_RPC,
      accounts: [PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY
  }
};