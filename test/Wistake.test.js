const {loadFixture} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");
const {ethers,upgrades,network} = require("hardhat");

describe("Wistake",function(){

  async function deployWistake(){
    let deployObject;
    let wistakeAddress;
    let tokenAddress;

    const [owner,user1,user2,user3] = await ethers.getSigners();

    //This function will provide a private key to sign a transaction base on the address 
    async function signTx(address){
      await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [address],
      });
      const signer = await ethers.getSigner(address);
      return signer;
    }

    //Deploying Witoken
    const Witoken = await ethers.getContractFactory("Witoken");
    const witoken = await upgrades.deployProxy(Witoken,[30000]);
    
    await witoken.waitForDeployment();
    tokenAddress = await witoken.getAddress();
    console.log("Token deployed at: ",tokenAddress);

    //Deploying Wistake
    const Wistake = await ethers.getContractFactory('Wistake');
    const wistake = await upgrades.deployProxy(Wistake,[tokenAddress]);
    await wistake.waitForDeployment();
    console.log("Contract address is: ",await wistake.getAddress());
    const provider = await ethers.provider;
    wistakeAddress = await wistake.getAddress();
    return {wistake,owner,user1,user2,user3,provider,wistakeAddress,witoken,signTx};
  }

  this.beforeAll(async()=>{
    deployObject = await loadFixture(deployWistake);
  });

  describe('Deployment',async function(){
    it("Owner token balance should be equal to initial balance",async function(){
      const {owner,witoken} = deployObject;
      expect(await witoken.balanceOf(owner.address)).to.equal(ethers.parseUnits("30000"));
    });

    it("Owner should approve contract to spend token",async function(){
      const {witoken,owner,wistakeAddress} = deployObject;
      const amountApproved = ethers.parseUnits("20000",18);
      await witoken.approve(wistakeAddress,amountApproved);
      expect(await witoken.allowance(owner.address,wistakeAddress)).to.be.equal(amountApproved);
    });

    it("User should be able to trade ether for tokens",async function(){
      let {user1,wistakeAddress,witoken,signTx} = deployObject;
      const amountToSend = ethers.parseUnits("0.5",18);
      const signer = await signTx(user1.address);
      //Sending ether to the contract
      const tx = await signer.sendTransaction({
        from: signer.address,
        to: `${wistakeAddress}`,
        value: amountToSend
      });

      await tx.wait();
      expect(await witoken.balanceOf(user1.address)).to.be.equal(amountToSend);
    });

    it("Owner should be able to send token to a specific address",async function(){
      const {wistake,user2,witoken} = deployObject;
      const amountToSend = ethers.parseUnits("1",18);
      await wistake.sendToken(user2.address,amountToSend);
      expect(await witoken.balanceOf(user2.address)).to.be.equal(amountToSend);
    });

    it("User should be able to stake their tokens",async function(){
      let {owner,witoken,wistake} = deployObject;
      const balanceBefore = await witoken.balanceOf(owner.address);
      const amountToStake = ethers.parseUnits("0.2");
      await wistake.stakeToken(amountToStake);
      expect(await witoken.balanceOf(owner.address)).to.be.equal(balanceBefore-amountToStake);
    });

    it("Users show be able to see their stakes",async function(){
      let {wistake} = deployObject;
      const stakesLength = await wistake.getStakes()
      expect(stakesLength.length).to.be.gt(0);
    });

    it("User should end stake and cliam interest + principal",async function(){
      const {owner,wistake,witoken} = deployObject;
      const stakes = await wistake.getStakes();
      const stakeId = stakes[0].stakeId;
      await wistake.endStake(stakeId);
      const endStake = await wistake.getStakes();
      expect(endStake[0].isActive).to.be.false;
    });

    // it("User should not able to end inactive stake",async function(){
    //   const {wistake} = deployObject;
    //   const stakes = await wistake.getStakes();
    //   const stakeId = stakes[0].stakeId;
    //   //expect(await wistake.endStake(stakeId)).to.be.revertedWith("stake already ended");
    // });

  })

})