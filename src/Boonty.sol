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
    address internal _usdtToken;
    address internal _activityERC20;
    address internal _boontySetWhitelist;

    uint256 internal _boontyFixedFees;
    uint256 internal _boontyFees;
    //enlever le nom boonty = a changer

    address[] public _activitiesERC20;
    address[] public _activitiesERC1155;

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
    function getUsdtToken() external view returns (address) {
        return _usdtToken;
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
    function getBoontyFixedFees() external view returns (uint256) {
        return _boontyFixedFees;
    }

    /**
     * @dev Returns the variable fees for Boonty.
     * @return The variable fees amount.
     */
    function getBoontyFees() external view returns (uint256) {
        return _boontyFees;
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
     * @param usdtToken Address of the USDT token.
     */
    function setUsdtToken(address usdtToken) external onlyOwner {
        _usdtToken = usdtToken;
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
     * @param boontyFixedFees The fixed fees amount to set.
     */
    function setBoontyFixedFees(uint256 boontyFixedFees) external onlyOwner {
        _boontyFixedFees = boontyFixedFees;
    }

    /**
     * @dev Sets the variable fees for Boonty.
     * @param boontyFees The variable fees amount to set.
     */
    function setBoontyFees(uint256 boontyFees) external onlyOwner {
        _boontyFees = boontyFees;
    }

    /* -------------------------------------------------------------------------- */
    /*                             External functions                             */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Creates a new ERC20-based activity.
     * @param supply Total supply of the ERC20 tokens for the activity.
     * @param brandName Brand name of the activity.
     * @param activityName Name of the activity.
     * @param numberOfWinners Number of winners for the activity.
     * @param activityStart Start time of the activity. In hours. If 0, the activity starts now.
     * @param hoursAvailable Duration of the activity in hours after the start time.
     * @return Address of the newly created ERC20-based activity.
     */
    function createActivityERC20(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        uint256 numberOfWinners,
        uint256 activityStart,
        uint256 hoursAvailable
    ) external returns (address) {
        require(_activityERC20 != address(0), "Template storage doesn't exist");
        address usdtToken = _usdtToken; // gas savings
        require(IERC20(usdtToken).allowance(msg.sender, address(this)) >= supply, "Increase your allowance");
        address clone = Clones.clone(_activityERC20);
        ActivityERC20(clone).initialize(
            owner(),
            _boontySetWhitelist,
            usdtToken,
            supply,
            _boontyFees,
            msg.sender,
            brandName,
            activityName,
            numberOfWinners,
            activityStart,
            hoursAvailable
        );
        IERC20(usdtToken).transferFrom(msg.sender, clone, supply);
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
        address usdtToken = _usdtToken; // gas savings
        uint256 boontyFixedFees = _boontyFixedFees; // gas savings
        require(IERC20(usdtToken).allowance(msg.sender, address(this)) >= boontyFixedFees, "Increase your allowance");
        IERC20(usdtToken).transferFrom(msg.sender, owner(), boontyFixedFees);
        ActivityERC1155 newActivityERC1155 = new ActivityERC1155(
            _boontySetWhitelist, supply, brandAddress, brandName, activityName, uri, activityStart, hoursAvailable
        );
        _activitiesERC1155.push(address(newActivityERC1155));
        emit ActivityCreated(address(newActivityERC1155));
        return address(newActivityERC1155);
    }
}
