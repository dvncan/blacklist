// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {TokenType} from "./TokenTypes.sol";
abstract contract ReportModel {
    event ScamTransactionReported(
        address indexed _scammerAddress,
        bytes32 _transactionHash
    );

    event PublicReportUpdated(ReportModel.ScammerAddressRecord[] publicReports);

    event ScamReported(address indexed _addr, bytes32 _transactionHash);
    event Success(bool);
    error AddressNotFound(address _addr);
    error CannotReportYourself();
    error AlreadyReported(); //?
    error InvalidInput();
    error NoReportsFound();

    struct TransactionHash {
        bytes32 transactionHash;
        TokenType tokenType;
        address currency;
        uint256 value;
        uint256 timestamp;
    }

    struct UserReport {
        address[] scammers; // msg.sender -> 1 -> 2 -> 3 -> 4
        bytes32[] transactions; // 1 -> 2 -> 3
    }
    // add1                                         addr2                                       addr3
    // msg.sender => [0x88EC4FaDF351d034e2dCf395883d6F2f12895D70 => 0x27Ebe9e152f14b3e00185b04FEb3Db22C25279eE => 0x88EC4FaDF351d034e2dCf395883d6F2f12895D70]
    //tx1                                            tx2                                            tx3

    // msg.sender => tx1 => 0x88 => tx2 => 0x27 =>  tx3 => 0x88EC
    // struct report {
    //     address[] addresses;
    //     bytes32[] transactions;
    // }

    struct Record {
        address scammer;
        bytes32 transactionHash;
        uint256 timestamp;
    }

    struct Report {
        mapping(address => uint256) victimMap;
        Record[] records;
    }
    struct ScammerReported {
        bool reported;
        address scammerAddress;
        bytes32[] transactionHash;
        // mapping(address => uint256) reportIndex;
    }

    struct ScammerAddressRecord {
        uint8 stage;
        address to;
        bytes32 txIn;
        uint256 timestamp;
    }
    // publicReport[address].victimMap = msg.sender
    // publicReport[address].records = [record1, record2, record3]
    // record1 = {uriReport, scammer, transactionDetails}
    // scammer = {reported, scammerAddress, transactionHash}
    // transactionHash = {transactionHash, tokenType, currency, value, timestamp}
    struct Set {
        uint256 index;
        address addr;
    }
    // struct ScammerReport {
    //     // mapping(address => uint256) reportIndex;
    //     // ScammerAddressRecord[] records;
    //     mapping(address => ScammerAddressRecord) records;
    // }
    // [true, 0x123, 0xsdsds, 0xsdsdsd, 232312121]
}

interface IESR {
    // function reportAddress(address _addr, bytes32 _transactionHash) external;
    function reportAddress(ReportModel.UserReport calldata report) external;

    function isAddressReported(address addr) external view returns (bool);
    function getAllAddressReports(
        address addr
    ) external view returns (ReportModel.ScammerAddressRecord[] memory);
    function getAllAddressTransactions(
        address addr
    ) external view returns (bytes32[] calldata);
}

// update structs
abstract contract EthereumScammerRegistry is IESR, ReportModel {
    mapping(address => ScammerReported) public scammerMap;
    mapping(address => ScammerAddressRecord[]) public publicReports;
    mapping(address => uint256[]) private userReportIndex;

    function _addScammerReport(
        bool _reported,
        address _scammerAddress,
        bytes32 _transactionHash
    ) internal {
        if (_scammerAddress == address(0) || _scammerAddress == msg.sender)
            revert InvalidInput();
        if (_transactionHash == bytes32(0)) revert InvalidInput();
        ScammerReported storage scammer = scammerMap[_scammerAddress];
        if (!scammer.reported) {
            scammer.reported = _reported;
            scammer.scammerAddress = _scammerAddress;
            // scammer.reportIndex[msg.sender] = 0;
            scammer.transactionHash = new bytes32[](1);
            // } else {
            // scammer.reportIndex[msg.sender] = scammer.transactionHash.length;
        }
        scammer.transactionHash.push(_transactionHash);
        emit ScamTransactionReported(_scammerAddress, _transactionHash);
    }

    function _newScammerAddressRecord(
        uint8 _stage,
        address _to,
        bytes32 _txId,
        uint256 _timestamp
    ) internal returns (ScammerAddressRecord memory) {
        return ScammerAddressRecord(_stage, _to, _txId, _timestamp);
    }
    function _addScammerAddressRecord(
        uint8 _stage,
        address _to,
        bytes32 _txId,
        uint256 _timestamp
    ) internal {
        if (_to == address(0)) revert InvalidInput();
        if (_txId == bytes32(0)) revert InvalidInput();
        if (_timestamp > block.timestamp) revert InvalidInput();
        ScammerAddressRecord memory scammer = NewScammerAddressRecord(
            _stage,
            _to,
            _txId,
            _timestamp
        );
        userReportIndex[msg.sender].push(publicReports[_to].length);
        publicReports[_to].push(scammer);
        emit PublicReportUpdated(publicReports[_to]);
    }

    function getAllMyReports(
        address addr
    ) external view returns (ScammerAddressRecord[] memory) {
        if (addr == address(0)) revert InvalidInput();
        if (userReportIndex[addr].length <= 0) revert NoReportsFound();
        ScammerAddressRecord[] memory reports = new ScammerAddressRecord[](
            userReportIndex[msg.sender].length
        );
        for (uint256 i = 0; i < userReportIndex[msg.sender].length; i++) {
            reports[i] = publicReports[addr][userReportIndex[msg.sender][i]];
        }
        return reports;
    }

    function getAllAddressTransactions(
        address addr
    ) external view returns (bytes32[] memory) {
        return scammerMap[addr].transactionHash;
    }

    function isAddressReported(address addr) external view returns (bool) {
        return scammerMap[addr].reported;
    }

    function getAllAddressReports(
        address addr
    ) external view override returns (ScammerAddressRecord[] memory) {
        return publicReports[addr];
    }
}
