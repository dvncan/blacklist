// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReportModel} from "./BLSModels.sol";

interface IBLS {
    function reportAddresses(
        address[] calldata _addr,
        string[] calldata _uriReport,
        bytes32[] calldata _transactionHash,
        address[] calldata _currency,
        uint256[] calldata _amount
    ) external;
    function isReported(address addr) external view returns (bool);
    function getReport(
        address addr
    )
        external
        view
        returns (uint256 totalStolen, ReportModel.Record[] memory records);
}

contract BLS is IBLS, Ownable, ReportModel {
    // badguy -> report count
    mapping(address => uint8) public reportCount;
    // badguy -> reports
    mapping(address => Report) public reports;
    // goodguy's report number for reports map
    mapping(address => uint256) public reportIndex;
    constructor() Ownable(msg.sender) {}

    function reportAddresses(
        address[] calldata _addr,
        string[] calldata _uriReport,
        bytes32[] calldata _transactionHash,
        address[] calldata _currency,
        uint256[] calldata _amount
    ) external {
        if (_addr.length <= 0) revert InvalidInput();
        // if (bytes(_uriReport).length <= 0) revert InvalidInput();

        for (uint256 i = 0; i < _addr.length; i++) {
            if (_addr[i] == msg.sender) revert CannotReportYourself();
            _reportAddress(
                _uriReport[i],
                msg.sender,
                _addr[i],
                _transactionHash[i],
                _currency[i],
                _amount[i]
            );
        }
    }

    function _reportAddress(
        string calldata uriReport,
        address reporter,
        address reported,
        bytes32 transactionHash,
        address currency,
        uint256 amount
    ) internal {
        if (reports[reported].totalStolen == 0) {
            Record memory recos;
            recos = Record(
                uriReport,
                reporter,
                reported,
                transactionHash,
                currency,
                amount,
                block.timestamp
            );
            reports[reported].totalStolen = amount;
            reports[reported].victimMap[reporter]++;
            reports[reported].records.push(recos);
        }
        emit ScamReported(reported, uriReport);
    }

    function isReported(address addr) external view returns (bool) {
        return reportCount[addr] > 0;
    }
    function getReport(
        address addr
    ) external view returns (uint256 totalStolen, Record[] memory records) {
        return (reports[addr].totalStolen, reports[addr].records);
    }
}
