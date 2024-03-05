// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//import ERC721 from OpenZepellin

interface ITokenContract {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

interface INFTContract {
    function mint(address recipient, string calldata tokenURI) external returns (uint256);
}

contract RewardDistributor {
    ITokenContract public rewardToken;
    INFTContract public contributionNFT;

    constructor(address _rewardTokenAddress, address _contributionNFTAddress) {
        rewardToken = ITokenContract(_rewardTokenAddress);
        contributionNFT = INFTContract(_contributionNFTAddress);
    }

    function distributeTokenReward(address recipient, uint256 amount) external {
        require(rewardToken.transfer(recipient, amount), "Token transfer failed");
    }

    function distributeNFTReward(address recipient, string calldata tokenURI) external {
        contributionNFT.mint(recipient, tokenURI);
    }

   
}

