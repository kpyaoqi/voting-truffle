// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
contract Voting{
    mapping (bytes2=>uint8)public votesReceived;
    bytes2[] public candidateList;

    constructor(bytes2[] memory candidateName) {
        candidateList=candidateName;
    }

    //查看某个候选人的票数
    function totalVotesFor(bytes2 candidate)view public returns(uint8){
        require(validCandidate(candidate));
        return votesReceived[candidate];
    }

    //为某个候选人投票
    function  voteForCandidate(bytes2 candidate)public{
        require(validCandidate(candidate));
        votesReceived[candidate]+=1;
    }

    //判断是否为候选人
    function validCandidate(bytes2 candidate) view public returns(bool){
        for(uint i=0;i<candidateList.length;i++){
            if(candidateList[i]==candidate)
                return true;
        }
        return false;
    }
}
