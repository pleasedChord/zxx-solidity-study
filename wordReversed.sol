// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract wordRecover {
   function reverse (string calldata word) public pure returns (string memory) {
        bytes memory b = bytes(word);
        bytes memory reversed = new bytes(b.length);

        for (uint i = 0; i < b.length; i++) {
            reversed[i] = b[b.length -1 - i];
        }

        return string(reversed);
   }
}