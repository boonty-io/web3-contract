// SPDX-License-Identifier: lilyan bastien Siren 983058728

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

/**
 * @title ActivityERC20
 * @dev A contract representing an ERC20-based activity.
 */
contract ActivityERC20 {
    using Math for uint256;

    bytes32 internal _merkleRoot; // Merkle root for whitelist verification
    address internal _boontyAddress; // Boonty owner address
    string internal _brandName; // Brand name of the activity
    string internal _activityName; // Name of the activity
    address internal _boontySetWhitelist; // Address can set the whitelist
    address internal _asset; // USDT/USDC token address
    uint256 internal _supply; // Total supply of ERC20 tokens for the activity
    uint256 internal _boontyToken; // Boonty fees
    uint256 internal _shares; // Share of tokens per winner
    uint256 internal _hoursAvailable; // Duration of the activity in hours
    uint256 internal _activityStart; // Start time of the activity
    address internal _owner; // Brand owner address
    bool internal _activityFinished; // Activity finished flag

    mapping(address => bool) public claimed; // Mapping of claimed prizes

    /**
     * @dev Initializes the ERC20-based activity.
     * @param boontyAddress Address of the Boonty contract. // a changé
     * @param boontySetWhitelist Address of the BoontySetWhitelist contract.
     * @param asset Address of the USDT token.
     * @param supply Total supply of ERC20 tokens for the activity.
     * @param fees Percentage of fees.
     * @param brandAddress Address of the brand.
     * @param brandName Brand name of the activity.
     * @param activityName Name of the activity.
     * @param maxWinners Number of winners for the activity.
     * @param activityStart Start time of the activity.
     * @param hoursAvailable Duration of the activity in hours.
     */
    function initialize(
        address boontyAddress,
        address boontySetWhitelist,
        address asset,
        uint256 supply,
        uint8 fees,
        address brandAddress,
        string memory brandName,
        string memory activityName,
        uint256 maxWinners,
        uint256 activityStart,
        uint256 hoursAvailable
    ) external {
        require(_owner == address(0), "Already initialized");
        _owner = brandAddress;
        _boontyAddress = boontyAddress;
        _boontySetWhitelist = boontySetWhitelist;
        _asset = asset;
        uint256 newSupply = supply - uint256(fees).mulDiv(supply, 100, Math.Rounding.Ceil); // gas savings
        _supply = newSupply - newSupply % maxWinners;
        _brandName = brandName;
        _activityName = activityName;
        _shares = newSupply / maxWinners;
        IERC20(asset).transfer(brandAddress, newSupply % maxWinners);
        _boontyToken = supply - newSupply;
        _activityStart = block.timestamp + (activityStart * 1 hours);
        _hoursAvailable = hoursAvailable;
    }

    /* -------------------------------------------------------------------------- */
    /*                                  Modifier                                  */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Modifier to check if the activity is not finished.
     */
    modifier activityNotFinished() {
        require(!_activityFinished, "Activity finished");
        require(block.timestamp >= _activityStart, "Activity not started");
        require(block.timestamp <= _activityStart + (_hoursAvailable * 1 hours), "Activity finished");
        _;
    }

    /**
     * @dev Modifier to allow only the owner to access certain functions.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner");
        _;
    }

    /* -------------------------------------------------------------------------- */
    /*                              Getter functions                              */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Returns the Merkle root for whitelist verification.
     * @return The Merkle root.
     */
    function getMerkleRoot() public view returns (bytes32) {
        return _merkleRoot;
    }

    /**
     * @dev Returns the Boonty contract address.
     * @return The Boonty contract address.
     */
    function getBoontyAddress() public view returns (address) {
        return _boontyAddress;
    }

    /**
     * @dev Returns the brand name.
     * @return The brand name.
     */
    function getBrandName() public view returns (string memory) {
        return _brandName;
    }

    /**
     * @dev Returns the activity name.
     * @return The activity name.
     */
    function getActivityName() public view returns (string memory) {
        return _activityName;
    }

    /**
     * @dev Returns the BoontySetWhitelist contract address.
     * @return The BoontySetWhitelist contract address.
     */
    function getBoontySetWhitelist() public view returns (address) {
        return _boontySetWhitelist;
    }

    /**
     * @dev Returns the USDT token address.
     * @return The USDT token address.
     */
    function getAsset() public view returns (address) {
        return _asset;
    }

    /**
     * @dev Returns the total supply of ERC20 tokens for the activity.
     * @return The total supply.
     */
    function getSupply() public view returns (uint256) {
        return _supply;
    }

    /**
     * @dev Returns the Boonty token amount.
     * @return The Boonty token amount.
     */
    function getBoontyToken() public view returns (uint256) {
        return _boontyToken;
    }

    /**
     * @dev Returns the share of tokens per winner.
     * @return The share of tokens.
     */
    function getShares() public view returns (uint256) {
        return _shares;
    }

    /**
     * @dev Returns the duration of the activity in hours.
     * @return The duration in hours.
     */
    function getHoursAvailable() public view returns (uint256) {
        return _hoursAvailable;
    }

    /**
     * @dev Returns the start time of the activity.
     * @return The start time.
     */
    function getActivityStart() public view returns (uint256) {
        return _activityStart;
    }

    /**
     * @dev Returns the owner address.
     * @return The owner address.
     */
    function getOwner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Returns whether the activity is finished or not.
     * @return A boolean indicating whether the activity is finished.
     */
    function isActivityFinished() public view returns (bool) {
        return _activityFinished;
    }

    /* -------------------------------------------------------------------------- */
    /*                            Privileged functions                            */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Sets the Merkle root for whitelist verification.
     * @param merkleRoot The Merkle root to set.
     */
    function setMerkleRoot(bytes32 merkleRoot) public {
        require(msg.sender == _boontySetWhitelist, "Only boontySetWhitelistAddress");
        _merkleRoot = merkleRoot;
    }

    /* -------------------------------------------------------------------------- */
    /*                              Public functions                              */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Marks the activity as finished and handles token transfers.
     */
    function activityFinished() public {
        require(!_activityFinished, "Activity finished");

        if (IERC20(_asset).balanceOf(address(this)) == _boontyToken) {
            require(msg.sender == _owner || msg.sender == _boontyAddress);
            _activityFinished = true;

            IERC20(_asset).transfer(_boontyAddress, _boontyToken);
        } else if (block.timestamp <= _activityStart + (_hoursAvailable * 1 hours)) {
            require(msg.sender == _owner);
            _activityFinished = true;

            IERC20(_asset).transfer(_boontyAddress, _boontyToken);
            uint256 balance = IERC20(_asset).balanceOf(address(this));
            IERC20(_asset).transfer(_owner, balance);
        } else if (block.timestamp > _activityStart + (_hoursAvailable * 1 hours)) {
            require(msg.sender == _owner || msg.sender == _boontyAddress);
            _activityFinished = true;

            IERC20(_asset).transfer(_boontyAddress, _boontyToken);
            uint256 balance = IERC20(_asset).balanceOf(address(this));
            IERC20(_asset).transfer(_owner, balance);
        }
    }

    /**
     * @dev Checks if an address is whitelisted.
     * @param proof Merkle proof to verify.
     * @param maxAllowanceToMint Maximum allowance to mint.
     * @return A boolean indicating whether the address is whitelisted.
     */
    function checkInWhitelist(bytes32[] calldata proof, uint64 maxAllowanceToMint) public view returns (bool) {
        bytes32 leaf = keccak256(abi.encode(msg.sender, maxAllowanceToMint));
        return MerkleProof.verify(proof, _merkleRoot, leaf);
    }

    /**
     * @dev Allows a whitelisted address to withdraw a prize.
     * @param proof Merkle proof to verify the whitelist.
     * @param maxAllowanceToMint Maximum allowance to mint.
     */
    function withdrawPrize(bytes32[] calldata proof, uint64 maxAllowanceToMint) public activityNotFinished {
        require(checkInWhitelist(proof, maxAllowanceToMint), "You cannot withdraw the prize");
        require(!claimed[msg.sender], "Tokens already claimed");
        claimed[msg.sender] = true;
        // add emit(msg.sender, _shares, blocks.timestamp)
        IERC20(_asset).transfer(msg.sender, _shares);
    }
}
