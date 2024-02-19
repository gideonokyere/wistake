require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
require('@primitivefi/hardhat-dodoc');
require('dotenv').config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks:{
    sepolia:{
      url:process.env.SEPOLIA_URL,
      accounts:[process.env.PRIVATE_KEY]
    }
  }
};
