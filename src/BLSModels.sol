// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IBLS {
    function reportAddress(
        address[] memory addr,
        string calldata uriReport
    ) external;
    function isReported(address addr) external view returns (bool);
    function getReport(
        address addr
    ) external view returns (ReportModel.Record[] memory);
}

abstract contract ReportModel {
    event ScamReported(address indexed addr, string uriReport);
    error CannotReportYourself();
    error AlreadyReported(); //?
    error InvalidInput();

    struct Record {
        string uriReport;
        uint256 timestamp;
    }

    struct Report {
        address reporter;
        address reported;
        Record[] record;
    }
}
