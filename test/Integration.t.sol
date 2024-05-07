// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Boonty} from "../src/Boonty.sol";
import {MyERC20} from "../src/MyERC20.sol";
import {ActivityERC20} from "../src/ActivityERC20.sol";
import {ActivityERC1155} from "../src/ActivityERC1155.sol";
import {Utils} from "./utils/Utils.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";


/**
 * @custom:feature Integration test for Boonty contract
 */
contract BoontyTestIntegration is Test {
    Boonty public _boonty;
    MyERC20 public _usdtToken;

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
        _boonty = new Boonty(owner);
        _usdtToken = new MyERC20(100000000000);
        _usdtToken.transfer(brand, 100000000000);
        _boonty.setUsdtToken(address(_usdtToken));
        _boonty.setBoontyFixedFees(1000);
        vm.stopPrank();
    }

    function test_CreateActivityERC20() public {
        vm.startPrank(brand);

        _usdtToken.approve(address(_boonty), 1000);

        address activityERC20Address = _boonty.createActivityERC20(1000, "BrandName", "activity one", 1, 0, 24);

        assertNotEq(activityERC20Address, address(0), "ActivityERC20 address should not be zero");

        ActivityERC20 activityERC20 = ActivityERC20(activityERC20Address);
        assertEq(address(activityERC20._owner()), address(brand), "Owner should be the test contract");
        assertEq(activityERC20._usdtToken(), address(_usdtToken), "USDT token address should match");
        vm.stopPrank();
    }

    function test_CreateActivityERC1155() public {
        vm.startPrank(brand);
        _usdtToken.approve(address(_boonty), 1000);

        // Create ActivityERC1155
        address activityERC1155Address =
            _boonty.createActivityERC1155(100, "BrandName", "activity one", "URI", 0, 24, brand);

        assertNotEq(activityERC1155Address, address(0), "ActivityERC1155 address should not be zero");

        ActivityERC1155 activityERC1155 = ActivityERC1155(activityERC1155Address);
        assertEq(address(activityERC1155.owner()), address(brand), "Owner should be the test contract");
        vm.stopPrank();
    }

    function testFuzz_CreateActivityERC20(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        uint256 activityStart,
        uint256 hoursAvailable
    ) public {
        vm.startPrank(brand);
        supply = bound(supply, 1, 100000000000);
        activityStart = bound(activityStart, 1, 2000);
        hoursAvailable = bound(hoursAvailable, 1, 2000);
        _usdtToken.approve(address(_boonty), supply);

        address activityERC20Address =
            _boonty.createActivityERC20(supply, brandName, activityName, 100, activityStart, hoursAvailable);

        ActivityERC20 activityERC20 = ActivityERC20(activityERC20Address);
        assertNotEq(activityERC20Address, address(0), "ActivityERC1155 address should not be zero");

        assertEq(supply, activityERC20.getSupply(), "error in balance");
        assertEq(brandName, activityERC20.getBrandName(), "error in brand name");
        assertEq(activityName, activityERC20.getActivityName(), "error in activity name");
        assertEq(
            block.timestamp + (activityStart * 1 hours), activityERC20.getActivityStart(), "error in activity start"
        );
        assertEq(hoursAvailable, activityERC20.getHoursAvailable(), "error in hours available");
        vm.stopPrank();
    }

    function testFuzz_CreateActivityERC1155(
        uint256 supply,
        string memory brandName,
        string memory activityName,
        string memory uri,
        uint256 activityStart,
        uint256 hoursAvailable
    ) public {
        supply = bound(supply, 1, 100000000000);
        activityStart = bound(activityStart, 1, 100000000000);
        vm.startPrank(brand);
        _usdtToken.approve(address(_boonty), 1000);

        // Create ActivityERC1155
        address activityERC1155Address =
            _boonty.createActivityERC1155(supply, brandName, activityName, uri, activityStart, hoursAvailable, brand);

        ActivityERC1155 activityERC1155 = ActivityERC1155(activityERC1155Address);
        assertNotEq(activityERC1155Address, address(0), "ActivityERC1155 address should not be zero");

        assertEq(supply, activityERC1155.balanceOf(activityERC1155Address, 0), "error in balance");
        assertEq(brandName, activityERC1155._brandName(), "error in brand name");
        assertEq(activityName, activityERC1155._activityName(), "error in activity name");
        assertEq(
            block.timestamp + (activityStart * 1 hours), activityERC1155._activityStart(), "error in activity start"
        );
        assertEq(hoursAvailable, activityERC1155._hoursAvailable(), "error in hours available");
        vm.stopPrank();
    }
}
