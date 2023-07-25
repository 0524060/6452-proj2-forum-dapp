/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "remix_tests.sol";
import "../contracts/CommunityContract.sol";

contract CommunityContractTest {

    CommunityContract communityContract;

    // Run before each test to deploy the contract
    function beforeEach() public {
        communityContract = new CommunityContract();
    }

    // function checkCreateCommunity() public {
    //     communityContract.createCommunity("Test Community", "This is a test community");
    //     (string memory cName, string memory cDescription, address cOwner, bool cIsEnabled, uint256[] memory postIds) = communityContract.getCommunity(0);

    //     // These are assertions to verify the results
    //     Assert.equal(cName, "Test Community", "The community name should match the input");
    //     Assert.equal(cDescription, "This is a test community", "The community description should match the input");
    //     Assert.equal(cOwner, msg.sender, "The community owner should be the sender");
    //     Assert.equal(cIsEnabled, true, "The community should be enabled");
    // }

    function checkUpdateCommunity() public {
        communityContract.createCommunity("Test Community", "This is a test community");
        try communityContract.updateCommunity(0, "Updated Test Community", "This is an updated test community") {
            (string memory cName, string memory cDescription,,,) = communityContract.getCommunity(0);

            Assert.equal(cName, "Updated Test Community", "The community name should match the updated name");
            Assert.equal(cDescription, "This is an updated test community", "The community description should match the updated description");
        } catch Error(string memory reason) {
            Assert.ok(false, reason);
        }
    }

    // Add more test functions here
    function testEnableAndDisableCommunity() public {
        communityContract.createCommunity("Test Community", "This is a test community");
        communityContract.disableCommunity(0);

        bool isEnabledBefore = communityContract.isCommunityEnabled(0);
        Assert.equal(isEnabledBefore, false, "The community should be disabled");

        communityContract.enableCommunity(0);
        bool isEnabledAfter = communityContract.isCommunityEnabled(0);
        Assert.equal(isEnabledAfter, true, "The community should be enabled");
    }

    function testAddAndRemovePostIdToCommunity() public {
        communityContract.createCommunity("Test Community", "This is a test community");
        communityContract.addPostIdToCommunity(0, 1);
        communityContract.addPostIdToCommunity(0, 2);

        (, , , , uint256[] memory postIds) = communityContract.getCommunity(0);
        Assert.equal(postIds.length, 2, "The number of post IDs in the community should be 2");

        communityContract.removePostIdFromCommunity(0, 1);
        (, , , , uint256[] memory updatedPostIds) = communityContract.getCommunity(0);
        Assert.equal(updatedPostIds.length, 1, "The number of post IDs in the community should be 1 after removal");
        Assert.equal(updatedPostIds[0], 2, "The remaining post ID in the community should be 2 after removal");
    }

    function testPauseAndUnpause() public {
        bool isPausedBefore = communityContract.paused();
        Assert.equal(isPausedBefore, false, "The contract should not be paused before pausing");

        communityContract.pause();
        bool isPausedAfterPause = communityContract.paused();
        Assert.equal(isPausedAfterPause, true, "The contract should be paused after pausing");

        communityContract.unpause();
        bool isPausedAfterUnpause = communityContract.paused();
        Assert.equal(isPausedAfterUnpause, false, "The contract should not be paused after unpausing");
    }
}
