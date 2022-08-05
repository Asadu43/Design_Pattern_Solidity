// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ownership_pattern.sol";



/**

Problem Contract participants must be referred to the latest contract
version.
Solution Let contract participants pro-actively query the latest contract
address through a register contract that returns the address of the most
recent version.


 */

contract Register is Owned {
  address backendContract;
  address[] previousBackends;

  constructor()  {
    owner = msg.sender;
  }

  function changeBackend(address newBackend) public onlyOwner returns (bool) {
    if (newBackend != backendContract) {
      previousBackends.push(backendContract);
      backendContract = newBackend;
      return true;
    }
    return false;
  }
}
