pragma solidity ^0.8.0;



/**


Problem: Re-entrancy attacks can manipulate the state of a contract and
hijack the control flow.


Solution: Utilize a mutex to hinder an external call from re-entering its
caller function again.


The application of a mutex pattern to avoid re-entrancy.

 */

contract Mutex {
  bool locked;
  modifier noReentrancy() {
    require(!locked);
    locked = true;
    _;
    locked = false;
  }

  // f is protected by a mutex, thus reentrant calls
  // from within msg.sender.call cannot call f again
  function f() public noReentrancy returns (uint256) {

  }
}
