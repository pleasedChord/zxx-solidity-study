// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract NumToRoma {

    mapping(string => uint) rules;

    function setMappings () public{
        rules["I"] = 1;
        rules["V"] = 5;
        rules["X"] = 10;
        rules["L"] = 50;
        rules["C"] = 100;
        rules["D"] = 500;
        rules["M"] = 1000;
    }

    function numToRoma (uint num) public pure returns (string memory){
        uint qian = num / 1000;
        uint bai = (num / 100) % 10;
        uint shi = (num / 10) % 10;
        uint ge = num % 10;

        bytes[] memory results = new bytes[](qian + bai + shi + ge);
        uint index = 0;
        for (uint i = 0; i < qian; i++) {
            results[index++] = "M";
        }

        if (bai > 5) {
            results[index++] = "D";
            for (uint i = 0; i < bai - 5; i++) {
                results[index++] = "C";
            }
        }else if (bai == 4) {
            results[index++] = "XC";
        } else {
            for (uint i = 0; i < bai; i++) {
                results[index++] = "C";
            }
        }

        if (shi > 5) {
            results[index++] = "L";
            for (uint i = 0; i < shi - 5; i++) {
                results[index++] = "X";
            }
        } else if (shi == 4) {
            results[index++] = "IX";
        } else {
            for (uint i = 0; i < shi; i++) {
                results[index++] = "X";
            }
        }

        if (ge > 5) {
            results[index++] = "V";
            for (uint i = 0; i < ge - 5; i++) {
                results[index++] = "I";
            }
        } else if (ge == 4) {
            results[index++] = "IV";
        } else {
            for (uint i = 0; i < ge; i++) {
                results[index++] = "I";
            }
        }
    }

    function romaToNum (string memory word) public view returns (uint) {

    }
    
}