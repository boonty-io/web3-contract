// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin-contracts-5.2.0/token/ERC20/ERC20.sol";

contract MyERC20 is ERC20 {
    constructor(uint256 initialSupply) ERC20("Gold", "GLD") {
        _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
