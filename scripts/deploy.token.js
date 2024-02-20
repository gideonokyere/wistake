const {ethers,upgrades} = require("hardhat");

async function deployToken(){
    const Witoken = await ethers.getContractFactory("Witoken");
    const witoken = await upgrades.deployProxy(Witoken,[30000]);
    
    await witoken.waitForDeployment();
    tokenAddress = await witoken.getAddress();
    console.log("Token deployed at: ",tokenAddress);
};

deployToken().catch((error)=>{
    console.log(error);
    process.exitCode = 1;
})