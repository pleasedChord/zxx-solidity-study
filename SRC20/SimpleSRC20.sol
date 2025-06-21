// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract SimpleSRC20 {
    //存储账户余额
    mapping (address => uint256) public balanceOf;
    //存储授权信息
    mapping (address => mapping (address => uint256)) public allowance;
    //初始发行代币
    uint256 public totalSupply;
    //合约所有者
    address public owner;

    //定义事件:交易事件
    event Transfer (address indexed from ,address indexed to, uint256 value);
    //定义事件：授权事件
    event Approval (address indexed owner, address indexed spender, uint256 value);

    //初始化
    constructor () {
        totalSupply = 100 * 10 ** 18;
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    //转账
    function transfer (address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "transfer balance less than the amount");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // 授权功能
    function approve (address spender, uint256 amount) public returns (bool){
        require(balanceOf[msg.sender] >= amount, "approve balance less than the amount");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    // 代扣转账功能
    function transferFrom (address from, address to, uint256 amount) public returns (bool) {
        require(balanceOf[from] >= amount, "transferFrom balance less than the transfer amount");
        uint256 value = allowance[from][msg.sender];
        require(value >= amount, "transferFrom balance less than the approve amount");

        balanceOf[from] -= amount;
        balanceOf[to]   += amount;
        allowance[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        emit Approval(from, msg.sender, amount);
        return true;
    }

    //增发代币（仅所有者）
    function mint (address to, uint256 amount) public  {
        require(msg.sender == owner, "only owner can mint");

        totalSupply += amount;
        balanceOf[to] += amount;

        emit Transfer(address(0), to, amount);
    }
}