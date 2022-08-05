// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ownership_pattern.sol";



/**

Problem : By default a contract method is executed without any preconditions being checked, but it is desired that the execution is only allowed
if certain requirements are met.


Solution: Define generally applicable modifiers that check the desired
requirements and apply these modifiers in the function definition

 */

contract AccessRestriction is Owned {
  uint256 public creationTime = block.timestamp;
  modifier onlyBefore(uint256 _time) {
    require(block.timestamp < _time);
    _;
  }
  modifier onlyAfter(uint256 _time) {
    require(block.timestamp > _time);
    _;
  }
  modifier onlyBy(address account) {
    require(msg.sender == account);
    _;
  }
  modifier condition(bool _condition) {
    require(_condition);
    _;
  }
  modifier minAmount(uint256 _amount) {
    require(msg.value >= _amount);
    _;
  }

  function f() public payable onlyAfter(creationTime + 1 minutes) onlyBy(owner) minAmount(2 ether) condition(msg.sender.balance >= 50 ether) {
    // some code
  }
}
