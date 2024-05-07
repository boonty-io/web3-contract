// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Test} from "forge-std/Test.sol";
import {Boonty} from "../src/Boonty.sol";
import {MyERC20} from "../src/MyERC20.sol";
import {ActivityERC20} from "../src/ActivityERC20.sol";
import {ActivityERC1155} from "../src/ActivityERC1155.sol";
import {Utils} from "./utils/Utils.sol";

/**
 * @custom:feature The admin functions of the Boonty contract.
 */
contract BoontyTestAdmin is Test {
    Boonty public _boonty;
    MyERC20 public _usdtToken;
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
        _usdtToken = new MyERC20(100000000000);
        _usdtToken.transfer(brand, 100000000000);
        _boonty.setUsdtToken(address(_usdtToken));
        vm.stopPrank();

        vm.startPrank(brand);
        _usdtToken.approve(address(_boonty), 1000);
        address activityERC20Address = _boonty.createActivityERC20(1000, "BrandName", "activity one", 1, 0, 24);
        _activityERC20 = ActivityERC20(activityERC20Address);
        vm.stopPrank();

        vm.startPrank(brand);
        address activityERC1155Address =
            _boonty.createActivityERC1155(100, "BrandName", "activity one", "URI", 0, 24, brand);
        _activityERC1155Address = ActivityERC1155(activityERC1155Address);
        vm.stopPrank();
    }

    /**
     * @custom:scenario Call all admin functions from non contract admin.
     * @custom:given The initial Boonty state.
     * @custom:when Non admin wallet trigger admin contract function.
     * @custom:then Each functions should revert with the same custom Ownable error.
     */
    function test_RevertWhen_nonAdminWalletCallAdminFunctions() external {
        // Ownable contract custom error
        bytes memory customError = abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, address(this));

        vm.expectRevert(customError);
        _boonty.setUsdtToken(address(0));

        vm.expectRevert(customError);
        _boonty.setBoontySetWhitelist(address(0));

        vm.expectRevert(customError);
        _boonty.setBoontyFixedFees(0);

        vm.expectRevert(customError);
        _boonty.setBoontyFees(0);

        vm.expectRevert(bytes("Only boontySetWhitelistAddress"));
        _activityERC20.setMerkleRoot(bytes32(0));

        vm.expectRevert(customError);
        _activityERC1155Address.activityFinished();

        vm.expectRevert(bytes("Only boontySetWhitelistAddress"));
        _activityERC1155Address.setMerkleRoot(bytes32(0));
    }
}
