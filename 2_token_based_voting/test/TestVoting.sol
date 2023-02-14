// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Voting.sol";

contract TestVoting {
    uint256 public initialBalance = 2 ether;

    function testInitialTokenBalanceUsingDeployedContract() public {
        Voting voting = Voting(DeployedAddresses.Voting());

        uint256 expected = 10000;

        Assert.equal(
            voting.balanceTokens(),
            expected,
            "10000 Tokens not initialized for sale"
        );
    }

    function testBuyTokens() public {
        Voting voting = Voting(DeployedAddresses.Voting());
        voting.buy.value(1 ether)();
        Assert.equal(
            voting.balanceTokens(),
            9900,
            "9900 tokens should have been available"
        );
    }
}
