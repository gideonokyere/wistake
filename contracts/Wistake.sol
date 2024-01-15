// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Wistake is Initializable, OwnableUpgradeable, ReentrancyGuardUpgradeable {

  error DepositFail(string errorMessage);
  error WithdrawalFailed(string errorMessage);
  error NoStakeFound(string errorMessage);

  event FundsDeposited(address indexed _from,address indexed _to,uint256 _amount);
  event TokenStake(uint _stakeId, address indexed _addr, uint _amount);
  event FundsTransfer(address indexed _to, uint256 _amount);
  event EndStake(uint _stakeId,uint _amount, address indexed _user);

  IERC20 witoken;
  address private approvedAddress; // the address to spend tokens on behave
  address public _owner;
  uint private balance; // This variable is use to track the total balance recieved by the contract
  uint interestRate = 12; // this is 
  uint private constant year = 365; // the interest on stake is calculated base on this value;

  struct Stake {
    uint stakeId;
    uint amount;
    uint256 dateTime;
    uint interestRate;
    bool isActive;
  }

  mapping(address=>Stake[]) public stakes;

  function initialize(IERC20 _token, address _approvedAddress ) public initializer {
    witoken = _token;
    _owner = msg.sender;
    approvedAddress = _approvedAddress;
    __Ownable_init(msg.sender);
    __ReentrancyGuard_init();
  }

  receive() external payable {
    require(msg.value > 0, "You should send more than zero ether");
    _depositFunds(approvedAddress,msg.sender,msg.value);
    emit FundsDeposited(approvedAddress,msg.sender,msg.value);
  }

  /**
   * this function allows users to deposit funds to a specific address
   * @param _to the address to deposit funds to
   * @param _amount the amount of funds to deposit
   */
  function depositFunds(address payable _to, uint _amount) external payable nonReentrant returns (bool) {
    require(_amount > 0, "You should send more than zero ether");
    (bool success) = _depositFunds(approvedAddress,_to,_amount);
    if(success){
      emit FundsDeposited(approvedAddress,_to,_amount);
      return true;
    }else {
      revert DepositFail("Deposit failed");
    }
  }

  /**
   * This function let the user to stake their tokens.
   * Users can stake as many as they want so far us they have enough tokens
   * @param _amount the amount the user is staking
   */
   function stakeToken(uint _amount) external nonReentrant returns (bool) {
    uint userBalance = witoken.balanceOf(msg.sender);
    require(userBalance > _amount,"low balance");
    uint stakeId = stakes[msg.sender][stakes[msg.sender].length - 1].stakeId;
    stakes[msg.sender].push(Stake({
        stakeId: stakeId,
        amount: _amount,
        dateTime: block.timestamp + 1 days,
        interestRate: interestRate,
        isActive:true
    }));
    witoken.transfer(approvedAddress,_amount); // sending the token back.
    emit TokenStake(stakeId,msg.sender,_amount);
    return true;
   }

  /**
   * this is a resuable function which allows users to deposit funds in exchange for token
   * @param _from the address sending the funds(token)
   * @param _to the address to deposit the funds(token) to
   * @param _amount the amount of funds(token) recieving
   */
  function _depositFunds(address _from, address _to, uint _amount) internal returns (bool) {
    balance+=_amount;
    witoken.transferFrom(_from,_to,_amount);
    return true;
  }

  /**
   * This function is used to withdraw funds from the contract
   * @notice only the owner of the contract can call this function
   * @param _to address to send funds to
   * @param _amount amount to send
   */
  function widthdrawFunds(address payable _to, uint256 _amount) external payable onlyOwner returns (bool){
  if(_amount > balance){
    revert WithdrawalFailed("low balance");
  }
  balance -= _amount; // subtracting from the contract balance
  (bool sent,) = _to.call{value: _amount}("");
  require(sent);
  emit FundsTransfer(_to,_amount);
  return true;
 }

/**
 * Return stakes an address owns.
 */
 function getStakes() external view returns (Stake[] memory) {
  return stakes[msg.sender];
 }

/**
 * this function allows users to end a stake and get their token + interest
 * interest is calculated base on the number of days the stake has been running
 * @param stakeId a particular stake the user wants to end
 */
function endStake(uint stakeId) external nonReentrant returns (bool){
  Stake memory stake = _getUserStake(stakeId);
  require(stake.isActive == true,"stake already ended");
  require(stake.dateTime > 1 days,"You can end your stake in 24 hours time");
  uint interestToPay = _calculateStakeInterest(stake.interestRate,stake.dateTime,stake.amount);
  stake.isActive = false;
  _depositFunds(approvedAddress,msg.sender,stake.amount+interestToPay);
  emit EndStake(stake.stakeId,stake.amount,msg.sender);
  return true;
}

// Get stake by it Id.
function _getUserStake(uint _stakeId) internal view returns (Stake memory){
  address _user = msg.sender;
  Stake memory _stake;
  uint stakeLength = stakes[_user].length;
  for(uint i=0; i<stakeLength;i++){
    if(stakes[_user][i].stakeId == _stakeId){
      _stake = stakes[_user][i];
    }else {
      revert NoStakeFound("Stake not found");
    }
  }
  return _stake;
}

/**
 * this function calculate the interest a user will get base on the number of days stake runs
 * @param _interestRate - the interest rate of the stake
 * @param _dateTime - the number of days it has run
 * @param _amount - the amount the user invested
 */
function _calculateStakeInterest(uint _interestRate,uint _dateTime,uint _amount) internal pure returns (uint) {
  (bool isDiv,uint _daysInterest) = Math.tryDiv( _interestRate, year); // this gives us the percentage for each day
  require(isDiv,"Division failed");
  (bool isMul,uint _ratePercentage) = Math.tryMul(_daysInterest, _dateTime);
  require(isMul,"Multiplication failed");
  return _ratePercentage * _amount;
}
}
