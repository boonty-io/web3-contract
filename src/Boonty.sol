// SPDX-License-Identifier: lilyan bastien Siren 983058728

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ActivityERC1155.sol";
import "./ActivityERC20.sol";

/**
 * @title Boonty
 * @dev A contract for managing Boonty activities, which can be either ERC20 or ERC1155 based.
 */
contract Boonty is Ownable {
    address internal _asset; // USDT/USDC token address
    address internal _activityERC20; // ERC20-based activity template address
    address internal _boontySetWhitelist; // BoontySetWhitelist contract address

    uint256 internal _fixedFees; // Fees for erc1155
    uint8 internal _fees; // Fees for erc20

    address[] public _activitiesERC20; // List of ERC20-based activities
    address[] public _activitiesERC1155; // List of ERC1155-based activities

    event ActivityCreated(address newActivity);

    /**
     * @dev Constructor to set the initial owner.
     * @param initialOwner Address of the initial owner.
     */
    constructor(address initialOwner) Ownable(initialOwner) {
        ActivityERC20 newActivityERC20 = new ActivityERC20();
        _activityERC20 = address(newActivityERC20);
    }

    /* -------------------------------------------------------------------------- */
    /*                              Getter functions                              */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Returns the USDT token address.
     * @return The USDT token address.
     */
    function getAsset() external view returns (address) {
        return _asset;
    }

    /**
     * @dev Returns the address of the ERC20-based activity template.
     * @return The address of the ERC20-based activity template.
     */
    function getActivityERC20() external view returns (address) {
        return _activityERC20;
    }

    /**
     * @dev Returns the BoontySetWhitelist contract address.
     * @return The BoontySetWhitelist contract address.
     */
    function getBoontySetWhitelist() external view returns (address) {
        return _boontySetWhitelist;
    }

    /**
     * @dev Returns the fixed fees for Boonty.
     * @return The fixed fees amount.
     */
    function getFixedFees() external view returns (uint256) {
        return _fixedFees;
    }

    /**
     * @dev Returns the variable fees for Boonty.
     * @return The variable fees amount.
     */
    function getFees() external view returns (uint8) {
        return _fees;
    }

    /**
     * @dev Returns the list of ERC1155-based activities.
     * @return List of ERC1155-based activities.
     */
    function getActivitiesERC20() external view returns (address[] memory) {
        return _activitiesERC20;
    }

    /**
     * @dev Returns the list of ERC1155-based activities.
     * @return List of ERC1155-based activities.
     */
    function getActivitiesERC1155() external view returns (address[] memory) {
        return _activitiesERC1155;
    }

    /* -------------------------------------------------------------------------- */
    /*                            Privileged functions                            */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Sets the USDT token address.
     * @param asset Address of the USDT token.
     */
    function setAsset(address asset) external onlyOwner {
        _asset = asset;
    }

    /**
     * @dev Sets the address of the BoontySetWhitelist contract.
     * @param boontySetWhitelist Address of the BoontySetWhitelist contract.
     */
    function setBoontySetWhitelist(address boontySetWhitelist) external onlyOwner {
        _boontySetWhitelist = boontySetWhitelist;
    }

    /**
     * @dev Sets the fixed fees for Boonty.
     * @param fixedFees The fixed fees amount to set.
     */
    function setFixedFees(uint256 fixedFees) external onlyOwner {
        _fixedFees = fixedFees;
    }

    /**
     * @dev Sets the variable fees for Boonty.
     * @param fees The variable fees amount to set.
     */
    function setFees(uint8 fees) external onlyOwner {
        _fees = fees;
    }

    /* -------------------------------------------------------------------------- */
    /*                             External functions                             */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Creates a new ERC20-based activity.
     * @param supply Total supply of the ERC20 tokens for the activity.
     * @param brandName Brand name of the activity.
     * @param activityName Name of the activity.
     * @param maxWinners Number of winners for the activity.
     * @param activityStart Start time of the activity. In hours. If 0, the activity starts now.
     * @param hoursAvailable Duration of the activity in hours after the start time.
     * @return Address of the newly created ERC20-based activity.
     */
    function createActivityERC20(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        uint256 maxWinners,
        uint256 activityStart,
        uint256 hoursAvailable
    ) external returns (address) {
        require(_activityERC20 != address(0), "Template storage doesn't exist");
        address asset = _asset; // gas savings
        require(IERC20(asset).allowance(msg.sender, address(this)) >= supply, "Increase your allowance");
        address clone = Clones.clone(_activityERC20);
        IERC20(asset).transferFrom(msg.sender, clone, supply);
        ActivityERC20(clone).initialize(
            owner(),
            _boontySetWhitelist,
            asset,
            supply,
            _fees,
            msg.sender,
            brandName,
            activityName,
            maxWinners,
            activityStart,
            hoursAvailable
        );
        _activitiesERC20.push(clone);
        emit ActivityCreated(clone);
        return clone;
    }

    /**
     * @dev Creates a new ERC1155-based activity.
     * @param supply Total supply of the ERC1155 tokens for the activity.
     * @param brandName Brand name of the activity.
     * @param activityName Name of the activity.
     * @param uri uri for the ERC1155 tokens.
     * @param activityStart Start time of the activity. In hours. If 0, the activity starts now.
     * @param hoursAvailable Duration of the activity in hours after the start time.
     * @param brandAddress Address of the brand. She will be the owner of the activity.
     * @return Address of the newly created ERC1155-based activity.
     */
    function createActivityERC1155(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        string memory uri,
        uint256 activityStart,
        uint256 hoursAvailable,
        address brandAddress
    ) external returns (address) {
        address asset = _asset; // gas savings
        uint256 fixedFees = _fixedFees; // gas savings
        require(IERC20(asset).allowance(msg.sender, address(this)) >= fixedFees, "Increase your allowance");
        IERC20(asset).transferFrom(msg.sender, owner(), fixedFees);
        ActivityERC1155 newActivityERC1155 = new ActivityERC1155(
            _boontySetWhitelist, supply, brandAddress, brandName, activityName, uri, activityStart, hoursAvailable
        );
        _activitiesERC1155.push(address(newActivityERC1155));
        emit ActivityCreated(address(newActivityERC1155));
        return address(newActivityERC1155);
    }
}
