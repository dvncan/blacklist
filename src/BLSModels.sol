// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

abstract contract ReportModel {
    event ScamReported(address indexed addr, string uriReport);
    error CannotReportYourself();
    error AlreadyReported(); //?
    error InvalidInput();

    struct Record {
        string uriReport;
        address reporter;
        address reported;
        bytes32 transactionHash;
        address currency;
        uint256 amount;
        uint256 timestamp;
    }

    struct Report {
        uint256 totalStolen;
        mapping(address => uint256) victimMap;
        Record[] records;
    }
}

// push to github

// update structs
