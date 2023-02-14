// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Voting {
    //投票人
    struct voter {
        //投票人地址
        address voterAddress;
        //投票数量
        uint256 tokenNum;
        //投票列表
        uint256[] tokensVoteForCandidates;
    }
    //总共token数量
    uint256 public totalTokens;
    //token余额
    uint256 public tokenBalance;
    //token的价钱
    uint256 public tokenPrice;
    //被投票人列表
    string[] candidateList;
    //被投票人的票数
    mapping(string => uint256) public votesReceived;
    //投票人详情
    mapping(address => voter) public voterInfo;

    constructor(
        uint256 totalSupply,
        uint256 price,
        string[] memory candidateNames
    ) {
        totalTokens = totalSupply;
        tokenBalance = totalSupply;
        tokenPrice = price;
        candidateList = candidateNames;
    }

    event voterDetail(string, uint256);

    //根据传入的eth购买token
    function buy() public payable returns (uint256) {
        uint256 tokensToBuy = msg.value / tokenPrice;
        require(tokensToBuy <= tokenBalance);
        voterInfo[msg.sender].voterAddress = msg.sender;
        voterInfo[msg.sender].tokenNum += tokensToBuy;
        tokenBalance -= tokensToBuy;
        return tokensToBuy;
    }

    //投票
    function voteForCandidate(string memory candidate, uint256 voteTokens)
        public
    {
        int256 index = indexOfCandidate(candidate);
        require(index != int256(-1));
        if (voterInfo[msg.sender].tokensVoteForCandidates.length == 0) {
            for (uint256 i = 0; i < candidateList.length; i++) {
                voterInfo[msg.sender].tokensVoteForCandidates.push(0);
            }
        }
        uint256 availableTokens = voterInfo[msg.sender].tokenNum -
            totalUsedTokens(voterInfo[msg.sender].tokensVoteForCandidates);
        require(availableTokens >= voteTokens);
        votesReceived[candidate] += voteTokens;
        voterInfo[msg.sender].tokensVoteForCandidates[uint256(index)] += voteTokens;
    }

    //检查被投票人是否在被投票列表，若在返回索引值
    function indexOfCandidate(string memory candidate)
        internal
        view
        returns (int256)
    {
        for (uint256 i = 0; i < candidateList.length; i++) {
            if (
                keccak256(abi.encodePacked(candidate)) ==
                keccak256(abi.encodePacked(candidateList[i]))
            ) return int256(i);
        }
        return int256(-1);
    }

    //投票人的已投的总票数
    function totalUsedTokens(uint256[] memory votesForCandidate)
        internal
        pure
        returns (uint256)
    {
        uint256 totalToken = 0;
        for (uint256 i = 0; i < votesForCandidate.length; i++) {
            totalToken += votesForCandidate[i];
        }
        return totalToken;
    }

    //查询被投票人的票数详情
    function tokenForCandidates() public {
        for (uint256 i = 0; i < candidateList.length; i++) {
            emit voterDetail(candidateList[i], votesReceived[candidateList[i]]);
        }
    }

    function totalVotesFor(string memory candidate) public view returns (uint256) {
        return votesReceived[candidate];
    }

    //已买Token详情
    function totalSold() public view returns (uint256) {
        return totalTokens - tokenBalance;
    }

    //查询投票人详情
    function voterDetails(address voteradd)
        public
        view
        returns (uint256, uint256[] memory)
    {
        return (
            voterInfo[voteradd].tokenNum,
            voterInfo[voteradd].tokensVoteForCandidates
        );
    }

    //查询所有被投票人
    function allCandidate() public view returns (string[] memory) {
        return candidateList;
    }
}
