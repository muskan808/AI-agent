// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Liquidity
/// @notice Tracks MEME sold into the liquidity pool.
contract Liquidity {
    uint256 public totalLiquidity;
    uint256 public soldTokens;
    address public owner;

    error InsufficientLiquidity();

    function initialize(uint256 _totalLiquidity) external {
        owner = msg.sender;
        totalLiquidity = _totalLiquidity; // Total liquidity (100 billion)
        soldTokens = 0; // Initially no tokens sold
    }

    function purchaseTokens(uint256 amount, uint256 price) external payable {
        // Check if enough liquidity is available
        if (totalLiquidity < amount) revert InsufficientLiquidity();

        // Logic for payment and token transfer
        // Deduct amount from available liquidity
        totalLiquidity -= amount;
        soldTokens += amount; // Update sold tokens
    }
}
