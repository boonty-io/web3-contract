// SPDX-License-Identifier: lilyan bastien Siren 983058728
pragma solidity 0.8.20;

import "@openzeppelin-contracts-5.2.0/proxy/Clones.sol";
import "@openzeppelin-contracts-5.2.0/access/Ownable.sol";
import "@openzeppelin-contracts-5.2.0/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin-contracts-5.2.0/token/ERC20/utils/SafeERC20.sol";

import "./ActivityERC1155.sol";
import "./ActivityERC20.sol";
import "./interfaces/IBoonty.sol";

/**
 * @title Boonty
 * @dev A contract for managing Boonty activities, which can be either ERC20 or ERC1155 based.
 */
contract Boonty is IBoonty, Ownable {
    using SafeERC20 for IERC20;

    address internal _asset; // USDT/USDC token address
    address internal _activityERC20; // ERC20-based activity template address
    address internal _boontySetWhitelist; // BoontySetWhitelist contract address

    uint256 internal _fixedFees; // Fees for erc1155
    uint16 internal _fees; // Fees for erc20 in basis points

    address[] public _activitiesERC20; // List of ERC20-based activities
    address[] public _activitiesERC1155; // List of ERC1155-based activities

    /**
     * @dev Constructor to set the initial owner.
     * @param initialOwner Address of the initial owner.
     */
    constructor(address initialOwner, address asset) Ownable(initialOwner) {
        ActivityERC20 newActivityERC20 = new ActivityERC20();
        _activityERC20 = address(newActivityERC20);
        _boontySetWhitelist = initialOwner;
        _asset = asset;
    }

    /* -------------------------------------------------------------------------- */
    /*                                  Modifier                                  */
    /* -------------------------------------------------------------------------- */

    modifier notZeroAddress(address addr) {
        require(addr != address(0), "Zero address");
        _;
    }

    /* -------------------------------------------------------------------------- */
    /*                              Getter functions                              */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IBoonty
    function getAsset() external view returns (address) {
        return _asset;
    }

    /// @inheritdoc IBoonty
    function getActivityERC20() external view returns (address) {
        return _activityERC20;
    }

    /// @inheritdoc IBoonty
    function getBoontySetWhitelist() external view returns (address) {
        return _boontySetWhitelist;
    }

    /// @inheritdoc IBoonty
    function getFixedFees() external view returns (uint256) {
        return _fixedFees;
    }

    /// @inheritdoc IBoonty
    function getFees() external view returns (uint16) {
        return _fees;
    }

    /// @inheritdoc IBoonty
    function getActivitiesERC20() external view returns (address[] memory) {
        return _activitiesERC20;
    }

    /// @inheritdoc IBoonty
    function getActivitiesERC1155() external view returns (address[] memory) {
        return _activitiesERC1155;
    }

    /* -------------------------------------------------------------------------- */
    /*                            Privileged functions                            */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IBoonty
    function setAsset(address asset) external onlyOwner notZeroAddress(asset) {
        _asset = asset;
    }

    /// @inheritdoc IBoonty
    function setBoontySetWhitelist(address boontySetWhitelist) external onlyOwner notZeroAddress(boontySetWhitelist) {
        _boontySetWhitelist = boontySetWhitelist;
    }

    /// @inheritdoc IBoonty
    function setFixedFees(uint256 fixedFees) external onlyOwner {
        _fixedFees = fixedFees;
    }

    /// @inheritdoc IBoonty
    function setFees(uint16 newfees) external onlyOwner {
        // newPositionFee greater than max 2000: 20%
        require(newfees < 2000, "Fees too high");
        _fees = newfees;
    }

    /* -------------------------------------------------------------------------- */
    /*                             External functions                             */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IBoonty
    function createActivityERC20(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        uint256 maxWinners,
        uint16 activityStart,
        uint16 hoursAvailable
    ) external returns (address) {
        require(_activityERC20 != address(0), "Template storage doesn't exist");
        address asset = _asset; // gas savings
        require(IERC20(asset).allowance(msg.sender, address(this)) >= supply, "Increase your allowance");
        address clone = Clones.clone(_activityERC20);
        IERC20(asset).safeTransferFrom(msg.sender, clone, supply);
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

    /// @inheritdoc IBoonty
    function createActivityERC1155(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        string memory uri,
        uint16 activityStart,
        uint16 hoursAvailable,
        address brandAddress
    ) external returns (address) {
        address asset = _asset; // gas savings
        uint256 fixedFees = _fixedFees; // gas savings
        require(IERC20(asset).allowance(msg.sender, address(this)) >= fixedFees, "Increase your allowance");
        IERC20(asset).safeTransferFrom(msg.sender, owner(), fixedFees);
        ActivityERC1155 newActivityERC1155 = new ActivityERC1155(
            _boontySetWhitelist, supply, brandAddress, brandName, activityName, uri, activityStart, hoursAvailable
        );
        _activitiesERC1155.push(address(newActivityERC1155));
        emit ActivityCreated(address(newActivityERC1155));
        return address(newActivityERC1155);
    }
}
