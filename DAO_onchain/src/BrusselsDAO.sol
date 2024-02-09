// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BrusselsDAO {
    
    struct Proposal {
        string description;
        uint256 voteCount;
        uint256 amount;
        address steward;
    }

    struct Steward {
        bool isRegistered;
        bool hasCommitment;
        uint256[] ownedProposalIds;
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    }

   
    address public admin;
    mapping(address => Steward) public stewards;
    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyVoters() {
        require(voters[msg.sender].isRegistered, "Only registered voters can perform this action");
        _;
    }

    modifier onlyStewards() {
    require(stewards[msg.sender].isRegistered, "Only registered stewards can perform this action");
    _;
    }
    constructor() {
        admin = msg.sender;
    }

    function registerVoter(address voter) external onlyAdmin {
        require(!voters[voter].isRegistered, "Voter is already registered.");
        voters[voter] = Voter(true, false, 0);
    }

    function registerSteward(address steward) external onlyAdmin {
    require(!stewards[steward].isRegistered, "Steward is already registered.");
    stewards[steward].isRegistered = true;
    stewards[steward].hasCommitment = true; 
    }


    function createProposal(string calldata description, uint256 amount) external onlyStewards {
    proposals.push(Proposal(description, 0, amount, msg.sender));
    uint256 proposalId = proposals.length - 1;
    stewards[msg.sender].ownedProposalIds.push(proposalId);
    }

    function contributeToProposal(uint256 proposalId) external payable onlyVoters {
    require(proposalId < proposals.length, "Invalid proposal.");
    proposals[proposalId].amount += msg.value;
}

    function vote(uint proposalId) external onlyVoters {
        Voter storage sender = voters[msg.sender];
        require(!sender.hasVoted, "Already voted.");
        require(proposalId < proposals.length, "Invalid proposal.");

        sender.hasVoted = true;
        sender.votedProposalId = proposalId;
        proposals[proposalId].voteCount += 1;
    }

    function getWinningProposal() public view returns (uint winningProposalId) {
        uint winningVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
    }

    function executeProposal(uint proposalId) external onlyAdmin {
    require(proposalId == getWinningProposal(), "Can only execute the winning proposal.");
    Proposal storage proposal = proposals[proposalId];
    
    // Logic to transfer proposal.amount Ether to the appropriate address
    // For example, transferring to the steward of the proposal:
    payable(proposal.Steward).transfer(proposal.amount);

    // Reset the proposal's amount if necessary
    proposal.amount = 0;
}

}
