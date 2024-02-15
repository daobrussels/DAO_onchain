// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BrusselsDAO {
    struct Proposal {
        string description;
        uint256 voteCount;
        uint256 amount;
        address steward;
        uint256 uniqueContributors;
        mapping(address => bool) contributors;
    }

    struct Steward {
        bool isRegistered;
        bool hasCommitment;
        uint256[] ownedProposalIds;
    }

    //TODO: Create token that represent proof of commitment IRL
    // hasCommitment = ToBeStewardWallet that have the NFT/Token
    // Smart Contract manage the token, the last toBeSteward send the token to the Smart Contract and the CurrentSteward verify the state of the box IRL
    // and aprove the sent of the token to the next tobeSteward and make the actual tobesteward in a steward"

    struct Member {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId; // Written like this in the code we should get the last voted proposalId. 
    }

    event FundsUnlocked(uint256 proposalId, address steward, uint256 amount);

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
    // 10 stewards, 3 approvers ---> 15 stewards 7 approvers and so on

    function isMemberRegistered(address _member) public view returns (bool) {
        return members[_member].isRegistered;
    }

    function getProposalAmount(uint256 proposalId) public view returns (uint256) {
        require(proposalId < proposals.length, "Invalid proposal.");
        return proposals[proposalId].amount;
    }

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

    function createProposal(string calldata description, uint256 amount, address stewardAddress) external onlyStewards {
        Proposal storage newProposal = proposals.push();
        newProposal.description = description;
        newProposal.voteCount = 0;
        newProposal.amount = amount;
        newProposal.steward = stewardAddress;
        newProposal.uniqueContributors = 0;
    }

    //TODO:The DAO send 100 euros and 100 tokens to start the proposal if there is no members interested you
    //don't have permision to withdraw token and don't start the proposal

    function contributeToProposal(uint256 proposalId) external payable onlyMembers {
        require(proposalId < proposals.length, "Invalid proposal.");
        Proposal storage proposal = proposals[proposalId];
        if (!proposal.contributors[msg.sender]) {
            proposal.uniqueContributors += 1;
            proposal.contributors[msg.sender] = true;
        }
        proposal.amount += msg.value;
    }

    function vote(uint256 proposalId) external onlyMembers {
        Member storage sender = members[msg.sender];
        require(!sender.hasVoted, "Already voted.");
        require(proposalId < proposals.length, "Invalid proposal.");

        sender.hasVoted = true;
        sender.votedProposalId = proposalId;
        proposals[proposalId].voteCount += 1;
    }

    function canUnlockFunds(uint256 proposalId) public view returns (bool) {
        require(proposalId < proposals.length, "Invalid proposal.");
        Proposal storage proposal = proposals[proposalId];
        return proposal.amount >= 1 ether && proposal.uniqueContributors >= 10 && proposal.voteCount >= 30;
    }

    function unlockFunds(uint256 proposalId) external onlyStewards {
        // Use canUnlockFunds to check if the conditions for unlocking funds are met.
        require(canUnlockFunds(proposalId), "Conditions to unlock funds not met.");
        Proposal storage proposal = proposals[proposalId];

        // Ensure the caller is the steward of the proposal.
        require(msg.sender == proposal.steward, "Only the steward of this proposal can unlock funds.");

        // Proceed with unlocking the funds.
        (bool sent,) = payable(proposal.steward).call{value: proposal.amount}("");
        require(sent, "Failed to send Ether");

        // Reset the proposal's amount to indicate that the funds have been disbursed.
        proposal.amount = 0;

        // Emit an event after the funds have been successfully transferred.
        emit FundsUnlocked(proposalId, proposal.steward, proposal.amount);
    }

    receive() external payable {}
}
