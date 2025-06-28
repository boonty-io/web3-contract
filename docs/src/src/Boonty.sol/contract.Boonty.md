# Boonty
[Git Source](https://github.com/boonty-io/web3-contract/blob/3a2eec5d2178635a962eddd9fe4a73ae5cd21623/src/Boonty.sol)

**Inherits:**
[IBoonty](/src/interfaces/IBoonty.sol/interface.IBoonty.md), Ownable

*A contract for managing Boonty activities, which can be either ERC20 or ERC1155 based.*


## State Variables
### _asset

```solidity
address internal _asset;
```


### _activityERC20

```solidity
address internal _activityERC20;
```


### _boontySetWhitelist

```solidity
address internal _boontySetWhitelist;
```


### _fixedFees

```solidity
uint256 internal _fixedFees;
```


### _fees

```solidity
uint16 internal _fees;
```


### _activitiesERC20

```solidity
address[] public _activitiesERC20;
```


### _activitiesERC1155

```solidity
address[] public _activitiesERC1155;
```


## Functions
### constructor

*Constructor to set the initial owner.*


```solidity
constructor(address initialOwner, address asset) Ownable(initialOwner);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`initialOwner`|`address`|Address of the initial owner.|
|`asset`|`address`||


### notZeroAddress


```solidity
modifier notZeroAddress(address addr);
```

### getAsset

*Returns the USDT token address.*


```solidity
function getAsset() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The USDT token address.|


### getActivityERC20

*Returns the address of the ERC20-based activity template.*


```solidity
function getActivityERC20() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The address of the ERC20-based activity template.|


### getBoontySetWhitelist

*Returns the BoontySetWhitelist contract address.*


```solidity
function getBoontySetWhitelist() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The BoontySetWhitelist contract address.|


### getFixedFees

*Returns the fixed fees for Boonty.*


```solidity
function getFixedFees() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The fixed fees amount.|


### getFees

*Returns the variable fees for Boonty.*


```solidity
function getFees() external view returns (uint16);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint16`|The variable fees amount(in basis points).|


### getActivitiesERC20

*Returns the list of ERC1155-based activities.*


```solidity
function getActivitiesERC20() external view returns (address[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|List of ERC1155-based activities.|


### getActivitiesERC1155

*Returns the list of ERC1155-based activities.*


```solidity
function getActivitiesERC1155() external view returns (address[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address[]`|List of ERC1155-based activities.|


### setAsset

*Sets the USDT token address.*


```solidity
function setAsset(address asset) external onlyOwner notZeroAddress(asset);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`asset`|`address`|Address of the USDT token.|


### setBoontySetWhitelist

*Sets the address of the BoontySetWhitelist contract.*


```solidity
function setBoontySetWhitelist(address boontySetWhitelist) external onlyOwner notZeroAddress(boontySetWhitelist);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`boontySetWhitelist`|`address`|Address of the BoontySetWhitelist contract.|


### setFixedFees

*Sets the fixed fees for Boonty.*


```solidity
function setFixedFees(uint256 fixedFees) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`fixedFees`|`uint256`|The fixed fees amount to set.|


### setFees

*Update the fees.*


```solidity
function setFees(uint16 newfees) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newfees`|`uint16`|The new fees (in basis points).|


### createActivityERC20

*Creates a new ERC20-based activity.*


```solidity
function createActivityERC20(
    uint256 supply,
    string memory brandName,
    string memory activityName,
    uint256 maxWinners,
    uint16 activityStart,
    uint16 hoursAvailable
) external returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`supply`|`uint256`|Total supply of the ERC20 tokens for the activity.|
|`brandName`|`string`|Brand name of the activity.|
|`activityName`|`string`|Name of the activity.|
|`maxWinners`|`uint256`|Number of winners for the activity.|
|`activityStart`|`uint16`|Start time of the activity. In hours. If 0, the activity starts now (max 65535H).|
|`hoursAvailable`|`uint16`|Duration of the activity in hours after the start time (max 65535H).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|Address of the newly created ERC20-based activity.|


### createActivityERC1155

*Creates a new ERC1155-based activity.*


```solidity
function createActivityERC1155(
    uint256 supply,
    string memory brandName,
    string memory activityName,
    string memory uri,
    uint16 activityStart,
    uint16 hoursAvailable,
    address brandAddress
) external returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`supply`|`uint256`|Total supply of the ERC1155 tokens for the activity.|
|`brandName`|`string`|Brand name of the activity.|
|`activityName`|`string`|Name of the activity.|
|`uri`|`string`|uri for the ERC1155 tokens.|
|`activityStart`|`uint16`|Start time of the activity. In hours. If 0, the activity starts now (max 65535H).|
|`hoursAvailable`|`uint16`|Duration of the activity in hours after the start time (max 65535H).|
|`brandAddress`|`address`|Address of the brand. She will be the owner of the activity.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|Address of the newly created ERC1155-based activity.|


