// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract Witoken is Initializable, ERC20Upgradeable{

 address public owner;

  function initialize(uint initialSupply) public initializer {
      owner = msg.sender;
    __ERC20_init("Witoken","WIT");
    _mint(owner,initialSupply * (10 ** 18));
  }

  fallback() external payable{}
  receive() external payable{}

  function burnToken(address _account,uint256 _amount) external returns (bool) {
    _burn(_account,_amount);
    return true;
  }

}