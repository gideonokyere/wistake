const {ethers,upgrades} = require("hardhat");

async function deployProxy(){
    const tokenAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
    const Wistake = await ethers.getContractFactory('Wistake');
    const wistake = await upgrades.deployProxy(Wistake,[tokenAddress]);
    await wistake.waitForDeployment();
    console.log("Contract address is: ",await wistake.getAddress());
}

deployProxy().catch((error)=>{
  console.log(error);
  process.exitCode = 1;
})