// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std-1.9.6/Test.sol";
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
    address internal test0;
    address internal test1;
    address internal test2;
    address internal test3;
    address internal test4;

    /* -------------------------------------------------------------------------- */
    /*                                   Merkle                                   */
    /* -------------------------------------------------------------------------- */

    bytes32 merkleRoot = 0xfbaa96a1f7806c1ab06f957c8fc6e60875b6880254f77b71439c7854a6b47755;

    address[4] whitelistAddresses = [
        0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
        0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,
        0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB,
        0x617F2E2fD72FD9D5503197092aC168c91465E7f2
    ];

    //proofs for the whitelist addresses generated offchain
    bytes32[2][4] proofs = [
        [
            bytes32(0x04a10bfd00977f54cc3450c9b25c9b3a502a089eba0097ba35fc33c4ea5fcb54),
            bytes32(0xda2a605bdf59a3b18e24cd0b2d9110b6ffa2340f6f67bc48214ac70e49d12770)
        ],
        [
            bytes32(0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb),
            bytes32(0xda2a605bdf59a3b18e24cd0b2d9110b6ffa2340f6f67bc48214ac70e49d12770)
        ],
        [
            bytes32(0xf6d82c545c22b72034803633d3dda2b28e89fb704f3c111355ac43e10612aedc),
            bytes32(0x39a01635c6a38f8beb0adde454f205fffbb2157797bf1980f8f93a5f70c9f8e6)
        ],
        [
            bytes32(0xdfbe3e504ac4e35541bebad4d0e7574668e16fefa26cd4172f93e18b59ce9486),
            bytes32(0x39a01635c6a38f8beb0adde454f205fffbb2157797bf1980f8f93a5f70c9f8e6)
        ]
    ];

    bytes32[2] proofOne = [
        bytes32(0x04a10bfd00977f54cc3450c9b25c9b3a502a089eba0097ba35fc33c4ea5fcb54),
        bytes32(0xda2a605bdf59a3b18e24cd0b2d9110b6ffa2340f6f67bc48214ac70e49d12770)
    ];
    bytes32[] dynamicProof = new bytes32[](2);

    /* -------------------------------------------------------------------------- */
    /*                                    Setup                                   */
    /* -------------------------------------------------------------------------- */

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(8);
        owner = users[0];
        vm.label(owner, "Owner");
        dev = users[1];
        vm.label(dev, "Developer");
        brand = users[2];
        vm.label(brand, "Brand");
        test0 = users[3];
        vm.label(test0, "0");
        test1 = users[4];
        vm.label(test1, "1");
        test2 = users[5];
        vm.label(test2, "2");
        test3 = users[6];
        vm.label(test3, "3");
        test4 = users[7];
        vm.label(test4, "4");

        dynamicProof[0] = proofOne[0];
        dynamicProof[1] = proofOne[1];

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

    /* -------------------------------------------------------------------------- */
    /*                                   Boonty                                   */
    /* -------------------------------------------------------------------------- */

    function test_constructor() public {
        vm.prank(owner);
        Boonty newBoonty = new Boonty(owner, owner);
        assertEq(newBoonty.owner(), owner);
        assertNotEq(newBoonty.getActivityERC20(), address(0));
        assertEq(newBoonty.getBoontySetWhitelist(), owner);
    }

    function test_RevertWhen_enoughtAllowanceERC20() public {
        vm.startPrank(brand);
        _asset.approve(address(_boonty), 999);
        assertEq(_asset.allowance(brand, address(_boonty)), 999);
        vm.expectRevert(bytes("Increase your allowance"));
        _boonty.createActivityERC20(1000, "BrandName", "activity one", 1, 0, 24);
    }

    function test_RevertWhen_enoughtAllowanceERC1155() public {
        vm.startPrank(brand);
        _asset.approve(address(_boonty), 10 ether - 1);
        assertEq(_boonty.getFixedFees() - 1, 10 ether - 1);
        vm.expectRevert(bytes("Increase your allowance"));
        _boonty.createActivityERC1155(100, "BrandName", "activity one", "URI", 0, 24, brand);
        vm.stopPrank();
    }

    function test_setFees() public {
        vm.startPrank(owner);
        _boonty.setFees(1999);
        assertEq(_boonty.getFees(), 1999);
        vm.expectRevert(bytes("Fees too high"));
        _boonty.setFees(2001);
        assertEq(_boonty.getFees(), 1999);
        vm.stopPrank();
    }

    /* -------------------------------------------------------------------------- */
    /*                                   ERC1155                                  */
    /* -------------------------------------------------------------------------- */

    function test_finishActivityERC1155() public {
        vm.startPrank(brand);
        _activityERC1155Address.activityFinished();
        vm.stopPrank();

        assertEq(_activityERC1155Address.getActivityFinished(), true);
        assertEq(_activityERC1155Address.balanceOf(address(_activityERC1155Address), 0), 0);
    }

    function test_checkInWhitelistERC1155() public {
        vm.prank(owner);
        _activityERC1155Address.setMerkleRoot(merkleRoot);

        bool isWhitelisted = _activityERC1155Address.checkInWhitelist(whitelistAddresses[0], dynamicProof);
        assertTrue(isWhitelisted, "error in checkInWhitelistERC1155");

        isWhitelisted = _activityERC1155Address.checkInWhitelist(owner, dynamicProof);
        assertFalse(isWhitelisted, "error in checkInWhitelistERC1155");
    }

    function test_withdrawPrizeERC1155() public {
        vm.prank(owner);
        _activityERC1155Address.setMerkleRoot(merkleRoot);

        uint256 balanceWinnerBefore = _activityERC1155Address.balanceOf(whitelistAddresses[0], 0);
        uint256 balanceActivityBefore = _activityERC1155Address.balanceOf(address(_activityERC1155Address), 0);
        _activityERC1155Address.withdrawPrize(whitelistAddresses[0], dynamicProof);
        uint256 balanceWinnerAfter = _activityERC1155Address.balanceOf(whitelistAddresses[0], 0);
        uint256 balanceActivityAfter = _activityERC1155Address.balanceOf(address(_activityERC1155Address), 0);
        assertEq(balanceWinnerAfter, balanceWinnerBefore + 1, "error in withdrawPrizeERC1155");
        assertEq(balanceActivityAfter, balanceActivityBefore - 1, "error in withdrawPrizeERC1155");

        vm.expectRevert(bytes("You cannot withdraw the prize"));
        _activityERC1155Address.withdrawPrize(owner, dynamicProof);
        vm.expectRevert(bytes("Reward already collected"));
        _activityERC1155Address.withdrawPrize(whitelistAddresses[0], dynamicProof);
    }

    /* -------------------------------------------------------------------------- */
    /*                                    ERC20                                   */
    /* -------------------------------------------------------------------------- */

    function test_RevertWhen_ERC20ActivityAlreadyInitialized() public {
        vm.startPrank(brand);
        vm.expectRevert(bytes("Already initialized"));
        _activityERC20.initialize(
            address(owner), address(owner), address(_asset), 1000, 10, brand, "BrandName", "activity one", 1, 0, 24
        );
        vm.stopPrank();
    }

    function test_finishActivityERC20BeforeDate() public {
        uint256 balanceBefore = _asset.balanceOf(address(brand));
        vm.startPrank(brand);
        _activityERC20.activityFinished();
        vm.stopPrank();

        assertEq(_activityERC20.isActivityFinished(), true);
        assertEq(_asset.balanceOf(address(_activityERC20)), 0);
        assertEq(_asset.balanceOf(address(brand)), balanceBefore + 1000 - 10);
    }

    function test_finishActivityERC20AfterDateOwner() public {
        uint256 timestampFinished = _activityERC20.getWhenActivityFinished();
        vm.warp(timestampFinished + 1);

        uint256 balanceBefore = _asset.balanceOf(address(brand));
        vm.startPrank(brand);
        _activityERC20.activityFinished();
        vm.stopPrank();

        assertEq(_activityERC20.isActivityFinished(), true);
        assertEq(_asset.balanceOf(address(_activityERC20)), 0);
        assertEq(_asset.balanceOf(address(brand)), balanceBefore + 1000 - 10);
    }

    function test_finishActivityERC20AfterDateBoonty() public {
        uint256 timestampFinished = _activityERC20.getWhenActivityFinished();
        vm.warp(timestampFinished + 1);

        uint256 balanceBefore = _asset.balanceOf(address(brand));
        vm.startPrank(owner);
        _activityERC20.activityFinished();
        vm.stopPrank();

        assertEq(_activityERC20.isActivityFinished(), true);
        assertEq(_asset.balanceOf(address(_activityERC20)), 0);
        assertEq(_asset.balanceOf(address(brand)), balanceBefore + 1000 - 10);
    }

    function test_finishActivityERC20BAfterAllDistributedOwner() public {
        vm.prank(owner);
        _activityERC20.setMerkleRoot(merkleRoot);
        _activityERC20.withdrawPrize(whitelistAddresses[0], dynamicProof);

        uint256 balanceBefore = _asset.balanceOf(address(owner));
        vm.startPrank(brand);
        _activityERC20.activityFinished();
        vm.stopPrank();
        assertEq(_activityERC20.isActivityFinished(), true);
        assertEq(_asset.balanceOf(address(_activityERC20)), 0);
        assertEq(_asset.balanceOf(address(owner)), balanceBefore + 10);
    }

    function test_finishActivityERC20BAfterAllDistributedBoonty() public {
        vm.prank(owner);
        _activityERC20.setMerkleRoot(merkleRoot);
        _activityERC20.withdrawPrize(whitelistAddresses[0], dynamicProof);

        uint256 balanceBefore = _asset.balanceOf(address(owner));
        vm.startPrank(owner);
        _activityERC20.activityFinished();
        vm.stopPrank();
        assertEq(_activityERC20.isActivityFinished(), true);
        assertEq(_asset.balanceOf(address(_activityERC20)), 0);
        assertEq(_asset.balanceOf(address(owner)), balanceBefore + 10);
    }

    function test_checkInWhitelistERC20() public {
        vm.prank(owner);
        _activityERC20.setMerkleRoot(merkleRoot);

        bool isWhitelisted = _activityERC20.checkInWhitelist(whitelistAddresses[0], dynamicProof);
        assertTrue(isWhitelisted, "error in checkInWhitelistERC1155");

        isWhitelisted = _activityERC20.checkInWhitelist(owner, dynamicProof);
        assertFalse(isWhitelisted, "error in checkInWhitelistERC1155");
    }

    function test_withdrawPrizeERC20() public {
        vm.prank(owner);
        _activityERC20.setMerkleRoot(merkleRoot);

        uint256 balanceWinnerBefore = _asset.balanceOf(whitelistAddresses[0]);
        uint256 balanceActivityBefore = _asset.balanceOf(address(_activityERC20));
        _activityERC20.withdrawPrize(whitelistAddresses[0], dynamicProof);
        uint256 balanceWinnerAfter = _asset.balanceOf(whitelistAddresses[0]);
        uint256 balanceActivityAfter = _asset.balanceOf(address(_activityERC20));
        assertEq(balanceWinnerAfter, balanceWinnerBefore + _activityERC20.getShares(), "error in withdrawPrizeERC20");
        assertEq(
            balanceActivityAfter, balanceActivityBefore - _activityERC20.getShares(), "error in withdrawPrizeERC20"
        );

        vm.expectRevert(bytes("You cannot withdraw the prize"));
        _activityERC20.withdrawPrize(owner, dynamicProof);
        vm.expectRevert(bytes("Tokens already claimed"));
        _activityERC20.withdrawPrize(whitelistAddresses[0], dynamicProof);
    }
}
