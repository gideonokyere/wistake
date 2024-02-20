require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
require('@primitivefi/hardhat-dodoc');
require("@nomicfoundation/hardhat-verify");
require('dotenv').config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks:{
    sepolia:{
      url:process.env.SEPOLIA_URL,
      accounts:[process.env.SECRET_KEY]
    }
  },
  etherscan: {
    apiKey:process.env.ETHERSCAN
  },
  sourcify: {
    enabled: true
  }
};
