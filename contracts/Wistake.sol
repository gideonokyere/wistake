// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Wistake is Initializable, AccessControlUpgradeable, OwnableUpgradeable {

  error DepositFail(bytes errorMessage);
  event FundsDeposited(address indexed _from,address indexed _to,uint256 _amount);
  event TokenStake(uint stakeId, address indexed addr, uint _amount);

  IERC20 witoken;
  address private _owner;
  address private constant approvedAddress = 0x1533515803e27B20A2A7aACbE5eb7eAEA63eC54D;
  uint private balances; // This variable is use to track the total balance recieved by the contract
  uint interestRate = 12;

  struct Stake {
    uint stakeId;
    uint amount;
    uint256 dateTime;
    uint interestRate;
  }

  mapping(address=>Stake[]) public stakes;

  function initialize(IERC20 _token) public initializer {
    witoken = _token;
    _owner = msg.sender;
    _grantRole(DEFAULT_ADMIN_ROLE,msg.sender);
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
  function depositFunds(address _to, uint _amount) external payable returns (bool) {
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
   function stakeToken(uint _amount) external returns (bool) {
    uint userBalance = witoken.balanceOf(msg.sender);
    require(userBalance > _amount,"low balance");
    uint stakeId = stakes[msg.sender][stakes[msg.sender].length - 1].stakeId;
    stakes[msg.sender].push(Stake({
        stakeId: stakeId,
        amount: _amount,
        dateTime: block.timestamp,
        interestRate: interestRate
    }));
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
    balances+=_amount;
    witoken.transferFrom(_from,_to,_amount);
    return true;
  }
}
