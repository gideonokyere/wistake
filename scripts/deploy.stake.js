const {ethers,upgrades} = require("hardhat");

async function deployProxy(){
    const tokenAddress = "0x9d9454Fc6A1B911979B03507b4AcA17D0f75680A";
    const Wistake = await ethers.getContractFactory('Wistake');
    const wistake = await upgrades.deployProxy(Wistake,[tokenAddress]);
    await wistake.waitForDeployment();
    console.log("Contract address is: ",await wistake.getAddress());
}

deployProxy().catch((error)=>{
  console.log(error);
  process.exitCode = 1;
})