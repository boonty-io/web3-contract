// SPDX-License-Identifier: lilyan bastien Siren 983058728
pragma solidity 0.8.20;

interface IActivityERC20 {
    /**
     * @notice Emitted when a user claims a prize.
     * @param user The address of the user.
     * @param shares The amount of shares claimed.
     * @param timestamp The timestamp of the claim.
     */
    event ClaimedBy(address user, uint256 shares, uint256 timestamp);

    /**
     * @dev Initializes the ERC20-based activity.
     * @param boontyAddress Address of the Boonty.
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
        uint16 fees,
        address brandAddress,
        string memory brandName,
        string memory activityName,
        uint256 maxWinners,
        uint16 activityStart,
        uint16 hoursAvailable
    ) external;

    /* -------------------------------------------------------------------------- */
    /*                              Getter functions                              */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Returns the Merkle root for whitelist verification.
     * @return The Merkle root.
     */
    function getMerkleRoot() external view returns (bytes32);

    /**
     * @dev Returns the Boonty contract address.
     * @return The Boonty contract address.
     */
    function getBoontyAddress() external view returns (address);

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
     * @dev Returns the USDT token address.
     * @return The USDT token address.
     */
    function getAsset() external view returns (address);

    /**
     * @dev Returns the total supply of ERC20 tokens for the activity.
     * @return The total supply.
     */
    function getSupply() external view returns (uint256);

    /**
     * @dev Returns the Boonty token amount.
     * @return The Boonty token amount.
     */
    function getBoontyToken() external view returns (uint256);

    /**
     * @dev Returns the share of tokens per winner.
     * @return The share of tokens.
     */
    function getShares() external view returns (uint256);

    /**
     * @dev Returns the duration of the activity in hours.
     * @return The duration in hours.
     */
    function getHoursAvailable() external view returns (uint256);

    /**
     * @dev Returns the time when the activity is finished.
     * @return The time when the activity is finished.
     */
    function getWhenActivityFinished() external view returns (uint256);

    /**
     * @dev Returns the start time of the activity.
     * @return The start time.
     */
    function getActivityStart() external view returns (uint256);

    /**
     * @dev Returns the owner address.
     * @return The owner address.
     */
    function getOwner() external view returns (address);

    /**
     * @dev Returns whether the activity is finished or not.
     * @return A boolean indicating whether the activity is finished.
     */
    function isActivityFinished() external view returns (bool);

    /* -------------------------------------------------------------------------- */
    /*                            Privileged functions                            */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Sets the Merkle root for whitelist verification.
     * @param merkleRoot The Merkle root to set.
     */
    function setMerkleRoot(bytes32 merkleRoot) external;

    /* -------------------------------------------------------------------------- */
    /*                              Public functions                              */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Marks the activity as finished and handles token transfers.
     */
    function activityFinished() external;

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
