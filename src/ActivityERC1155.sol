// SPDX-License-Identifier: lilyan bastien Siren 983058728

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title ActivityERC1155
 * @dev A contract representing an ERC1155-based activity.
 */
contract ActivityERC1155 is ERC1155, Ownable {
    bytes32 internal _merkleRoot;
    string internal _brandName;
    string internal _activityName;
    address internal _boontySetWhitelist;
    uint256 internal _hoursAvailable;
    uint256 internal _activityStart;
    bool internal _activityFinished;

    /**
     * @dev Constructor to initialize the ERC1155-based activity.
     * @param boontySetWhitelist Address of the BoontySetWhitelist contract.
     * @param supply Total supply of the ERC1155 tokens for the activity.
     * @param brandAddress Address of the brand.
     * @param brandName Brand name of the activity.
     * @param activityName Name of the activity.
     * @param uri uri for the ERC1155 tokens.
     * @param activityStart Start time of the activity.
     * @param hoursAvailable Duration of the activity in hours.
     */
    constructor(
        address boontySetWhitelist,
        uint256 supply,
        address brandAddress,
        string memory brandName,
        string memory activityName,
        string memory uri,
        uint256 activityStart,
        uint256 hoursAvailable
    ) ERC1155(uri) Ownable(brandAddress) {
        _boontySetWhitelist = boontySetWhitelist;
        _brandName = brandName;
        _activityName = activityName;
        _activityStart = block.timestamp + (activityStart * 1 hours);
        _hoursAvailable = hoursAvailable;
        _mint(address(this), 0, supply, "firstMint");
    }

    /* -------------------------------------------------------------------------- */
    /*                                  Modifier                                  */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Modifier to check if the activity is not finished.
     */
    modifier activityNotFinished() {
        require(block.timestamp <= _activityStart + (_hoursAvailable * 1 hours), "Activity finished");
        require(!_activityFinished, "Activity finished");
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
     * @dev Returns the hours available for the activity.
     * @return The hours available for the activity.
     */
    function getHoursAvailable() public view returns (uint256) {
        return _hoursAvailable;
    }

    /**
     * @dev Returns the start time of the activity.
     * @return The start time of the activity.
     */
    function getActivityStart() public view returns (uint256) {
        return _activityStart;
    }

    /**
     * @dev Returns the activity finished status.
     * @return The activity finished status.
     */
    function getActivityFinished() public view returns (bool) {
        return _activityFinished;
    }

    /* -------------------------------------------------------------------------- */
    /*                            Privileged functions                            */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Marks the activity as finished.
     */
    function activityFinished() public onlyOwner {
        _activityFinished = true;
        uint256 balance = balanceOf(address(this), 0);
        _burn(address(this), 0, balance);
    }

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
     * @dev Checks if an address is whitelisted.
     * @param proof Merkle proof to verify.
     * @param maxAllowanceToMint Maximum allowance to mint.
     * @return A boolean indicating whether the address is whitelisted.
     */
    function checkInWhitelist(bytes32[] calldata proof, uint64 maxAllowanceToMint) public view returns (bool) {
        bytes32 leaf = keccak256(abi.encode(msg.sender, maxAllowanceToMint));
        bool verified = MerkleProof.verify(proof, _merkleRoot, leaf);
        return verified;
    }

    /**
     * @dev Allows a whitelisted address to withdraw a prize.
     * @param proof Merkle proof to verify the whitelist.
     * @param maxAllowanceToMint Maximum allowance to mint.
     */
    function withdrawPrize(bytes32[] calldata proof, uint64 maxAllowanceToMint) public activityNotFinished {
        require(checkInWhitelist(proof, maxAllowanceToMint), " You cannot withdraw the prize");
        require(balanceOf(msg.sender, 0) == 0, "Reward already collected");
        // add emit(msg.sender, _shares, blocks.timestamp)
        safeTransferFrom(address(this), msg.sender, 0, 1, "winner");
    }
}
