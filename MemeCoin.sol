// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Token.sol";
import "./Airdrop.sol";
import "./Presale.sol";
import "./DevFund.sol";
import "./Liquidity.sol";

/// @title MemeCoin
/// @notice Root contract for the meme coin launch. Wires token, airdrop, presale,
///         team vesting, and liquidity modules.
contract MemeCoin {
    Token public token;
    Airdrop public airdrop;
    Presale public presale;
    DevFund public devFund;
    Liquidity public liquidity;

    address public owner;

    constructor() {
        owner = tx.origin;
        token = new Token();
        airdrop = new Airdrop(address(token));
        presale = new Presale(address(token));
        devFund = new DevFund(address(token));
        liquidity = new Liquidity();
    }

    function bootstrap(uint256 totalSupply) external {
        token.initialize(totalSupply);
        airdrop.initialize(totalSupply / 10, uint64(block.timestamp), 7 days);
        presale.initialize();
        devFund.allocateTokens(100_000_000_000);
        liquidity.initialize(100_000_000_000);
    }

    receive() external payable {}
}
