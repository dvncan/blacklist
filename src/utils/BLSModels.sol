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
    error InvalidInput(string message);
    error NoReportsFound(Set[] reportedAddresses);

    // struct TransactionHash {
    //     bytes32 transactionHash;
    //     TokenType tokenType;
    //     address currency;
    //     uint256 value;
    //     uint256 timestamp;
    // }

    // Is this helpful? should I add another function to add the report?
    struct PoliceReport {
        string uri;
        UserReport report;
    }

    /// @notice UserReport is a struct that contains the addresses and transactions of a scammer.
    /// @dev scammers is the list of addresses that are part of the scam.
    /// @dev transactions is the list of transactions that are part of the scam.
    struct UserReport {
        uint256 chainId;
        address[] scammers; // msg.sender -> 1 -> 2 -> 3 -> 4
        bytes32[] transactions; // 1 -> 2 -> 3
    }

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

    struct TransactionDetails {
        bytes32 transactionHash;
        uint256 chainId;
    }

    struct ScammerReported {
        bool reported;
        address scammerAddress;
        TransactionDetails[] transaction;
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
    ) external view returns (ReportModel.TransactionDetails[] calldata);
}

// update structs
abstract contract EthereumScammerRegistry is IESR, ReportModel {
    mapping(address => ScammerReported) public scammerMap;
    mapping(address => ScammerAddressRecord[]) public publicReports;
    mapping(address => Set[]) private userReportSet;
    function _addScammerReport(
        bool _reported,
        address _scammerAddress,
        bytes32 _transactionHash,
        uint256 _chainId
    ) internal {
        if (_scammerAddress == address(0) || _scammerAddress == msg.sender)
            revert InvalidInput("address zero or self");
        if (_transactionHash == bytes32(0)) revert InvalidInput("tx zero");
        ScammerReported storage scammer = scammerMap[_scammerAddress];
        if (!scammer.reported) {
            scammer.reported = _reported;
            scammer.scammerAddress = _scammerAddress;
            scammer.transaction = new TransactionDetails[](0);
        }
        scammer.transaction.push(
            TransactionDetails(_transactionHash, _chainId)
        );
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
        if (_to == address(0)) revert InvalidInput("address zero");
        if (_txId == bytes32(0)) revert InvalidInput("tx zero");
        if (_timestamp > block.timestamp)
            revert InvalidInput("timestamp invalid");
        ScammerAddressRecord memory scammer = _newScammerAddressRecord(
            _stage,
            _to,
            _txId,
            _timestamp
        );
        userReportSet[msg.sender].push(Set(publicReports[_to].length, _to));
        publicReports[_to].push(scammer);
        emit PublicReportUpdated(publicReports[_to]);
    }

    // WIP
    function getAllMyReports()
        external
        view
        returns (ScammerAddressRecord[] memory)
    {
        if (userReportSet[msg.sender].length <= 0)
            revert NoReportsFound(userReportSet[msg.sender]);
        ScammerAddressRecord[] memory reports = new ScammerAddressRecord[](
            userReportSet[msg.sender].length
        );
        for (uint256 i = 0; i < userReportSet[msg.sender].length; i++) {
            reports[i] = publicReports[userReportSet[msg.sender][i].addr][
                userReportSet[msg.sender][i].index
            ];
        }
        return reports;
    }

    function getAllAddressTransactions(
        address addr
    ) external view returns (TransactionDetails[] memory) {
        TransactionDetails[] memory returnTransactions = scammerMap[addr]
            .transaction;
        return returnTransactions;
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
