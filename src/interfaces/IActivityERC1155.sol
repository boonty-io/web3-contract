// SPDX-License-Identifier: lilyan bastien Siren 983058728
pragma solidity 0.8.20;

import {IERC1155} from "@openzeppelin-contracts-5.2.0/token/ERC1155/IERC1155.sol";

interface IActivityERC1155 is IERC1155 {
    /**
     * @notice Emitted when a user claims a prize.
     * @param user The address of the user.
     * @param timestamp The timestamp of the claim.
     */
    event ClaimedBy(address user, uint256 timestamp);

    /* -------------------------------------------------------------------------- */
    /*                              Getter functions                              */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Returns the Merkle root for whitelist verification.
     * @return The Merkle root.
     */
    function getMerkleRoot() external view returns (bytes32);

    /**
     * @dev Returns the brand name.
     * @return The brand name.
     */
    function getBrandName() external view returns (string memory);

    /**
     * @dev Returns the activity name.
     * @return The activity name.
     */
    function getActivityName() external view returns (string memory);

    /**
     * @dev Returns the BoontySetWhitelist contract address.
     * @return The BoontySetWhitelist contract address.
     */
    function getBoontySetWhitelist() external view returns (address);

    /**
     * @dev Returns the hours available for the activity.
     * @return The hours available for the activity.
     */
    function getHoursAvailable() external view returns (uint256);

    /**
     * @dev Returns the start time of the activity.
     * @return The start time of the activity.
     */
    function getActivityStart() external view returns (uint256);

    /**
     * @dev Returns the activity finished status.
     * @return The activity finished status.
     */
    function getActivityFinished() external view returns (bool);

    /* -------------------------------------------------------------------------- */
    /*                            Privileged functions                            */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Marks the activity as finished.
     */
    function activityFinished() external;

    /**
     * @dev Sets the Merkle root for whitelist verification.
     * @param merkleRoot The Merkle root to set.
     */
    function setMerkleRoot(bytes32 merkleRoot) external;

    /* -------------------------------------------------------------------------- */
    /*                              Public functions                              */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Checks if an address is whitelisted.
     * @param user Address to check.
     * @param proof Merkle proof to verify.
     * @return A boolean indicating whether the address is whitelisted.
     */
    function checkInWhitelist(address user, bytes32[] calldata proof) external returns (bool);

    /* -------------------------------------------------------------------------- */
    /*                             External functions                             */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Allows a whitelisted address to withdraw a prize.
     * @param user Address to withdraw the prize.
     * @param proof Merkle proof to verify the whitelist.
     */
    function withdrawPrize(address user, bytes32[] calldata proof) external;
}
