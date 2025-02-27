// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Script} from "forge-std-1.9.6/Script.sol";
import {console2} from "forge-std-1.9.6/Test.sol";

import {Boonty} from "src/Boonty.sol";
import {MyERC20} from "src/MyERC20.sol";

contract Deploy is Script {
    /// @notice deploy contract
    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        address initialOwner = vm.envAddress("PUBLIC_KEY");
        MyERC20 erc20 = new MyERC20(1000000);
        Boonty boonty = new Boonty(initialOwner, address(erc20));
        console2.log("erc20 deployed at: ", address(erc20));
        console2.log("Boonty deployed at: ", address(boonty));

        vm.stopBroadcast();
    }
}
