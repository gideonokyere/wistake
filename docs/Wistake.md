# Wistake









## Methods

### _owner

```solidity
function _owner() external view returns (address payable)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address payable | undefined |

### changeInterest

```solidity
function changeInterest(uint256 _newRate) external nonpayable
```

This function allows only the owner to change the interest rate;



#### Parameters

| Name | Type | Description |
|---|---|---|
| _newRate | uint256 | - new interest rate value |

### endStake

```solidity
function endStake(uint256 stakeId) external nonpayable returns (bool)
```

this function allows users to end a stake and get their token + interest interest is calculated base on the number of days the stake has been running



#### Parameters

| Name | Type | Description |
|---|---|---|
| stakeId | uint256 | a particular stake the user wants to end |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### getStakes

```solidity
function getStakes() external view returns (struct Wistake.Stake[])
```

Return stakes an address owns.




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | Wistake.Stake[] | undefined |

### getTokenBalance

```solidity
function getTokenBalance() external view returns (uint256)
```



*This function returns user&#39;s token balance*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### initialize

```solidity
function initialize(contract Witoken _token) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _token | contract Witoken | undefined |

### owner

```solidity
function owner() external view returns (address)
```



*Returns the address of the current owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### renounceOwnership

```solidity
function renounceOwnership() external nonpayable
```



*Leaves the contract without owner. It will not be possible to call `onlyOwner` functions. Can only be called by the current owner. NOTE: Renouncing ownership will leave the contract without an owner, thereby disabling any functionality that is only available to the owner.*


### sendToken

```solidity
function sendToken(address _to, uint256 _amount) external nonpayable returns (bool)
```

this function allows the owner of the contract to send token to a specific address



#### Parameters

| Name | Type | Description |
|---|---|---|
| _to | address | the address to send token to |
| _amount | uint256 | the amount of token to send |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### stakeToken

```solidity
function stakeToken(uint256 _amount) external nonpayable returns (bool)
```

This function let the user to stake their tokens. Users can stake as many as they want so far us they have enough tokens



#### Parameters

| Name | Type | Description |
|---|---|---|
| _amount | uint256 | the amount the user is staking |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### stakes

```solidity
function stakes(address, uint256) external view returns (uint256 stakeId, uint256 amount, uint256 dateTime, uint256 interestRate, bool isActive)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| stakeId | uint256 | undefined |
| amount | uint256 | undefined |
| dateTime | uint256 | undefined |
| interestRate | uint256 | undefined |
| isActive | bool | undefined |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | undefined |

### widthdrawFunds

```solidity
function widthdrawFunds(address payable _to, uint256 _amount) external payable returns (bool)
```

This function is used to withdraw funds from the contractonly the owner of the contract can call this function



#### Parameters

| Name | Type | Description |
|---|---|---|
| _to | address payable | address to send funds to |
| _amount | uint256 | amount to send |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |



## Events

### EndStake

```solidity
event EndStake(uint256 _stakeId, uint256 _amount, address indexed _user)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _stakeId  | uint256 | undefined |
| _amount  | uint256 | undefined |
| _user `indexed` | address | undefined |

### FundsDeposited

```solidity
event FundsDeposited(address indexed _from, address indexed _to, uint256 _amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _from `indexed` | address | undefined |
| _to `indexed` | address | undefined |
| _amount  | uint256 | undefined |

### FundsTransfer

```solidity
event FundsTransfer(address indexed _to, uint256 _amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _to `indexed` | address | undefined |
| _amount  | uint256 | undefined |

### Initialized

```solidity
event Initialized(uint64 version)
```



*Triggered when the contract has been initialized or reinitialized.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint64 | undefined |

### InterestRateChange

```solidity
event InterestRateChange(uint256 newRate)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newRate  | uint256 | undefined |

### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner `indexed` | address | undefined |
| newOwner `indexed` | address | undefined |

### PaymentRecieve

```solidity
event PaymentRecieve(address indexed _from, uint256 _amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _from `indexed` | address | undefined |
| _amount  | uint256 | undefined |

### TokenStake

```solidity
event TokenStake(uint256 _stakeId, address indexed _addr, uint256 _amount)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _stakeId  | uint256 | undefined |
| _addr `indexed` | address | undefined |
| _amount  | uint256 | undefined |



## Errors

### DepositFail

```solidity
error DepositFail(string errorMessage)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| errorMessage | string | undefined |

### InvalidInitialization

```solidity
error InvalidInitialization()
```



*The contract is already initialized.*


### NoStakeFound

```solidity
error NoStakeFound(string errorMessage)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| errorMessage | string | undefined |

### NotInitializing

```solidity
error NotInitializing()
```



*The contract is not initializing.*


### OwnableInvalidOwner

```solidity
error OwnableInvalidOwner(address owner)
```



*The owner is not a valid owner account. (eg. `address(0)`)*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

### OwnableUnauthorizedAccount

```solidity
error OwnableUnauthorizedAccount(address account)
```



*The caller account is not authorized to perform an operation.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| account | address | undefined |

### ReentrancyGuardReentrantCall

```solidity
error ReentrancyGuardReentrantCall()
```



*Unauthorized reentrant call.*


### WithdrawalFailed

```solidity
error WithdrawalFailed(string errorMessage)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| errorMessage | string | undefined |


