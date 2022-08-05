// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Problem: When a contract sends funds to another party, the send operation can fail.

/**
contract Auction {
    address public highestBidder;
    uint256 highestBid;

    function bid() public payable {
        require(msg.value >= highestBid);
        if (highestBidder != 0) {
            // if call fails causing a rollback,
            // no one else can bid
            highestBidder.transfer(highestBid);
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
    }
}

 */

// Solution: Let the receiver of a payment withdraw the funds.

contract Auction {
  address public highestBidder;
  uint256 highestBid;
  mapping(address => uint256) refunds;

  function bid() public payable {
    require(msg.value > highestBid, "More Ether Require");
    if (highestBidder != address(0)) {
      refunds[highestBidder] += highestBid;
    }
    highestBidder = msg.sender;
    highestBid = msg.value;
  }

  function withdrawRefund() public payable {
    uint256 refund = refunds[msg.sender];
    require(refund > 0, "Don't Have Ether");
    refunds[msg.sender] = 0;
    payable(msg.sender).transfer(refund);
  }
}
