// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Owned {
  address public owner;
  event LogOwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  constructor() {
    owner = msg.sender;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit LogOwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}
