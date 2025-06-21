// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BinarySearch {

    function search (uint[] memory sourse, uint target) public pure returns (uint) {

        uint left = 0;
        uint right =  sourse.length;

        while (left < right) {
            uint mod = left + (right - left)/2;

            if (sourse[mod] == target) {
                return mod;
            } else if (sourse[mod] > target) {
                //去左边找
                right = mod;
            } else {
                //去右边找
                left = mod + 1;
            }
        }
        return type(uint).max;//未找到目标
    }
}