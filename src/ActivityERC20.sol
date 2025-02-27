// SPDX-License-Identifier: lilyan bastien Siren 983058728
pragma solidity 0.8.20;

import "@openzeppelin-contracts-5.2.0/utils/cryptography/MerkleProof.sol";
import "@openzeppelin-contracts-5.2.0/token/ERC20/IERC20.sol";
import "@openzeppelin-contracts-5.2.0/utils/math/Math.sol";
import {SafeERC20} from "@openzeppelin-contracts-5.2.0/token/ERC20/utils/SafeERC20.sol";
import {FixedPointMathLib} from "solady-0.1.10/utils/FixedPointMathLib.sol";

import "./interfaces/IActivityERC20.sol";

/**
 * @title ActivityERC20
 * @dev A contract representing an ERC20-based activity.
 */
contract ActivityERC20 is IActivityERC20 {
    using Math for uint256;
    using SafeERC20 for IERC20;

    uint32 public constant BPS_DIVISOR = 10_000; // Denominator for the reward multiplier, will give us a 0.01% basis point

    bytes32 internal _merkleRoot; // Merkle root for whitelist verification
    address internal _boontyAddress; // Boonty owner address
    string internal _brandName; // Brand name of the activity
    string internal _activityName; // Name of the activity
    address internal _boontySetWhitelist; // Address can set the whitelist
    address internal _asset; // USDT/USDC token address
    uint256 internal _supply; // Total supply of ERC20 tokens for the activity
    uint256 internal _boontyToken; // Boonty fees
    uint256 internal _shares; // Share of tokens per winner
    uint256 internal _activityStart; // Start time of the activity
    uint256 internal _hoursAvailable; // Duration of the activity in hours
    address internal _owner; // Brand owner address
    bool internal _activityFinished; // Activity finished flag

    mapping(address => bool) public claimed; // Mapping of claimed prizes
    uint256 public _totalClaimed; // Total claimed prizes

    /// @inheritdoc IActivityERC20
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
    ) external {
        require(_owner == address(0), "Already initialized");
        _owner = brandAddress;
        _boontyAddress = boontyAddress;
        _boontySetWhitelist = boontySetWhitelist;
        _asset = asset;
        uint256 newSupply = supply - FixedPointMathLib.fullMulDiv(supply, fees, uint256(BPS_DIVISOR)); // gas savings
        _supply = newSupply - newSupply % maxWinners;
        _brandName = brandName;
        _activityName = activityName;
        _shares = newSupply / maxWinners;
        IERC20(asset).safeTransfer(brandAddress, newSupply % maxWinners);
        _boontyToken = supply - newSupply;
        _activityStart = block.timestamp + (uint256(activityStart) * 1 hours);
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

    /* -------------------------------------------------------------------------- */
    /*                              Getter functions                              */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IActivityERC20
    function getMerkleRoot() external view returns (bytes32) {
        return _merkleRoot;
    }

    /// @inheritdoc IActivityERC20
    function getBoontyAddress() external view returns (address) {
        return _boontyAddress;
    }

    /// @inheritdoc IActivityERC20
    function getBrandName() external view returns (string memory) {
        return _brandName;
    }

    /// @inheritdoc IActivityERC20
    function getActivityName() external view returns (string memory) {
        return _activityName;
    }

    /// @inheritdoc IActivityERC20
    function getBoontySetWhitelist() external view returns (address) {
        return _boontySetWhitelist;
    }

    /// @inheritdoc IActivityERC20
    function getAsset() external view returns (address) {
        return _asset;
    }

    /// @inheritdoc IActivityERC20
    function getSupply() external view returns (uint256) {
        return _supply;
    }

    /// @inheritdoc IActivityERC20
    function getBoontyToken() external view returns (uint256) {
        return _boontyToken;
    }

    /// @inheritdoc IActivityERC20
    function getShares() external view returns (uint256) {
        return _shares;
    }

    /// @inheritdoc IActivityERC20
    function getHoursAvailable() external view returns (uint256) {
        return _hoursAvailable;
    }

    /// @inheritdoc IActivityERC20
    function getWhenActivityFinished() external view returns (uint256) {
        return _activityStart + (_hoursAvailable * 1 hours);
    }

    /// @inheritdoc IActivityERC20
    function getActivityStart() external view returns (uint256) {
        return _activityStart;
    }

    /// @inheritdoc IActivityERC20
    function getOwner() external view returns (address) {
        return _owner;
    }

    /// @inheritdoc IActivityERC20
    function isActivityFinished() external view returns (bool) {
        return _activityFinished;
    }

    /* -------------------------------------------------------------------------- */
    /*                            Privileged functions                            */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IActivityERC20
    function setMerkleRoot(bytes32 merkleRoot) external {
        require(msg.sender == _boontySetWhitelist, "Only boontySetWhitelistAddress");
        _merkleRoot = merkleRoot;
    }

    /* -------------------------------------------------------------------------- */
    /*                              Public functions                              */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IActivityERC20
    function activityFinished() public {
        require(!_activityFinished, "Activity finished");

        if (_totalClaimed * _shares == _supply) {
            require(msg.sender == _owner || msg.sender == _boontyAddress);
            _activityFinished = true;

            IERC20(_asset).safeTransfer(_boontyAddress, _boontyToken);
        } else if (block.timestamp <= _activityStart + (_hoursAvailable * 1 hours)) {
            require(msg.sender == _owner);
            _activityFinished = true;

            IERC20(_asset).safeTransfer(_boontyAddress, _boontyToken);
            uint256 balance = IERC20(_asset).balanceOf(address(this));
            IERC20(_asset).safeTransfer(_owner, balance);
        } else if (block.timestamp > _activityStart + (_hoursAvailable * 1 hours)) {
            require(msg.sender == _owner || msg.sender == _boontyAddress);
            _activityFinished = true;

            IERC20(_asset).safeTransfer(_boontyAddress, _boontyToken);
            uint256 balance = IERC20(_asset).balanceOf(address(this));
            IERC20(_asset).safeTransfer(_owner, balance);
        }
    }

    /// @inheritdoc IActivityERC20
    function checkInWhitelist(address user, bytes32[] calldata proof) public view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(user));
        return MerkleProof.verify(proof, _merkleRoot, leaf);
    }

    /* -------------------------------------------------------------------------- */
    /*                             External functions                             */
    /* -------------------------------------------------------------------------- */

    /// @inheritdoc IActivityERC20
    function withdrawPrize(address user, bytes32[] calldata proof) external activityNotFinished {
        require(checkInWhitelist(user, proof), "You cannot withdraw the prize");
        require(!claimed[user], "Tokens already claimed");
        claimed[user] = true;
        _totalClaimed += 1;
        uint256 shares = _shares;
        IERC20(_asset).safeTransfer(user, shares);
        emit ClaimedBy(user, shares, block.timestamp);
    }
}
