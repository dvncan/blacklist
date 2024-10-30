// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReportModel, IBLS} from "./BLSModels.sol";

contract BLS is IBLS, Ownable, ReportModel {
    mapping(address => uint8) public reportCount;
    mapping(address => Report[]) public reports;

    constructor() Ownable(msg.sender) {}

    function reportAddress(
        address[] memory _addr,
        string calldata _uriReport
    ) external {
        if (_addr.length <= 0) revert InvalidInput();
        if (bytes(_uriReport).length <= 0) revert InvalidInput();

        for (uint256 i = 0; i < _addr.length; i++) {
            if (_addr[i] == msg.sender) revert CannotReportYourself();
            _reportAddress(_addr[i], _uriReport);
        }
    }

    function reportAddress(
        address addr,
        string calldata reportReason
    ) external {
        if (addr == msg.sender) revert CannotReportYourself();
        _reportAddress(addr, reportReason);
    }

    function _reportAddress(
        address addr,
        string calldata reportReason
    ) internal {
        reportCount[addr]++;
        Report memory report;
        report.reporter = msg.sender;
        report.reported = addr;
        report.record.push(Record(reportReason, block.timestamp));
        reports[addr].push(report);
        emit ScamReported(addr, reportReason);
    }

    function isReported(address addr) external view returns (bool) {
        return reportCount[addr] > 0;
    }
    function getReport(address addr) external view returns (Record[] memory) {
        return reports[addr].record;
    }
}
