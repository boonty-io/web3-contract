# ActivityERC20
[Git Source](https://github.com/boonty-io/web3-contract/blob/3a2eec5d2178635a962eddd9fe4a73ae5cd21623/src/ActivityERC20.sol)

**Inherits:**
[IActivityERC20](/src/interfaces/IActivityERC20.sol/interface.IActivityERC20.md)

*A contract representing an ERC20-based activity.*


## State Variables
### BPS_DIVISOR

```solidity
uint32 public constant BPS_DIVISOR = 10_000;
```


### _merkleRoot

```solidity
bytes32 internal _merkleRoot;
```


### _boontyAddress

```solidity
address internal _boontyAddress;
```


### _brandName

```solidity
string internal _brandName;
```


### _activityName

```solidity
string internal _activityName;
```


### _boontySetWhitelist

```solidity
address internal _boontySetWhitelist;
```


### _asset

```solidity
address internal _asset;
```


### _supply

```solidity
uint256 internal _supply;
```


### _boontyToken

```solidity
uint256 internal _boontyToken;
```


### _shares

```solidity
uint256 internal _shares;
```


### _activityStart

```solidity
uint256 internal _activityStart;
```


### _hoursAvailable

```solidity
uint256 internal _hoursAvailable;
```


### _owner

```solidity
address internal _owner;
```


### _activityFinished

```solidity
bool internal _activityFinished;
```


### claimed

```solidity
mapping(address => bool) public claimed;
```


### _totalClaimed

```solidity
uint256 public _totalClaimed;
```


## Functions
### initialize

*Initializes the ERC20-based activity.*


```solidity
function initialize(
    address boontyAddress,
    address boontySetWhitelist,
    address asset,
    uint256 supply,
    uint16 fees,
    address brandAddress,
    string memory brandName,
    string memory activityName,
    uint256 maxWinners,
    uint16 activityStart,
    uint16 hoursAvailable
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`boontyAddress`|`address`|Address of the Boonty.|
|`boontySetWhitelist`|`address`|Address of the BoontySetWhitelist contract.|
|`asset`|`address`|Address of the USDT token.|
|`supply`|`uint256`|Total supply of ERC20 tokens for the activity.|
|`fees`|`uint16`|Percentage of fees.|
|`brandAddress`|`address`|Address of the brand.|
|`brandName`|`string`|Brand name of the activity.|
|`activityName`|`string`|Name of the activity.|
|`maxWinners`|`uint256`|Number of winners for the activity.|
|`activityStart`|`uint16`|Delay in hours from the current block timestamp after which the activity starts.|
|`hoursAvailable`|`uint16`|Duration of the activity in hours.|


### activityNotFinished

*Modifier to check if the activity is not finished.*


```solidity
modifier activityNotFinished();
```

### getMerkleRoot

*Returns the Merkle root for whitelist verification.*


```solidity
function getMerkleRoot() external view returns (bytes32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes32`|The Merkle root.|


### getBoontyAddress

*Returns the Boonty contract address.*


```solidity
function getBoontyAddress() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The Boonty contract address.|


### getBrandName

*Returns the brand name.*


```solidity
function getBrandName() external view returns (string memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|The brand name.|


### getActivityName

*Returns the activity name.*


```solidity
function getActivityName() external view returns (string memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`string`|The activity name.|


### getBoontySetWhitelist

*Returns the BoontySetWhitelist contract address.*


```solidity
function getBoontySetWhitelist() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The BoontySetWhitelist contract address.|


### getAsset

*Returns the USDT token address.*


```solidity
function getAsset() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The USDT token address.|


### getSupply

*Returns the total supply of ERC20 tokens for the activity.*


```solidity
function getSupply() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total supply.|


### getBoontyToken

*Returns the Boonty token amount.*


```solidity
function getBoontyToken() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The Boonty token amount.|


### getShares

*Returns the share of tokens per winner.*


```solidity
function getShares() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The share of tokens.|


### getHoursAvailable

*Returns the duration of the activity in hours.*


```solidity
function getHoursAvailable() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The duration in hours.|


### getWhenActivityFinished

*Returns the time when the activity is finished.*


```solidity
function getWhenActivityFinished() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The time when the activity is finished.|


### getActivityStart

*Returns the start time of the activity.*


```solidity
function getActivityStart() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The start time.|


### getOwner

*Returns the owner address.*


```solidity
function getOwner() external view returns (address);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|The owner address.|


### isActivityFinished

*Returns whether the activity is finished or not.*


```solidity
function isActivityFinished() external view returns (bool);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|A boolean indicating whether the activity is finished.|


### setMerkleRoot

*Sets the Merkle root for whitelist verification.*


```solidity
function setMerkleRoot(bytes32 merkleRoot) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`merkleRoot`|`bytes32`|The Merkle root to set.|


### activityFinished

*Marks the activity as finished and handles token transfers.*


```solidity
function activityFinished() public;
```

### checkInWhitelist

*Checks if an address is whitelisted.*


```solidity
function checkInWhitelist(address user, bytes32[] calldata proof) public view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|Address to check.|
|`proof`|`bytes32[]`|Merkle proof to verify.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|A boolean indicating whether the address is whitelisted.|


### withdrawPrize

*Allows a whitelisted address to withdraw a prize.*


```solidity
function withdrawPrize(address user, bytes32[] calldata proof) external activityNotFinished;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|Address to withdraw the prize.|
|`proof`|`bytes32[]`|Merkle proof to verify the whitelist.|


