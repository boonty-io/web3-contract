// SPDX-License-Identifier: lilyan bastien Siren 983058728
pragma solidity 0.8.20;

interface IBoonty {
    /**
     * @notice Emitted when an activity is created.
     * @param newActivity The address of the new activity.
     */
    event ActivityCreated(address newActivity);

    /**
     * @dev Returns the USDT token address.
     * @return The USDT token address.
     */
    function getAsset() external view returns (address);

    /**
     * @dev Returns the address of the ERC20-based activity template.
     * @return The address of the ERC20-based activity template.
     */
    function getActivityERC20() external view returns (address);

    /**
     * @dev Returns the BoontySetWhitelist contract address.
     * @return The BoontySetWhitelist contract address.
     */
    function getBoontySetWhitelist() external view returns (address);

    /**
     * @dev Returns the fixed fees for Boonty.
     * @return The fixed fees amount.
     */
    function getFixedFees() external view returns (uint256);

    /**
     * @dev Returns the variable fees for Boonty.
     * @return The variable fees amount(in basis points).
     */
    function getFees() external view returns (uint16);

    /**
     * @dev Returns the list of ERC1155-based activities.
     * @return List of ERC1155-based activities.
     */
    function getActivitiesERC20() external view returns (address[] memory);

    /**
     * @dev Returns the list of ERC1155-based activities.
     * @return List of ERC1155-based activities.
     */
    function getActivitiesERC1155() external view returns (address[] memory);

    /* -------------------------------------------------------------------------- */
    /*                            Privileged functions                            */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Sets the USDT token address.
     * @param asset Address of the USDT token.
     */
    function setAsset(address asset) external;

    /**
     * @dev Sets the address of the BoontySetWhitelist contract.
     * @param boontySetWhitelist Address of the BoontySetWhitelist contract.
     */
    function setBoontySetWhitelist(address boontySetWhitelist) external;

    /**
     * @dev Sets the fixed fees for Boonty.
     * @param fixedFees The fixed fees amount to set.
     */
    function setFixedFees(uint256 fixedFees) external;

    /**
     * @dev Update the fees.
     * @param newfees The new fees (in basis points).
     */
    function setFees(uint16 newfees) external;

    /* -------------------------------------------------------------------------- */
    /*                             External functions                             */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Creates a new ERC20-based activity.
     * @param supply Total supply of the ERC20 tokens for the activity.
     * @param brandName Brand name of the activity.
     * @param activityName Name of the activity.
     * @param maxWinners Number of winners for the activity.
     * @param activityStart Start time of the activity. In hours. If 0, the activity starts now (max 65535H).
     * @param hoursAvailable Duration of the activity in hours after the start time (max 65535H).
     * @return Address of the newly created ERC20-based activity.
     */
    function createActivityERC20(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        uint256 maxWinners,
        uint16 activityStart,
        uint16 hoursAvailable
    ) external returns (address);

    /**
     * @dev Creates a new ERC1155-based activity.
     * @param supply Total supply of the ERC1155 tokens for the activity.
     * @param brandName Brand name of the activity.
     * @param activityName Name of the activity.
     * @param uri uri for the ERC1155 tokens.
     * @param activityStart Start time of the activity. In hours. If 0, the activity starts now (max 65535H).
     * @param hoursAvailable Duration of the activity in hours after the start time (max 65535H).
     * @param brandAddress Address of the brand. She will be the owner of the activity.
     * @return Address of the newly created ERC1155-based activity.
     */
    function createActivityERC1155(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        string memory uri,
        uint16 activityStart,
        uint16 hoursAvailable,
        address brandAddress
    ) external returns (address);
}
