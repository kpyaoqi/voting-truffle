const Voting = artifacts.require("Voting");


module.exports = function(deployer) {
  deployer.deploy(Voting,["0x1234","0x2344","0x3456"])
};
