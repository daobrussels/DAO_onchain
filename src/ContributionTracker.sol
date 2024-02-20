* Key Features:
* Contribution Submission: Enable community members to submit their contributions along with necessary metadata.
* Contribution Review: Implement a system for contribution validation, which could be community-driven (e.g., voting) or managed by appointed reviewers.
* Integration with Rewards System: Connect with a separate smart contract or module for distributing rewards based on validated contributions.
*
*
* Data Structures:
* Contribution: A struct to store information about each contribution, including the contributor's address, a description (or link to the contribution), the submission date, and the review status.
* Review: A struct or mechanism to capture the review outcomes, potentially including votes, comments, or approval status.
*
*
* Functions:
* submitContribution: Allows users to submit contributions. Parameters might include the contribution type, a description or link, and any other relevant metadata.
* reviewContribution: Functions to facilitate the review process. This could include voting on contributions, submitting review comments, or marking contributions as validated.
* getContributionDetails: Returns details of a specific contribution, useful for both contributors and reviewers to track status.
* listContributions: Provides a list of contributions filtered by status, type, or contributor, aiding in transparency and accessibility.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBrusselsDAO {
    function isMemberRegistered(address _member) external view returns (bool);
}

interface IRewardDistributor {
    function distributeTokenReward(address recipient, uint256 amount) external;
    function distributeNFTReward(address recipient, string calldata tokenURI) external;
}

contract ContributionTracker {
    IBrusselsDAO public brusselsDAO;
    IRewardDistributor public rewardDistributor;

    struct Contribution {
        address contributor;
        string description;
        uint256 submissionDate;
        bool isReviewed;
        bool isValidated;
    }

    struct Vote {
        uint256 positiveVotes;
        uint256 negativeVotes;
        mapping(address => bool) hasVoted;
    }

    Contribution[] public contributions;
    mapping(uint256 => Vote) private votes;
    mapping(address => uint256[]) public contributionsByContributor;

    event ContributionSubmitted(uint256 indexed contributionId, address indexed contributor);
    event ContributionReviewed(uint256 indexed contributionId, bool isValidated);
    event Voted(uint256 indexed contributionId, bool vote, address indexed voter);

    modifier onlyRegisteredMember() {
        require(brusselsDAO.isMemberRegistered(msg.sender), "Not a registered member");
        _;
    }

    constructor(address _brusselsDAOAddress, address _rewardDistributorAddress) {
        brusselsDAO = IBrusselsDAO(_brusselsDAOAddress);
        rewardDistributor = IRewardDistributor(_rewardDistributorAddress);
    }

    function submitContribution(string calldata description) external onlyRegisteredMember {
        uint256 contributionId = contributions.length;
        contributions.push(Contribution({
            contributor: msg.sender,
            description: description,
            submissionDate: block.timestamp,
            isReviewed: false,
            isValidated: false
        }));
        contributionsByContributor[msg.sender].push(contributionId);
        emit ContributionSubmitted(contributionId, msg.sender);
    }

    function voteOnContribution(uint256 contributionId, bool approve) external onlyRegisteredMember {
        require(contributionId < contributions.length, "Contribution does not exist.");
        require(!votes[contributionId].hasVoted[msg.sender], "Already voted on this contribution.");

        votes[contributionId].hasVoted[msg.sender] = true;
        if (approve) {
            votes[contributionId].positiveVotes += 1;
        } else {
            votes[contributionId].negativeVotes += 1;
        }

        emit Voted(contributionId, approve, msg.sender);
    }

    function reviewContribution(uint256 contributionId) external onlyRegisteredMember {
        require(contributionId < contributions.length, "Contribution does not exist.");
        Contribution storage contribution = contributions[contributionId];
        require(!contribution.isReviewed, "Contribution already reviewed.");

        Vote storage voteRecord = votes[contributionId];
        if (voteRecord.positiveVotes > voteRecord.negativeVotes) {
            contribution.isValidated = true;
            // Call RewardDistributor to handle rewards
            rewardDistributor.distributeTokenReward(contribution.contributor, 100); // Example token reward
            rewardDistributor.distributeNFTReward(contribution.contributor, "tokenURI_here"); // Example NFT award
        }
        contribution.isReviewed = true;

        emit ContributionReviewed(contributionId, contribution.isValidated);
    }

    function getContributionDetails(uint256 contributionId) public view returns (Contribution memory) {
        require(contributionId < contributions.length, "Invalid contribution ID.");
        return contributions[contributionId];
    }

    
}
