// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

abstract contract ReportModel {
    event ScamTransactionReported(
        address indexed _scammerAddress,
        bytes32 _transactionHash
    );

    event ScamReported(address indexed _addr, bytes32 _transactionHash);
    event Success(bool);

    error AddressNotFound(address _addr);
    error CannotReportYourself();
    error AlreadyReported(); //?
    error InvalidInput(string message);
    struct Record {
        address scammer;
        bytes32 transactionHash;
        uint256 timestamp;
    }

    struct Report {
        mapping(address => uint256) victimMap;
        Record[] records;
    }
}

interface IBLS {
    function reportAddresses(
        address[] calldata _addr,
        bytes32[] calldata _transactionHash
    ) external;
    function isReported(address addr) external view returns (bool);
    function getReport(
        address addr
    ) external view returns (ReportModel.Record[] memory records);
}

contract BLS is IBLS, Ownable, ReportModel {
    // badguy -> report count
    mapping(address => uint8) public reportCount;
    // badguy -> reports
    mapping(address => ReportModel.Report) public reports;
    // goodguy's report number for reports map
    mapping(address => uint256) public reportIndex;
    constructor() Ownable(msg.sender) {}

    function reportAddresses(
        address[] calldata _addr,
        bytes32[] calldata _transactionHash
    ) external {
        if (_addr.length <= 0) revert InvalidInput();

        for (uint256 i = 0; i < _addr.length; i++) {
            if (_addr[i] == msg.sender) revert CannotReportYourself();
            ReportModel.Report memory report = reports[_addr[i]];
            report.victimMap[msg.sender]++;
            report.records.push(
                ReportModel.Record(
                    _addr[i],
                    _transactionHash[i],
                    block.timestamp
                )
            );
            emit ScamReported(_addr[i], _transactionHash[i]);
        }
    }

    function isReported(address addr) external view returns (bool) {
        return reportCount[addr] > 0;
    }
    function getReport(
        address addr
    ) external view returns (Record[] memory records) {
        return (reports[addr].records);
    }
}
