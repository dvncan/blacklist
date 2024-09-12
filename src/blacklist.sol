// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Proof} from "src/proof.sol";

contract BlackList is Proof {
    mapping(address => bool) public blackList;
    mapping(address => address) public blackListAddress;
    mapping(address => BannedRecord) public reason;

    mapping(address => bool) private moderator;
    address private owner;
    bool thi = false;
    uint256 public totalNumber;

    constructor() {
        owner = msg.sender;
        moderator[owner] = true;
        totalNumber = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "nonsense");
        _;
    }

    modifier notOnList() {
        require(!blackList[msg.sender], "User already on the list");
        _;
    }

    modifier onlyModerator() {
        require(moderator[msg.sender], "go away");
        _;
    }

    function addToList(
        BannedRecord calldata evidence,
        address user
    ) public override notOnList onlyModerator {
        blackList[user] = true;
        reason[user] = evidence;
        blackListAddress[user] = user;
        ++totalNumber;
    }

    function getProofBytes(
        string calldata message
    ) public pure returns (bytes32) {
        return (bytes32(abi.encodePacked(message)));
    }
    function returnToString(
        bytes calldata message
    ) public pure returns (string memory) {
        return (string(abi.encodePacked(message)));
    }

    function removeAMod(address mod) public onlyOwner {
        thi = false;
        require(!thi);
        moderator[mod] = false;
        thi = true;
    }

    function isBanned(address user) public view returns (bool) {
        return blackList[user];
    }

    function whyBanned(address user) public view returns (bytes32) {
        return reason[user].proofAsByes;
    }
    function whenBanned(address user) public view returns (uint256) {
        return reason[user].effectiveTimestamp;
    }

    function getStatus(address user) public view returns (Status) {
        return reason[user].status;
    }

    function addMod(address mod) public onlyOwner {
        thi = false;
        require(!thi);
        moderator[mod] = true;
        thi = false;
    }
}

// // import {CombinedEscrow} from "../src/CombinedEscrow.sol";

// // Malicious contract for testing reentrancy
// contract MaliciousContract {
//     BlackList private immutable list;
//     uint256 private constant ATTACK_COUNT = 3;
//     uint256 private attackCounter;

//     constructor(address _escrow) {
//         list = BlackList(payable(_escrow));
//     }

//     function deposit() external payable {
//         list(address(this));
//     }

//     receive() external payable {
//         if (attackCounter < ATTACK_COUNT) {
//             attackCounter++;
//             list.withdraw(payable(address(this)));
//         }
//     }
// }
// //
