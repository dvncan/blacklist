// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
// import {ReportModel} from "./src/BLSModels.sol";
import {EthereumScammerRegistry} from "./utils/BLSModels.sol";

contract Blacklist is Ownable, EthereumScammerRegistry {
    constructor() Ownable(msg.sender) {}

    function reportAddress(UserReport calldata report) external {
        if (report.scammers.length <= 0 || report.transactions.length <= 0)
            revert InvalidInput();
        if (report.scammers.length != report.transactions.length)
            revert InvalidInput();
        for (uint8 i = 0; i < report.scammers.length; i++) {
            _addScammerReport(true, report.scammers[i], report.transactions[i]);
            _addScammerAddressRecord(
                i,
                report.scammers[i],
                report.transactions[i],
                block.timestamp
            );
        }
    }
}
