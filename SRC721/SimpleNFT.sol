// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MyNFT {
    
    string private _name;//NFT代币的全名
    string private _symbol;//NFT代币的字母缩写/简称

    mapping (uint256 => address) private _owners;//表示代币(tokenId)所属哪个人(address)
    mapping (address => uint256) private _balances;//表示用户(address)有多少个代币(uint)
    mapping (uint256 => string) private _tokenURIs;//代币id到原数据URI的映射（通常是ipfs链接）

    mapping (uint256 => address) private _tokenApprovals;//代币（tokenId）可以被谁交易（授权地址）
    mapping (address => mapping (address => bool)) private _operatorApprovales;//所有操作员的授权地址

    uint256 private _nextTokenId = 1;//下一个可用的tokenId（计数器）

    address private _owner;//NFT合约所有者

    event Transfer (address indexed from, address indexed to, uint256 indexed tokenId);//事件：交易
    event Approval (address indexed  owner, address indexed spender, uint256 indexed tokenId);//事件：授权
    event ApprovalAll (address indexed owenr, address indexed operator, bool approved);//事件：授权全部

    modifier onlyOwner () {
        require(msg.sender == _owner, "Not owner");
        _;
    }

    //初始化数据
    constructor (string memory name, string memory symbol) {
        _owner = msg.sender;
        _name = name;
        _symbol = _symbol;
    }

    //返回NFT名称
    function name() public view returns (string memory){
        return _name;
    }

    //返回NFT简称
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    //返回指定地址的NFT余额
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "balance for zero address");
        return _balances[msg.sender];
    }

    //返回代币所有者
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "token for zero address");
        return owner;
    }

    //返回代币元数据URI
    function tokenURI (uint256 tokenId) public view returns (string memory){
        require(_owners[tokenId] != address(0), "URI for zero address");
        return _tokenURIs[tokenId];
    }

    //铸造新NFT（仅限合约所有者）
    function mint (address to ,string memory uri) public onlyOwner returns (uint256){
        require(to != address(0), "mint to zero address");

        uint256 tokenId = _nextTokenId++;//获取tokenId

        _owners[tokenId] = to;//更新所有权
        _balances[to] += 1; //更新余额
        _tokenURIs[tokenId] = uri;//记录代币地址

        emit Transfer(msg.sender, to, tokenId);//记录事件

        return tokenId;
    }

    //授权：批准另一个地址转移指定代币
    function approval (address to, uint256 tokenId) public {
        address owner = _owners[tokenId];
        require(owner != to, "Approval to current owner");
        require(owner == msg.sender || _operatorApprovales[owner][msg.sender], "Approval caller is not owner nor approved for all");

        _tokenApprovals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    //为操作员设置批量授权
    function setApprovalForAll (address operator, bool approved) public {
        _operatorApprovales[msg.sender][operator] = approved;
        emit ApprovalAll(msg.sender, operator, approved);
    }

    //检查操作员是否被所有者授权
    function isApprovedForAll (address owner, address operator) public view returns (bool){
        return _operatorApprovales[owner][operator];
    }

    //转移NFT所有权
    function transferFrom (address from, address to, uint256 tokenId) public {
        address owner = _owners[tokenId];
        require(owner == msg.sender || _tokenApprovals[tokenId] == msg.sender || _operatorApprovales[owner][msg.sender], 
        "Transfer caller is not owner nor approved");

        _owners[tokenId] = to;
        _balances[from] -= 1;
        _balances[to] += 1;

        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }

        emit Transfer(from, to, tokenId);//记录交易事件
    }

    // @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165
            interfaceId == 0x80ac58cd || // ERC721
            interfaceId == 0x5b5e139f;  // ERC721Metadata
    }

}