// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std-1.9.6/Test.sol";
import {Boonty} from "../src/Boonty.sol";
import {MyERC20} from "../src/MyERC20.sol";
import {ActivityERC20} from "../src/ActivityERC20.sol";
import {ActivityERC1155} from "../src/ActivityERC1155.sol";
import {Utils} from "./utils/Utils.sol";
import {FixedPointMathLib} from "solady-0.1.10/utils/FixedPointMathLib.sol";

/**
 * @custom:feature Integration test for Boonty contract
 */
contract BoontyTestIntegration is Test {
    Boonty public _boonty;
    MyERC20 public _asset;

    Utils internal utils;
    address payable[] internal users;
    address internal owner;
    address internal dev;
    address internal brand;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(3);
        owner = users[0];
        vm.label(owner, "Owner");
        dev = users[1];
        vm.label(dev, "Developer");
        brand = users[2];
        vm.label(brand, "Brand");

        emit log_address(owner);
        emit log_address(dev);
        emit log_address(brand);

        vm.startPrank(owner);
        _boonty = new Boonty(owner, owner);
        _asset = new MyERC20(100 ether);
        _asset.transfer(brand, 100 ether);
        _boonty.setBoontySetWhitelist(owner);
        _boonty.setAsset(address(_asset));
        _boonty.setFees(100);
        _boonty.setFixedFees(10 ether);
        vm.stopPrank();
    }

    /* -------------------------------------------------------------------------- */
    /*                                   Boonty                                   */
    /* -------------------------------------------------------------------------- */

    /* -------------------------------------------------------------------------- */
    /*                                   ERC115                                   */
    /* -------------------------------------------------------------------------- */

    function testFuzz_CreateActivityERC1155(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        string memory uri,
        uint16 activityStart,
        uint16 hoursAvailable
    ) public {
        vm.startPrank(brand);
        _asset.approve(address(_boonty), 10 ether);

        // Create ActivityERC1155
        address activityERC1155Address =
            _boonty.createActivityERC1155(supply, brandName, activityName, uri, activityStart, hoursAvailable, brand);

        ActivityERC1155 activityERC1155 = ActivityERC1155(activityERC1155Address);
        assertNotEq(activityERC1155Address, address(0), "ActivityERC1155 address should not be zero");

        assertEq(brand, activityERC1155.owner(), "error owner");
        assertEq(supply, activityERC1155.balanceOf(activityERC1155Address, 0), "error in balance");
        assertEq(brandName, activityERC1155.getBrandName(), "error in brand name");
        assertEq(activityName, activityERC1155.getActivityName(), "error in activity name");
        assertEq(
            block.timestamp + (uint256(activityStart) * 1 hours),
            activityERC1155.getActivityStart(),
            "error in activity start"
        );
        assertEq(hoursAvailable, activityERC1155.getHoursAvailable(), "error in hours available");
        vm.stopPrank();
    }

    function test_CreateActivityERC1155() public {
        vm.startPrank(brand);
        _asset.approve(address(_boonty), 10 ether);

        // Create ActivityERC1155
        address activityERC1155Address =
            _boonty.createActivityERC1155(100, "BrandName", "activity one", "URI", 0, 24, brand);

        assertNotEq(activityERC1155Address, address(0), "ActivityERC1155 address should not be zero");

        ActivityERC1155 activityERC1155 = ActivityERC1155(activityERC1155Address);
        assertEq(address(activityERC1155.owner()), address(brand), "Owner should be the test contract");
        vm.stopPrank();
    }

    /* -------------------------------------------------------------------------- */
    /*                                    ERC20                                   */
    /* -------------------------------------------------------------------------- */

    function testFuzz_CreateActivityERC20(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        uint16 activityStart,
        uint16 hoursAvailable
    ) public {
        vm.startPrank(brand);
        uint256 balance = _asset.balanceOf(brand);
        uint256 total = supply < balance ? supply : supply - balance;
        _asset.mint(brand, total);
        _asset.approve(address(_boonty), supply);

        uint256 fees = uint256(_boonty.getFees());

        address activityERC20Address =
            _boonty.createActivityERC20(supply, brandName, activityName, 100, activityStart, hoursAvailable);

        ActivityERC20 activityERC20 = ActivityERC20(activityERC20Address);
        assertNotEq(activityERC20Address, address(0), "ActivityERC1155 address should not be zero");

        uint256 newSupply = supply - FixedPointMathLib.fullMulDiv(supply, fees, uint256(activityERC20.BPS_DIVISOR()));
        assertEq(_asset.balanceOf(address(activityERC20)), supply - (newSupply % 100), "error in balance");
        assertEq(brandName, activityERC20.getBrandName(), "error in brand name");
        assertEq(activityName, activityERC20.getActivityName(), "error in activity name");
        assertEq(
            block.timestamp + (uint256(activityStart) * 1 hours),
            activityERC20.getActivityStart(),
            "error in activity start"
        );
        assertEq(hoursAvailable, activityERC20.getHoursAvailable(), "error in hours available");
        vm.stopPrank();
    }

    function test_CreateActivityERC20() public {
        vm.startPrank(brand);

        _asset.approve(address(_boonty), 1000);

        address activityERC20Address = _boonty.createActivityERC20(1000, "BrandName", "activity one", 1, 0, 24);

        assertNotEq(activityERC20Address, address(0), "ActivityERC20 address should not be zero");

        ActivityERC20 activityERC20 = ActivityERC20(activityERC20Address);
        assertEq(address(activityERC20.getOwner()), address(brand), "Owner should be the test contract");
        assertEq(activityERC20.getAsset(), address(_asset), "USDT token address should match");
        vm.stopPrank();
    }
}
