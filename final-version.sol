// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {
    address public owner;
    uint256 public proposalCount;

    struct Proposal {
        string description;
        uint256 totalVotes;
        mapping(address => bool) hasVoted;
        mapping(uint8 => uint256) voteCount;
        bool isOpen;
    }

    mapping(uint256 => Proposal) public proposals;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier proposalExists(uint256 _proposalId) {
        require(_proposalId <= proposalCount && _proposalId > 0, "Proposal does not exist");
        _;
    }

    modifier proposalOpen(uint256 _proposalId) {
        require(proposals[_proposalId].isOpen, "Proposal is not open for voting");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProposal(string calldata _description) external onlyOwner {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            description: _description,
            totalVotes: 0,
            isOpen: true
        });
    }

    function vote(uint256 _proposalId, uint8 _choice) external proposalExists(_proposalId) proposalOpen(_proposalId) {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.hasVoted[msg.sender], "You have already voted");

        proposal.hasVoted[msg.sender] = true;
        proposal.voteCount[_choice]++;
        proposal.totalVotes++;

        if (proposal.totalVotes >= 10) {
            proposal.isOpen = false;
        }
    }

    function getVoteCount(uint256 _proposalId, uint8 _choice) external view proposalExists(_proposalId) returns(uint256) {
        return proposals[_proposalId].voteCount[_choice];
    }

    function getProposalStatus(uint256 _proposalId) external view proposalExists(_proposalId) returns(bool) {
        return proposals[_proposalId].isOpen;
    }
}
