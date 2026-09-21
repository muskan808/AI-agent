// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

/// @title DevFund
/// @notice 24-month linear vesting for the development allocation (100 billion MEME).
contract DevFund {
    Token public token;

    uint256 public constant VESTING_PERIOD_MONTHS = 24; // 2 years with linear vesting
    uint256 public constant TOKENS_PER_MONTH = 100_000_000_000 / VESTING_PERIOD_MONTHS;

    uint256 public totalAllocated;
    uint256 public totalReleased;
    uint256 public vestingStartTime;
    address public authority;

    error InvalidAmount();
    error NoTokensAvailable();

    constructor(address token_) {
        token = Token(token_);
        authority = msg.sender;
    }

    function allocateTokens(uint256 amount) external {
        // Ensure that the allocation amount is greater than zero
        if (amount == 0) revert InvalidAmount();

        totalAllocated = amount;
        totalReleased = 0;
        vestingStartTime = block.timestamp;
    }

    function releaseTokens(address recipient) external {
        // Calculate how many months have passed since vesting started
        uint256 elapsedMonths = (block.timestamp - vestingStartTime) / (24 * 3600 * 365); // seconds in a month

        // Ensure we do not release more than allocated
        if (elapsedMonths > VESTING_PERIOD_MONTHS) {
            elapsedMonths = VESTING_PERIOD_MONTHS; // Cap at max months
        }

        uint256 totalReleasable = elapsedMonths * TOKENS_PER_MONTH;

        // Ensure we do not exceed already released tokens
        if (totalReleasable <= totalReleased) revert NoTokensAvailable();

        uint256 amountToRelease = totalReleasable - totalReleased;

        // Transfer tokens to recipient's account
        token.transferFrom(address(this), recipient, amountToRelease);

        // Update released amount
        totalReleased += amountToRelease;
    }
}
