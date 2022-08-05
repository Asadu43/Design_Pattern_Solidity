// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../ownership_pattern.sol";



/**

Problem: Since a deployed contract is executed autonomously on the
Ethereum network, there is no option to halt its execution in case of a
major bug or security issue.


Solution: Incorporate an emergency stop functionality into the contract that
can be triggered by an authenticated party to disable sensitive functions.



 An emergency stop allows to disable or enable specific functions
inside a contract in case of an emergency.


 */

contract EmergencyStop is Owned {
  bool public contractStopped = false;
  modifier haltInEmergency() {
    if (!contractStopped) _;
  }
  modifier enableInEmergency() {
    if (contractStopped) _;
  }

  function toggleContractStopped() public onlyOwner {
    contractStopped = !contractStopped;
  }

  function deposit() public payable haltInEmergency {
    // some code
  }

  function withdraw() public view enableInEmergency {
    // some code
  }
}
