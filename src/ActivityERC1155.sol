// SPDX-License-Identifier: lilyan bastien Siren 983058728
pragma solidity 0.8.20;

import "@openzeppelin-contracts-5.2.0/access/Ownable.sol";
import "@openzeppelin-contracts-5.2.0/utils/cryptography/MerkleProof.sol";
import {ERC1155} from "@openzeppelin-contracts-5.2.0/token/ERC1155/ERC1155.sol";

import "./interfaces/IActivityERC1155.sol";

/**
 * @title ActivityERC1155
 * @dev A contract representing an ERC1155-based activity.
 */
contract ActivityERC1155 is IActivityERC1155, ERC1155, Ownable {
    bytes32 internal _merkleRoot; // Merkle root for whitelist verification
    string internal _brandName; // Brand name of the activity
    string internal _activityName; // Name of the activity
    address internal immutable _boontySetWhitelist; // Address can set the whitelist
    uint256 internal immutable _activityStart; // Start time of the activity
    uint256 internal immutable _hoursAvailable; // Duration of the activity in hours
    bool internal _activityFinished; // Activity finished flag

    /**
     * @dev Constructor to initialize the ERC1155-based activity.
     * @param boontySetWhitelist Address of the BoontySetWhitelist.
     * @param supply Total supply of the ERC1155 tokens for the activity.
     * @param brandAddress Address of the brand.
     * @param brandName Brand name of the activity.
     * @param activityName Name of the activity.
     * @param initialUri uri for the ERC1155 tokens.
     * @param activityStart Delay in hours from the current block timestamp after which the activity starts.
     * @param hoursAvailable Duration of the activity in hours.
     */
    constructor(
        address boontySetWhitelist,
        uint256 supply,
        address brandAddress,
        string memory brandName,
        string memory activityName,
        string memory initialUri,
        uint16 activityStart,
        uint16 hoursAvailable
    ) ERC1155(initialUri) Ownable(brandAddress) {
        _boontySetWhitelist = boontySetWhitelist;
        _brandName = brandName;
        _activityName = activityName;
        _activityStart = block.timestamp + (uint256(activityStart) * 1 hours);
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
        require(!_activityFinished, "Activity finished");
        require(block.timestamp >= _activityStart, "Activity not started");
        require(block.timestamp <= _activityStart + (_hoursAvailable * 1 hours), "Activity finished");
        _;
    }

    /* -------------------------------------------------------------------------- */
    /*                              Getter functions                              */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IActivityERC1155
    function getMerkleRoot() external view returns (bytes32) {
        return _merkleRoot;
    }

    /// @inheritdoc IActivityERC1155
    function getBrandName() external view returns (string memory) {
        return _brandName;
    }

    /// @inheritdoc IActivityERC1155
    function getActivityName() external view returns (string memory) {
        return _activityName;
    }

    /// @inheritdoc IActivityERC1155
    function getBoontySetWhitelist() external view returns (address) {
        return _boontySetWhitelist;
    }

    /// @inheritdoc IActivityERC1155
    function getHoursAvailable() external view returns (uint256) {
        return _hoursAvailable;
    }

    /// @inheritdoc IActivityERC1155
    function getActivityStart() external view returns (uint256) {
        return _activityStart;
    }

    /// @inheritdoc IActivityERC1155
    function getActivityFinished() external view returns (bool) {
        return _activityFinished;
    }

    /* -------------------------------------------------------------------------- */
    /*                            Privileged functions                            */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IActivityERC1155
    function activityFinished() external onlyOwner {
        _activityFinished = true;
        uint256 balance = balanceOf(address(this), 0);
        _burn(address(this), 0, balance);
    }

    /// @inheritdoc IActivityERC1155
    function setMerkleRoot(bytes32 merkleRoot) external {
        require(msg.sender == _boontySetWhitelist, "Only boontySetWhitelistAddress");
        _merkleRoot = merkleRoot;
    }

    /* -------------------------------------------------------------------------- */
    /*                              Public functions                              */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IActivityERC1155
    function checkInWhitelist(address user, bytes32[] calldata proof) public view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(user));
        bool verified = MerkleProof.verify(proof, _merkleRoot, leaf);
        // check public and external function
        return verified;
    }

    /* -------------------------------------------------------------------------- */
    /*                             External functions                             */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IActivityERC1155
    function withdrawPrize(address user, bytes32[] calldata proof) external activityNotFinished {
        require(checkInWhitelist(user, proof), "You cannot withdraw the prize");
        require(balanceOf(user, 0) == 0, "Reward already collected");
        _safeTransferFrom(address(this), user, 0, 1, "winner");
        emit ClaimedBy(user, block.timestamp);
    }
}
