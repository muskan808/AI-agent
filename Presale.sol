// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

/// @title Presale
/// @notice Tiered-price MEME presale paid in ETH.
contract Presale {
    Token public token;

    uint256 public totalSold;
    address public authority;

    error PresaleEnded();
    error InvalidAmount();
    error InsufficientFunds();
    error OverflowError();

    constructor(address token_) {
        token = Token(token_);
        authority = msg.sender;
    }

    function initialize() external {}

    function buyTokens(uint256 amount) external payable {
        // Ensure that the amount requested is greater than zero
        if (amount == 0) revert InvalidAmount();

        // Determine the price based on the amount being purchased
        uint256 pricePerToken;
        if (totalSold < 50_000_000_000) {
            pricePerToken = 0.0001 ether; // Price for first 50 billion tokens
        } else if (totalSold < 100_000_000_000) {
            pricePerToken = 0.0002 ether; // Price for next 50 billion tokens
        } else if (totalSold < 150_000_000_000) {
            pricePerToken = 0.0003 ether; // Price for last 50 billion tokens
        } else {
            revert PresaleEnded();
        }

        // Calculate total cost in wei (1 ETH = 1e18 wei)
        uint256 totalCost = amount * pricePerToken;

        // Check if buyer has sent enough ETH
        if (msg.sender.balance < totalCost) revert InsufficientFunds();

        // Mint tokens to buyer's account
        token.mint(msg.sender, amount);

        // Update total sold safely
        uint256 newSold = totalSold + amount;
        if (newSold < totalSold) revert OverflowError();
        totalSold = newSold;
    }
}
