const {loadFixture} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { ethers,upgrades } = require("hardhat");
const {expect} = require('chai');

describe('Witoken', function(){

  async function deployWitoken(){
    const [owner,user1,user2] = await ethers.getSigners();
    const Witoken = await ethers.getContractFactory('Witoken');
    const token = await upgrades.deployProxy(Witoken,[3000]);
    await token.waitForDeployment();
    return {token,owner,user1,user2};
  }

  describe('Deployment',async function(){

    it('should return token name',async function(){
      const {token} = await loadFixture(deployWitoken);
      expect(await token.name()).to.equal('Witoken');
    });

    it('should return symbol',async function(){
      const {token} = await loadFixture(deployWitoken);
      expect(await token.symbol()).to.equal('WIT');
    });

    it('should return total supply of token in circulation',async function(){
      const {token} = await loadFixture(deployWitoken);
      expect(await token.totalSupply()).to.equal(ethers.parseUnits("3000",18));
    });
  });

  describe('Transactions',async function(){
    it('Owner balance should be equal to initial balance',async function(){
      const {owner,token} = await loadFixture(deployWitoken);
      expect(await token.balanceOf(owner.address)).to.equal(ethers.parseUnits("3000",18));
    });

    it('Owner should send token to a user',async function(){
      const {token,user1} = await loadFixture(deployWitoken);
      await token.transfer(user1.address,100);
      expect(await token.balanceOf(user1.address)).to.equal(100);
    });
  });

  describe('Approval',async function(){
    it('User should not be able to approve an account',async function(){
      let {token,user1,user2} = await loadFixture(deployWitoken);
      owner = user1;
      expect(await token.approve(user2.address,200)).to.be.revertedWith('Only the owner can call this function');
    });

    it('Owner should be able to approve an account',async function(){
      const {token,owner,user1} = await loadFixture(deployWitoken);
      await token.approve(user1.address,200);
      expect(await token.allowance(owner.address,user1.address)).to.equal(200);
    });
  });

});