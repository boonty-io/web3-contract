// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Script} from "forge-std-1.9.6/Script.sol";

import {Boonty} from "src/Boonty.sol";
import {MyERC20} from "src/MyERC20.sol";

contract Deploy is Script {
    address private constant PUBLIC_KEY = 0x607A577659Cad2A2799120DfdEEde39De2D38706;
    address private constant INITIAL_OWNER = 0x607A577659Cad2A2799120DfdEEde39De2D38706;
    /// @notice deploy contract

    function run() public returns (address erc20, address boonty) {
        vm.startBroadcast();
        erc20 = address(new MyERC20(1000000));
        boonty = address(new Boonty(INITIAL_OWNER, erc20));

        vm.stopBroadcast();
    }
}
