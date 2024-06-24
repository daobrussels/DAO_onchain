// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/BrusselsDAO.sol";

contract BrusselsDAOTest is Test {
    BrusselsDAO dao;
    address admin;
    address member;
    address steward;

    function setUp() public {
        admin = address(1);
        member = address(2);
        steward = address(3);

        vm.startPrank(admin);
        dao = new BrusselsDAO();
        vm.stopPrank();

        // Register a steward
        vm.prank(admin);
        dao.registerSteward(steward);

        // Register a member
        vm.prank(steward);
        dao.registerMember(member);
    }

    function testMemberRegistration() public {
        bool isRegistered = dao.isMemberRegistered(member);
        assertTrue(isRegistered);
    }

    function testCreateProposal() public {
        string memory description = "Test Proposal";
        uint256 amount = 1 ether;

        // Steward creates a proposal
        vm.prank(steward);
        dao.createProposal(description, amount, steward);

        // Check that a proposal was created
        (string memory retrievedDescription, ,uint256 yesVotes, uint256 noVotes, uint256 retrievedAmount, address stewardAddress, uint256 uniqueContributors) = dao.proposals(0);
        assertEq(retrievedDescription, description);
        assertEq(retrievedAmount, amount);
    }

    function testContributeToProposal() public {
        // Ensure member has enough Ether to contribute
        vm.deal(member, 1 ether);

        // Create a proposal to contribute to
        vm.startPrank(steward);
        dao.createProposal("Test Proposal", 1 ether, steward);
        vm.stopPrank();

        uint256 proposalId = 0; // Assuming it's the first proposal

        // Member contributes to the proposal
        vm.startPrank(member);
        dao.contributeToProposal{value: 0.5 ether}(proposalId);
        vm.stopPrank();

        // Add assertions to check the new state
    }

    function testFailUnlockFundsWithoutEnoughVotes() public {
        // Setup: Create a proposal and add insufficient votes.

        string memory description = "Proposal needing votes";
        uint256 amount = 1 ether;

        // Steward creates a proposal
        vm.prank(steward);
        dao.createProposal(description, amount, steward);

        // Check that a proposal was created
        (string memory retrievedDescription, ,uint256 yesVotes, uint256 noVotes, uint256 retrievedAmount, address stewardAddress, uint256 uniqueContributors) = dao.proposals(0);
        assertEq(retrievedDescription, description);
        assertEq(retrievedAmount, amount);

        // Assuming the proposal needs more votes than this to unlock funds
        vm.prank(member);
        dao.vote(0,true);

        // Expect a revert when trying to unlock funds
        vm.prank(steward);
        dao.unlockFunds(0);
        vm.expectRevert("Conditions to unlock funds not met.");
    }

    //TODO: review this test
    function testUnlockFundsSuccess() public {
        vm.deal(member, 10 ether); // Ensure the member has enough ether to contribute.
        uint256 proposalId = 0;
        // Setup: Create a proposal and add insufficient votes.

        string memory description = "Proposal with all the votes and funds";
        uint256 amount = 1 ether;

        // Steward creates a proposal
        vm.prank(steward);
        dao.createProposal(description, amount, steward);

        // Check that a proposal was created
        (string memory retrievedDescription, ,uint256 yesVotes, uint256 noVotes, uint256 retrievedAmount, address stewardAddress, uint256 uniqueContributors) = dao.proposals(proposalId);
        assertEq(retrievedDescription, description);
        assertEq(retrievedAmount, amount);
        /// Register 30 members and give them some Ether
        for (uint256 i = 0; i < 30; i++) {
            member = address(uint160(uint256(keccak256(abi.encodePacked(i)))));
            vm.deal(member, 1 ether); // Provide Ether to each member for contributions
            vm.prank(steward);
            dao.registerMember(member); // Register member

            // First 10 members contribute to the proposal
            if (i < 10) {
            vm.prank(member);
            dao.contributeToProposal{value: 0.1 ether}(proposalId); // Each contributes 0.1 ether
            }

            // All 30 members vote on the proposal
            vm.prank(member);
            dao.vote(proposalId, true);
        }

        // Preconditions should be met: enough contributions, unique contributors, and votes
        assertTrue(dao.canUnlockFunds(proposalId));

        // Attempt to unlock the funds by the steward
        vm.prank(steward);
        dao.unlockFunds(proposalId);

        // Verify the proposal's amount is reset to 0 indicating funds were disbursed
        assertEq(dao.getProposalAmount(proposalId), 0);

        // Additional checks can include verifying the steward's balance increased,
        // but this requires tracking the contract's balance or simulating the transfer.
    }
}
