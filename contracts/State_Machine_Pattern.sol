// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";



/**

The State Machine pattern splits up the functionality of a program into a number of different “states”. At any given point in time, the program is in one and only one state, during which only state-specific functionality is possible. The program can transition between these states in a pre-defined way.


A state machine models the behaviour of a system based
on its history and current inputs. Developers use this construct to break complex problems into simple states and state
transitions. These are then used to represent and control the
execution flow of a program. State machines can also be
applied in smart contracts, exemplified in Listing 3. Many
usage scenarios require a contract to have different behavioural
stages, in which different functions can be called. When
interacting with such a contract, a function call might end the
current stage and initiate a change into a consecutive stage.


 A contract based on a state machine to represent a deposit lock,
which accepts deposits for a period of one day and releases them after seven
days.

 */

contract DepositLock {
  enum Stages {
    AcceptingDeposits,
    FreezingDeposits,
    ReleasingDeposits
  }
  Stages public stage = Stages.AcceptingDeposits;
  uint256 public creationTime = block.timestamp;
  mapping(address => uint256) balances;
  modifier atStage(Stages _stage) {
    require(stage == _stage);
    _;
  }
  modifier timedTransitions() {
    if (stage == Stages.AcceptingDeposits && block.timestamp >= creationTime + 1 days) nextStage();
    if (stage == Stages.FreezingDeposits && block.timestamp >= creationTime + 8 days) nextStage();
    _;
  }

  function nextStage() public {
    stage = Stages(uint256(stage) + 1);
  }

  function deposit() public payable timedTransitions atStage(Stages.AcceptingDeposits) {
    balances[msg.sender] += msg.value;
  }

  function withdraw() public payable timedTransitions atStage(Stages.ReleasingDeposits) {
    uint256 amount = balances[msg.sender];
    balances[msg.sender] = 0;
    console.log(amount);
    payable(msg.sender).transfer(amount);
  }
}
