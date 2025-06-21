// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Voting {
    mapping(string => uint256) public votes;
    string[] candidates;

    //投票
    function vote(string calldata name) public {
        if (votes[name] == 0) {
            candidates.push(name);
        }
        votes[name] += 1;
    }

    //查询票数
    function getVotes(string calldata name) public view returns (uint256) {
        return votes[name];
    }

    //清空数据
    function reset() public {
        for (uint i = 0; i < candidates.length; i++) {
            votes[candidates[i]] = 0;
        }
    }

}