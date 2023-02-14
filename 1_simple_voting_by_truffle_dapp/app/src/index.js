import { default as Web3 } from 'web3';

import voting_artifacts from '../../build/contracts/Voting.json';
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
let candidates = { "0x1234": "candidate-1", "0x2345": "candidate-2", "0x3456": "candidate-3" };
let sendFrom;
var votingInstance = new web3.eth.Contract(voting_artifacts.abi);

$(document).ready(function () {

  (async () => {

    let candidateNames = Object.keys(candidates);

    await web3.eth.getAccounts().then(function(res){
      sendFrom=res[0];
    });

    await votingInstance.deploy({
      data: voting_artifacts.bytecode,
      arguments: [["0x1234", "0x2345", "0x3456"]]
    }).send({ 
      from: sendFrom, gas: 1500000,gasPrice: '30000000'
    }).then(function (result) {
      votingInstance = new web3.eth.Contract(voting_artifacts.abi, result.options.address);
    });

    for (let i = 0; i < candidateNames.length; i++) {
      let name = candidateNames[i];
      votingInstance.methods.totalVotesFor(name).call({ from: sendFrom}).then(res => {
        console.log(res.toString())
        $("#" + candidates[name]).html(res.toString());
      });
    }
  })();

});

window.voteForCandidate = function () {
  try {
    let candidateName = $("#candidate").val();
    $("#candidate").val("");
    votingInstance.methods.voteForCandidate(candidateName).send({ from: sendFrom }).then(res => {
      let div_id = candidates[candidateName];
      votingInstance.methods.totalVotesFor(candidateName).call().then(res => {
        $("#" + div_id).html(res.toString());
      });
    });
  } catch (error) {
    console.log(error)
  }

}


