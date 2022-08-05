// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ownership_pattern.sol";



/**

Problem: Contracts are immutable. Changing contract functionality requires the deployment of a new contract.


Solution: Outsource functional units that are likely to change into separate
so-called satellite contracts and use a reference to these contracts in order
to utilize needed functionality.


The satellite pattern allows to modify and replace contract
functionality. This is achieved through the creation of separate
satellite contracts that encapsulate certain contract functionality. The addresses of these satellite contracts are stored in a
base contract. This contract can then can call out to the satellite
contracts when it needs to reference certain functionalities, by
using the stored address pointers. If this pattern is properly
implemented, modifying functionality is as simple as creating
new satellite contracts and changing the corresponding satellite
addresses.

 */

contract Satellite {
  function calculateVariable() public pure returns (uint256) {
    // calculate var
    return 2 * 3;
  }
}

contract Base is Owned {
  uint256 public variable;
  address satelliteAddress;

  function setVariable() public onlyOwner {
    Satellite s = Satellite(satelliteAddress);
    variable = s.calculateVariable();
  }

  function updateSatelliteAddress(address _address) public onlyOwner {
    satelliteAddress = _address;
  }
}
