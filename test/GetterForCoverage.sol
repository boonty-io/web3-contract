// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin-contracts-5.2.0/access/Ownable.sol";
import {Test} from "forge-std-1.9.6/Test.sol";
import {Boonty} from "../src/Boonty.sol";
import {MyERC20} from "../src/MyERC20.sol";
import {ActivityERC20} from "../src/ActivityERC20.sol";
import {ActivityERC1155} from "../src/ActivityERC1155.sol";
import {Utils} from "./utils/Utils.sol";

/**
 * @custom:feature The getter functions of the Boonty contract.
 */
contract BoontyTestGetter is Test {
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
        _boonty = new Boonty(owner, owner);
        _asset = new MyERC20(100 ether);
        _asset.transfer(brand, 100 ether);
        _boonty.setBoontySetWhitelist(owner);
        _boonty.setAsset(address(_asset));
        _boonty.setFees(100);
        _boonty.setFixedFees(10 ether);
        vm.stopPrank();

        vm.startPrank(brand);
        _asset.approve(address(_boonty), 1000);
        address activityERC20Address = _boonty.createActivityERC20(1000, "BrandName", "activity one", 1, 0, 24);
        _activityERC20 = ActivityERC20(activityERC20Address);
        vm.stopPrank();

        vm.startPrank(brand);
        _asset.approve(address(_boonty), 10 ether);
        address activityERC1155Address =
            _boonty.createActivityERC1155(100, "BrandName", "activity one", "URI", 0, 24, brand);
        _activityERC1155Address = ActivityERC1155(activityERC1155Address);
        vm.stopPrank();
    }

    function test_getterFunctions() public view {
        /* -------------------------------------------------------------------------- */
        /*                                   Boonty                                   */
        /* -------------------------------------------------------------------------- */

        assertEq(_boonty.getAsset(), address(_asset), "getAsset() failed");
        assertNotEq(_boonty.getActivityERC20(), address(0), "getActivityERC20() failed");
        assertEq(_boonty.getBoontySetWhitelist(), owner, "getBoontySetWhitelist() failed");
        address[] memory expectedActivitiesERC20 = new address[](1);
        expectedActivitiesERC20[0] = address(_activityERC20);
        assertEq(_boonty.getActivitiesERC20(), expectedActivitiesERC20, "getActivitiesERC20() failed");
        address[] memory expectedActivitiesERC1155 = new address[](1);
        expectedActivitiesERC1155[0] = address(_activityERC1155Address);
        assertEq(_boonty.getActivitiesERC1155(), expectedActivitiesERC1155, "getActivitiesERC1155() failed");

        /* -------------------------------------------------------------------------- */
        /*                                   ERC1155                                  */
        /* -------------------------------------------------------------------------- */

        bytes32 emptyMerkleRoot;
        assertEq(_activityERC1155Address.getMerkleRoot(), emptyMerkleRoot, "getMerkleRoot() failed");
        assertEq(_activityERC1155Address.getBoontySetWhitelist(), owner, "getBoontySetWhitelist() failed");

        /* -------------------------------------------------------------------------- */
        /*                                    ERC20                                   */
        /* -------------------------------------------------------------------------- */

        assertEq(_activityERC20.getMerkleRoot(), emptyMerkleRoot, "getMerkleRoot() failed");
        assertEq(_activityERC20.getBoontyAddress(), owner, "getBoontyAddress() failed");
        assertEq(_activityERC20.getBoontySetWhitelist(), owner, "_boontySetWhitelist() failed");
        assertEq(_activityERC20.getMerkleRoot(), emptyMerkleRoot, "getMerkleRoot() failed");
        assertEq(_activityERC20.getSupply(), 1000 - 10, "getSupply() failed");
        assertEq(_activityERC20.getBoontyToken(), 10, "getBoontyToken() failed");
    }
}
