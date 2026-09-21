// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Token
/// @notice MEME ERC-20 used across airdrop, presale, vesting, and liquidity.
contract Token {
    string public name = "MemeCoin";
    string public symbol = "MEME";
    uint8 public decimals = 9;

    uint256 public totalSupply;
    address public authority;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    error InvalidSupply();

    function initialize(uint256 _totalSupply) external {
        // Ensure total supply is not zero
        if (_totalSupply == 0) revert InvalidSupply();

        authority = msg.sender;
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function mint(address to, uint256 amount) external {
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }
}
