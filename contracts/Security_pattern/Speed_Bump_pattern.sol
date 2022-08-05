
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/**


Problem: The simultaneous execution of sensitive tasks by a huge number
of parties can bring about the downfall of a contract.


Solution: Prolong the completion of sensitive tasks to take steps against
fraudulent activities


A contract that delays the withdrawal of funds deliberately.

 */

contract SpeedBump {
  struct Withdrawal {
    uint256 amount;
    uint256 requestedAt;
  }
  mapping(address => uint256) private balances;
  mapping(address => Withdrawal) private withdrawals;
  uint256 constant WAIT_PERIOD = 7 days;

  function deposit() public payable {
    if (!(withdrawals[msg.sender].amount > 0)) balances[msg.sender] += msg.value;
  }

  function requestWithdrawal() public {
    if (balances[msg.sender] > 0) {
      uint256 amountToWithdraw = balances[msg.sender];
      balances[msg.sender] = 0;
      withdrawals[msg.sender] = Withdrawal({ amount: amountToWithdraw, requestedAt: block.timestamp });
    }
  }

  function withdraw() public payable{
    if (withdrawals[msg.sender].amount > 0 && block.timestamp > withdrawals[msg.sender].requestedAt + WAIT_PERIOD) {
      uint256 amount = withdrawals[msg.sender].amount;
      withdrawals[msg.sender].amount = 0;
      payable(msg.sender).transfer(amount);
    }
  }
}
