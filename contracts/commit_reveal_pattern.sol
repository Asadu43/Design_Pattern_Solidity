// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/**

A characteristic of blockchains is, that it is not possible
to restrict anyone from reading contents of a transaction
or transaction’s state. This transparency leads to problems,
especially when contract participants compete with each other.

    ********** Problem **********
All data and every transaction is publicly visible on the
blockchain, but an application scenario requires that contract interactions,
speciﬁcally submitted parameter values, are treated conﬁdentially.

    ********** Solution **********
Apply a commitment scheme to ensure that a value submission
is binding and concealed until a consolidation phase runs out, after which
the value is revealed, and it is publicly veriﬁable that the value remained
unchanged.
 */

contract CommitReveal {
  struct Commit {
    string choice;
    string secret;
    string status;
  }
  mapping(address => mapping(bytes32 => Commit)) public userCommits;
  event LogCommit(bytes32, address);
  event LogReveal(bytes32, address, string, string);

  function createBytes(string memory _choice, string memory _secret) public pure returns (bytes32) {
    return keccak256(abi.encodePacked(_choice, _secret));
  }

  function commit(bytes32 _commit) public returns (bool success) {
    Commit memory userCommit = userCommits[msg.sender][_commit];
    if (bytes(userCommit.status).length != 0) {
      return false; // commit has been used before
    }
    userCommit.status = "c"; // comitted
    emit LogCommit(_commit, msg.sender);
    return true;
  }

  function reveal(
    string memory _choice,
    string memory _secret,
    bytes32 _commit
  ) public returns (bool success) {
    Commit memory userCommit = userCommits[msg.sender][_commit];
    bytes memory bytesStatus = bytes(userCommit.status);
    if (bytesStatus.length == 0) {
      return false; // choice not committed before
    } else if (bytesStatus[0] == "r") {
      return false; // choice already revealed
    }
    if (_commit != keccak256(abi.encodePacked(_choice, _secret))) {
      return false; // hash does not match commit
    }
    userCommit.choice = _choice;
    userCommit.secret = _secret;
    userCommit.status = "r"; // revealed
    emit LogReveal(_commit, msg.sender, _choice, _secret);
    return true;
  }

  function traceCommit(address _address, bytes32 _commit)
    public
    view
    returns (
      string memory choice,
      string memory secret,
      string memory status
    )
  {
    Commit memory userCommit = userCommits[_address][_commit];
    require(bytes(userCommit.status)[0] == "r");
    return (userCommit.choice, userCommit.secret, userCommit.status);
  }
}
