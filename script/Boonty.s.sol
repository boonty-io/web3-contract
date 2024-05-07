// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "../src/Boonty.sol";

contract BoontyScript is Script {
    function setUp() public {}

    function run() public {
        // Get the environment variable "PRIVATE_KEY"
        uint256 deployer = vm.envUint("PRIVATE_KEY");

        // Use that private key as the account that sends the transactions, saves and logs the them as they occur
        vm.startBroadcast(deployer);

        // Create an instance of the smart contract (doing that will deploy the contract when the script runs)
        Boonty myContract = new Boonty(
            0x607Ec1a7F093801b40DaE21131dDAdB8ce991106
        );

        // Stop using the private key to send transactions
        vm.stopBroadcast();
    }
}
