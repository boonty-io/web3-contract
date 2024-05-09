// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Boonty} from "../src/Boonty.sol";
import {MyERC20} from "../src/MyERC20.sol";
import {ActivityERC20} from "../src/ActivityERC20.sol";
import {ActivityERC1155} from "../src/ActivityERC1155.sol";
import {Utils} from "./utils/Utils.sol";

/**
 * @custom:feature Unit test for Boonty contract
 */
contract BoontyTestUnit is Test {
    Boonty public _boonty;
    MyERC20 public _asset;
    ActivityERC20 public _activityERC20;
    ActivityERC1155 public _activityERC1155Address;

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
        _asset = new MyERC20(100000000000);
        _asset.transfer(brand, 100000000000);
        _boonty.setAsset(address(_asset));
        _boonty.setFees(10);
        vm.stopPrank();

        vm.startPrank(brand);
        _asset.approve(address(_boonty), 1000);
        address activityERC20Address = _boonty.createActivityERC20(1000, "BrandName", "activity one", 1, 0, 24);
        _activityERC20 = ActivityERC20(activityERC20Address);
        vm.stopPrank();

        vm.startPrank(brand);
        address activityERC1155Address =
            _boonty.createActivityERC1155(100, "BrandName", "activity one", "URI", 0, 24, brand);
        _activityERC1155Address = ActivityERC1155(activityERC1155Address);
        vm.stopPrank();
    }

    function test_RevertWhen_ERC20ActivityAlreadyInitialized() public {
        vm.startPrank(brand);
        vm.expectRevert(bytes("Already initialized"));
        _activityERC20.initialize(
            address(owner), address(owner), address(_asset), 1000, 10, brand, "BrandName", "activity one", 1, 0, 24
        );
        vm.stopPrank();
    }

    function test_finisheActivityERC1155() public {
        vm.startPrank(brand);
        _activityERC1155Address.activityFinished();
        vm.stopPrank();

        assertEq(_activityERC1155Address.getActivityFinished(), true);
        assertEq(_activityERC1155Address.balanceOf(address(_activityERC1155Address), 0), 0);
    }

    function test_finisheActivityERC20() public {
        vm.startPrank(brand);
        _activityERC20.activityFinished();
        vm.stopPrank();

        uint256 boontyFeesCalculated = 100;

        assertEq(_activityERC20.isActivityFinished(), true);
        assertEq(_asset.balanceOf(address(_activityERC20)), 0);
        assertEq(_asset.balanceOf(brand), 100000000000 - boontyFeesCalculated);
        assertEq(_asset.balanceOf(address(owner)), boontyFeesCalculated);
    }
}
