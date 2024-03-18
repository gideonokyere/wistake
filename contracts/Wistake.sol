// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "./Witoken.sol";

contract Wistake is Initializable, OwnableUpgradeable, ReentrancyGuardUpgradeable {

  error DepositFail(string errorMessage);
  error WithdrawalFailed(string errorMessage);
  error NoStakeFound(string errorMessage);

  event FundsDeposited(address indexed _from,address indexed _to,uint256 _amount);
  event TokenStake(uint _stakeId, address indexed _addr, uint _amount);
  event FundsTransfer(address indexed _to, uint256 _amount);
  event EndStake(uint _stakeId,uint _amount, address indexed _user);
  event PaymentRecieve(address indexed _from,uint256 _amount);
  event InterestRateChange(uint256 newRate);

  Witoken witoken;
  address payable public  _owner;
  uint private balance; // This variable is use to track the total ether recieved by the contract
  uint interestRate; // this is 

  struct Stake {
    uint stakeId;
    uint256 amount;
    uint256 dateTime;
    uint interestRate;
    bool isActive;
  }

  mapping(address=>Stake[]) public stakes;

  function initialize(Witoken _token) public initializer {
    witoken = _token;
    _owner = payable(msg.sender);
    interestRate = 12;
    __Ownable_init(msg.sender);
    __ReentrancyGuard_init();
  }

  receive() external payable {
    _depositFunds(msg.sender,msg.value);
    emit PaymentRecieve(msg.sender,msg.value);
  }

  fallback() external payable {
    _depositFunds(msg.sender,msg.value);
    emit PaymentRecieve(msg.sender,msg.value);
  }

  /**
   * @notice this function allows the owner of the contract to send token to a specific address
   * @param _to the address to send token to
   * @param _amount the amount of token to send
   */
  function sendToken(address _to, uint _amount) external nonReentrant onlyOwner returns (bool) {
    require(_amount > 0, "You should send more than zero ether");
    (bool success) = _depositFunds(_to,_amount);
    if(success){
      emit FundsDeposited(_owner,_to,_amount);
      return true;
    }else {
      revert DepositFail("Deposit failed");
    }
  }

  /**
   * @notice This function let the user to stake their tokens.
   * Users can stake as many as they want so far us they have enough tokens
   * @param _amount the amount the user is staking
   */
   function stakeToken(uint256 _amount) external nonReentrant returns (bool) {
    uint userBalance = witoken.balanceOf(msg.sender);
    require(userBalance >= _amount,"low balance");
    witoken.burnToken(msg.sender,_amount); // Didacting the amount from user's token balance
    uint stakeId = stakes[msg.sender].length;
    stakes[msg.sender].push(Stake({
        stakeId: stakeId,
        amount: _amount,
        dateTime: block.timestamp,
        interestRate: interestRate,
        isActive:true
    }));
    emit TokenStake(stakeId,msg.sender,_amount);
    return true;
   }



  /**
   *@notice this is a resuable function which allows users to deposit funds in exchange for token
   * @param _to the address to deposit the funds(token) to
   * @param _amount the amount of funds(token) recieving
   * @return bool
   */
  function _depositFunds(address _to, uint _amount) internal returns (bool) {
    witoken.transferFrom(_owner,_to,_amount);
    return true;
  }

  /**
   * @notice This function is used to withdraw funds from the contract
   * @notice only the owner of the contract can call this function
   * @param _to address to send funds to
   * @param _amount amount to send
   */
  function widthdrawFunds(address payable _to, uint256 _amount) external payable onlyOwner{
  require(_amount <= balance,"Low balance");
  balance -= _amount; // subtracting from the contract balance
  (bool sent,) = _to.call{value: _amount}("");
  require(sent,"Transaction not sent");
  emit FundsTransfer(_to,_amount);
 }

/**
 * @notice Return stakes an address owns.
 */
 function getStakes() external view returns (Stake[] memory) {
  return stakes[msg.sender];
 }



/**
 * @notice this function allows users to end a stake and get their token + interest
 * @notice interest is calculated base on the number of days the stake has been running
 * @param stakeId a particular stake the user wants to end
 */
function endStake(uint stakeId) external nonReentrant returns (bool){
  Stake storage stake = stakes[msg.sender][stakeId];
  require(stake.isActive != false,"Stake already ended");
  require(block.timestamp >= (stake.dateTime + 1 seconds),"You can end your stake after 1 second"); //
  uint256 interestToPay = _calculateStakeInterest(stake.interestRate,stake.dateTime,stake.amount);
  stake.isActive = false;
  _depositFunds(msg.sender,stake.amount+interestToPay);
  emit EndStake(stake.stakeId,stake.amount,msg.sender);
  return true;
}

/**
 * @dev this function calculate the interest a user will get base on the number of days stake runs
 * @param _interestRate - the interest rate of the stake
 * @param _dateTime - the number of days it has run
 * @param _amount - the amount the user invested
 */
function _calculateStakeInterest(uint256 _interestRate,uint256 _dateTime,uint256 _amount) internal view returns (uint256) {
  uint256 _period = block.timestamp - _dateTime / 1 seconds; // This will be set to days or months in a production.
  uint256 yield = (_amount * _interestRate) / 100;
  return yield * _period;
}

/**
 * @notice This function allows only the owner to change the interest rate;
 * @param _newRate - new interest rate value
 */
function changeInterest(uint64 _newRate) external onlyOwner{
  interestRate = _newRate;
  emit InterestRateChange(_newRate);
}

/**
 * @dev This function returns user's token balance
 */
function getTokenBalance() external view returns (uint256) {
  return witoken.balanceOf(msg.sender);
}


}
