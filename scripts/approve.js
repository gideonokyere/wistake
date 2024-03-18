const { ethers } = require("hardhat");

async function approveWistake(){
  const stakeAddress = '0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9';
  const Witoken = await ethers.getContractFactory('Witoken');
  const token = await Witoken.attach('0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512');
  const amountToapprove = ethers.parseUnits('2000',18);
  await token.approve(stakeAddress,amountToapprove);
}

approveWistake().catch(e=>{
  console.log(e);
  process.exitCode = 1;
});