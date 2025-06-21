// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address public owner;

    constructor (uint256 initialSupply) ERC20 ("MyToken", "ZXX") {
        owner = msg.sender;
        _mint(msg.sender, initialSupply);
    }

    function mint (address to, uint256 amount) public {
        require(msg.sender == owner, "only owner can mint");
        _mint(to, amount);
    }
}