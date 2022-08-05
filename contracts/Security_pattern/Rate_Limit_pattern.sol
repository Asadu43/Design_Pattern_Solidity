// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/**

Problem: A request rush on a certain task is not desired and can hinder
the correct operational performance of a contract.

Solution: Regulate how often a task can be executed within a period of
time.



An example of a rate limit that avoids excessively repetitive function
execution.

 */

contract RateLimit {
  uint256 enabledAt = block.timestamp;
  modifier enabledEvery(uint256 t) {
    if (block.timestamp >= enabledAt) {
      enabledAt = block.timestamp + t;
      _;
    }
  }

  function f() public enabledEvery(1 minutes) {
    // some code
  }
}
