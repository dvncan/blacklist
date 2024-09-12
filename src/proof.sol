// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

abstract contract Proof {
    enum Status {
        Pending,
        Active,
        Inactive
    }

    function recordProof(
        Proof.BannedRecord calldata evidence,
        address user
    ) public virtual;

    struct BannedRecord {
        address bannedAddress;
        Status status;
        uint256 effectiveTimestamp;
        bytes32 proofAsByes;
    }
}
