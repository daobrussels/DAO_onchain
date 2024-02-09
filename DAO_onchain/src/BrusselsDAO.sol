// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BrusselsDAO {
    
    struct Proposal {
        string description;
        uint256 voteCount;
        uint256 amount;
        address steward;
        uint256 uniqueContributors;
        mapping(address =>bool) contributors;
    }

    struct Steward {
        bool isRegistered;
        bool hasCommitment;
        uint256[] ownedProposalIds;
    }

    //TODO: Create token that represent proof of commitment IRL
    //hasCommitment = ToBeStewardWallet that have the NFT/FToken
    //SC manage the token, the last toBeSteward send the token to the sc and the CurrentSteward verify the state of the box IRL
    //and aprove the sent of the token to the next tobeSteward and make the actual tobestwerd in a steward"

    struct Member {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    }

   
    address public admin;
    mapping(address => Steward) public stewards;
    mapping(address => Member) public members;
    Proposal[] public proposals;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyMembers() {
        require(members[msg.sender].isRegistered, "Only registered members can perform this action");
        _;
    }

    modifier onlyStewards() {
        require(stewards[msg.sender].isRegistered, "Only registered stewards can perform this action");
        _;
    }

    //TODO: Being and steward grant you a place in the multisig that admin this contract
    //10 stewards, 3 approvers ---> 15 stewards 7 approvers and so on

    constructor() {
        admin = msg.sender;
    }

    function registerMember(address memberAddress) external onlyStewards {
        require(!members[memberAddress].isRegistered, "Member is already registered.");
        members[memberAddress] = Member({isRegistered: true, hasVoted: false, votedProposalId: 0});
    }

    function registerSteward(address stewardAddress) external onlyAdmin {
        require(!stewards[stewardAddress].isRegistered, "Steward is already registered.");
        stewards[stewardAddress].isRegistered = true;
        stewards[stewardAddress].hasCommitment = false; // Assuming commitment needs to be proven after registration
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
    //TODO:The DAO send 100 euros and 100 tokens to start the proposal if there is no members interested you
    //don't have permision to withdraw token and don't start the proposal

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
