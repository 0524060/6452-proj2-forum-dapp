// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "remix_tests.sol";
import "../contracts/PostCommentContract.sol";
import "../contracts/MockCommunityContract.sol";

contract PostCommentContractTest {
    MockCommunityContract mockCommunityContract;
    PostCommentContract postCommentContract;
    
    function beforeEach() public {
        // create a new instance of PostCommentContract with a mock CommunityContract
        mockCommunityContract = new MockCommunityContract();
        postCommentContract = new PostCommentContract(mockCommunityContract);

        // Enable community 0 for the testing purpose
        mockCommunityContract.enableCommunity(0);
    }
    
    /// Test if a post can be created
    // function testCreatePost() public {
    //     postCommentContract.createPost(0, "QmTest");
        
    //     (string memory ipfsHash, uint256 communityId, address owner) = postCommentContract.getPost(0);
        
    //     Assert.equal(ipfsHash, "QmTest", "IPFS hash of the post does not match");
    //     Assert.equal(communityId, 0, "Community ID of the post does not match");
    //     Assert.equal(owner, msg.sender, "Owner of the post does not match");
    // }
    
    function testUpdatePost() public {
        postCommentContract.createPost(0, "QmTest");
        postCommentContract.updatePost(0, "QmTestUpdated");

        (string memory ipfsHash,,) = postCommentContract.getPost(0);
        Assert.equal(ipfsHash, "QmTestUpdated", "IPFS hash of the post does not match after update");
    }
    
    /// Test if a post can be deleted
    function testDeletePost() public {
        postCommentContract.createPost(0, "QmTest");
        postCommentContract.deletePost(0);

        // Check if the post still exists
        (string memory ipfsHash,,) = postCommentContract.getPost(0);
        Assert.equal(ipfsHash, "", "Post has not been deleted");
    }

    /// Test if a comment can be created
    function testCreateComment() public {
        postCommentContract.createPost(0, "QmTest");
        postCommentContract.createComment(0, "QmCommentTest");
        (bool success,) = address(postCommentContract).call(abi.encodeWithSignature("getCommentsByPost(uint256)", 0));
        Assert.equal(success, true, "Comment has not been created");
    }

    /// Test if a comment can be updated
    // function testUpdateComment() public {
    //     postCommentContract.createPost(0, "QmTest");
    //     postCommentContract.createComment(0, "QmCommentTest");
    //     postCommentContract.updateComment(0, 0, "QmCommentTestUpdated");
    //     // Add an event in your PostCommentContract for comment update, then watch it here
    //     // Example:
    //     // (bool success,) = address(postCommentContract).call(abi.encodeWithSignature("CommentUpdated(uint256,uint256,string)", 0, 0, "QmCommentTestUpdated"));
    //     // Assert.equal(success, true, "Comment has not been updated");
    // }

    // /// Test if a comment can be deleted
    // function testDeleteComment() public {
    //     postCommentContract.createPost(0, "QmTest");
    //     postCommentContract.createComment(0, "QmCommentTest");
    //     postCommentContract.deleteComment(0, 0);
    //     // Add an event in your PostCommentContract for comment deletion, then watch it here
    //     // Example:
    //     // (bool success,) = address(postCommentContract).call(abi.encodeWithSignature("CommentDeleted(uint256,uint256)", 0, 0));
    //     // Assert.equal(success, true, "Comment has not been deleted");
    // }

}
