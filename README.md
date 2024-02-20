# wistake
*An upgradable staking contract that allows its users to stake the little Ether they have for a profit and also contribute to the Ethereum network.*

#### Note
These contracts are deployed on the the sepolia test network 

### Contract Address
- [Witoken](https://sepolia.etherscan.io/address/0x9d9454Fc6A1B911979B03507b4AcA17D0f75680A)
- [Wistake](https://sepolia.etherscan.io/address/0xD1d78A522CAe039a9E124834E1a6f64bf0d3C403)

## How it works
Wistake uses its own native token for staking called Witoken. When a user wants to stake, all they have to do is to send an ether to the contract and in return, they will get the exact amount they sent to the contract. For example if a user sends 1 Ether, they will get 1 Witoken(WIT). Users can only stake with Witoken.
Users have 100% control on their token. They decide when to stake and when to cash out, and they can also trade token with other users on the platform. You can start earning interest only when you stake your token.

## How to test the contract
1. clone the contract repository by running the following command `git clone https://github.com/gideonokyere/wistake.git` .
2. cd into the directory of the wistake by running `cd DIRECTORY_NAME` .
3. run `npm install`. This will install all the required dependancies.
4. run `npx hardhat test`. You should see all test cases passing.

## How to deploy the contract locally
1. Open a brandnew terminal and make sure you are still in the root directory of the project.
2. run `npx hardhat node`. You should see a list of accounts listed on the console.
3. Leave the node running and return to the old termenal and do the following.
  - First, deploy the token contract by running this command `npx hardhat run --network localhost ./scripts/deploy.token.js`.
    if everything goes well, you should see the deployed token address on the console.
  - Next, deploy wistake contract with this command `npx hardhat run --network localhost ./scripts/deploy.stake.js` and you should see the address of the the contract on the console.

## How to Interact with the contract locally
1. Run `npx hardhat console --network local` on your terminal
2. Copy and paste this `const Witoken = await ethers.getContractFactory("Witoken");` and hit enter.
3. Copy and paste this `const token = await Witoken.attach('TOKEN CONTRACT ADDRESS');` you should pass in the token aadress.
4. We should approve wistake contract to spend tokens on behave of this token contract so
   copy and paste the following code `token.approve('WISTAKE CONTRACT ADDRESS',20000)`

You can also interact with wistake contract since we have approved it to spend some token.
You can send ether to wistake and in return, you will get Witoken(WIT).

For more info on wistake functions, follow this link [Wistake Docs]()