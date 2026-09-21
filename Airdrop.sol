// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";

/// @title Airdrop
/// @notice Time-bounded whitelist airdrop of MEME tokens.
contract Airdrop {
    Token public token;

    uint64 public startTime;
    uint64 public endTime;
    uint256 public totalTokens;
    uint256 public distributedTokens;
    mapping(address => bool) public whitelisted;
    uint256 public whitelistCount;

    address public authority;

    event UserWhitelisted(address indexed user);
    event TokenDistributed(address indexed recipient, uint256 amount);

    error AirdropNotStarted();
    error AirdropAlreadyEnded();
    error UserNotWhitelisted();
    error UserAlreadyWhitelisted();
    error NoUsersWhitelisted();
    error ExceedsTotalTokens();

    constructor(address token_) {
        token = Token(token_);
        authority = msg.sender;
    }

    function initialize(uint256 _totalTokens, uint64 _startTime, uint64 _duration) external {
        startTime = _startTime; // Airdrop start time
        endTime = _startTime + _duration; // Airdrop end time
        totalTokens = _totalTokens; // Total tokens allocated for airdrop
        distributedTokens = 0; // Tokens already distributed
    }

    function whitelistUser() external {
        if (whitelisted[msg.sender]) revert UserAlreadyWhitelisted();
        whitelisted[msg.sender] = true;
        whitelistCount += 1;
        emit UserWhitelisted(msg.sender);
    }

    function distributeAirdrop(address recipient) external {
        // Check if the airdrop has started or not
        if (block.timestamp < startTime) revert AirdropNotStarted();

        // Check if the airdrop has ended
        if (block.timestamp >= endTime) revert AirdropAlreadyEnded();

        // Check if recipient is whitelisted
        if (!whitelisted[recipient]) revert UserNotWhitelisted();

        // Calculate tokens per user and ensure valid distribution
        if (whitelistCount == 0) revert NoUsersWhitelisted();

        uint256 tokensPerUser = totalTokens / whitelistCount;

        // Ensure total distributed tokens do not exceed total tokens allocated
        if (distributedTokens + tokensPerUser > totalTokens) revert ExceedsTotalTokens();

        token.transfer(recipient, tokensPerUser);

        distributedTokens += tokensPerUser;
        emit TokenDistributed(recipient, tokensPerUser);
    }
}
