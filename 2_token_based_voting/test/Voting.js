const Voting = artifacts.require("Voting");

contract("Voting", accounts => {
  it("should put 10000 Voting in the first account", async () => {
    const instance = await Voting.deployed();
    const balance = await instance.getBalance.call(accounts[0]);
    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
});
