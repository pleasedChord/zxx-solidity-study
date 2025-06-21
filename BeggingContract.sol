// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BeggingContract {
    mapping (address => uint256) public donates;//记录捐款人和捐款金额
    address private _owner;//合约所有者

    event DonatesRecived(address indexed donor, uint256 amout);//捐款事件
    event FundsWithdraw(address indexed recipient, uint256 amout);//提取事件

    //初始化
    constructor () {
        _owner = msg.sender;
    }

    //自定义修饰符
    modifier onlyOwner () {
        require(msg.sender == _owner, "only owner");
        _;
    }

    //内部函数：用户向合约发送以太币时的具体操作
    function _recordDonation (address donor, uint256 amount) internal {
        donates[donor] += amount;
        emit DonatesRecived(donor, amount);
    }

    //默认接受以太币的函数(直接转账)
    receive() external payable { 
        _recordDonation(msg.sender, msg.value);
    }

    //用户调用
    function donate () public payable {
        _recordDonation(msg.sender, msg.value);
    }

    //合约所有者提取所有资金
    function withdraw () public onlyOwner payable {
        uint256 balance = address(this).balance;//获取当前合约所有以太币
        (bool success,) = _owner.call{value:balance}("");//提取所有以太币
        require(success, "withdraw failed");
        emit FundsWithdraw(_owner, balance);
    }

    //查询某个地址的捐赠金额
    function getDonation(address donor) public view returns (uint256){
        return donates[donor];
    }
    
}