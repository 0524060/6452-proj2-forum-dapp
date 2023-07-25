/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICommunityContract.sol"; // Import the interface

contract MockCommunityContract is ICommunityContract, Ownable {
    mapping(uint256 => bool) public communities;
    mapping(uint256 => uint256[]) public communityPosts;

    // Add a state variable to store the test account
    address public testAccount;

    function isCommunityEnabled(uint256 _communityId) public view override returns(bool) {
        return communities[_communityId];
    }

    function addPostIdToCommunity(uint256 _communityId, uint256 _postId) public override {
        communityPosts[_communityId].push(_postId);
    }

    function removePostIdFromCommunity(uint256 _communityId, uint256 _postId) public override {
        // you can keep this function empty for simplicity in this mock contract
    }

    // for testing purpose, we can enable or disable community
    function enableCommunity(uint256 _communityId) public onlyOwner {
        communities[_communityId] = true;
    }

    function disableCommunity(uint256 _communityId) public onlyOwner {
        communities[_communityId] = false;
    }

    // Add a function to set the test account
    function setTestAccount(address _testAccount) public {
        testAccount = _testAccount;
    }
}
