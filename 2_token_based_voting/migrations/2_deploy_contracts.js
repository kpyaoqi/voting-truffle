const Voting = artifacts.require("Voting");

module.exports = function(deployer) {
  deployer.deploy(Voting,10,1,["0xAlice","0xBob","0xCary"]);
};
