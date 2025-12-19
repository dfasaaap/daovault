// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";
import {euint32} from "@fhevm/solidity/lib/FHE.sol";

// DAO with encrypted proposals
contract DAOCore is ZamaEthereumConfig {
    struct Proposal {
        address proposer;
        euint32 amount;       // encrypted proposal amount
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 endTime;
        bool executed;
    }
    
    mapping(address => bool) public members;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public proposalCounter;
    
    event ProposalCreated(uint256 indexed proposalId, address proposer);
    event VoteCast(uint256 indexed proposalId, address voter, bool support);
    event ProposalExecuted(uint256 indexed proposalId);
    
    function addMember(address member) external {
        members[member] = true;
    }
    
    function createProposal(
        euint32 encryptedAmount,
        string memory description,
        uint256 votingPeriod
    ) external returns (uint256 proposalId) {
        require(members[msg.sender], "Not a member");
        
        proposalId = proposalCounter++;
        proposals[proposalId] = Proposal({
            proposer: msg.sender,
            amount: encryptedAmount,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            endTime: block.timestamp + votingPeriod,
            executed: false
        });
        
        emit ProposalCreated(proposalId, msg.sender);
    }
    
    function vote(uint256 proposalId, bool support) external {
        require(members[msg.sender], "Not a member");
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Already executed");
        require(block.timestamp < proposal.endTime, "Voting ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted");
        
        hasVoted[proposalId][msg.sender] = true;
        
        if (support) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }
        
        emit VoteCast(proposalId, msg.sender, support);
    }
    
    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Already executed");
        require(block.timestamp >= proposal.endTime, "Voting still active");
        require(proposal.votesFor > proposal.votesAgainst, "Not passed");
        
        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }
}

