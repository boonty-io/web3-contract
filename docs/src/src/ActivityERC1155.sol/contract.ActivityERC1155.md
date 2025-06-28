# ActivityERC1155
[Git Source](https://github.com/boonty-io/web3-contract/blob/3a2eec5d2178635a962eddd9fe4a73ae5cd21623/src/ActivityERC1155.sol)

**Inherits:**
[IActivityERC1155](/src/interfaces/IActivityERC1155.sol/interface.IActivityERC1155.md), ERC1155, Ownable

*A contract representing an ERC1155-based activity.*


## State Variables
### _merkleRoot

```solidity
bytes32 internal _merkleRoot;
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
address internal immutable _boontySetWhitelist;
```


### _activityStart

```solidity
uint256 internal immutable _activityStart;
```


### _hoursAvailable

```solidity
uint256 internal immutable _hoursAvailable;
```


### _activityFinished

```solidity
bool internal _activityFinished;
```


## Functions
### constructor

*Constructor to initialize the ERC1155-based activity.*


```solidity
constructor(
    address boontySetWhitelist,
    uint256 supply,
    address brandAddress,
    string memory brandName,
    string memory activityName,
    string memory initialUri,
    uint16 activityStart,
    uint16 hoursAvailable
) ERC1155(initialUri) Ownable(brandAddress);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`boontySetWhitelist`|`address`|Address of the BoontySetWhitelist.|
|`supply`|`uint256`|Total supply of the ERC1155 tokens for the activity.|
|`brandAddress`|`address`|Address of the brand.|
|`brandName`|`string`|Brand name of the activity.|
|`activityName`|`string`|Name of the activity.|
|`initialUri`|`string`|uri for the ERC1155 tokens.|
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


### getHoursAvailable

*Returns the hours available for the activity.*


```solidity
function getHoursAvailable() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The hours available for the activity.|


### getActivityStart

*Returns the start time of the activity.*


```solidity
function getActivityStart() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The start time of the activity.|


### getActivityFinished

*Returns the activity finished status.*


```solidity
function getActivityFinished() external view returns (bool);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|The activity finished status.|


### activityFinished

*Marks the activity as finished.*


```solidity
function activityFinished() external onlyOwner;
```

### setMerkleRoot

*Sets the Merkle root for whitelist verification.*


```solidity
function setMerkleRoot(bytes32 merkleRoot) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`merkleRoot`|`bytes32`|The Merkle root to set.|


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


