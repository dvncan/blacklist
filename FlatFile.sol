// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20 ^0.8.24;

// lib/openzeppelin-contracts/contracts/utils/Context.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// src/utils/TokenTypes.sol

enum TokenType {
    NONE,
    NATIVE,
    ERC20,
    ERC721,
    ERCOTHER
}

// lib/openzeppelin-contracts/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// src/utils/BLSModels.sol

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
    function ReportAddress(ReportModel.UserReport calldata report) external;

    function IsAddressReported(address addr) external view returns (bool);
    function GetAllAddressReports(
        address addr
    ) external view returns (ReportModel.ScammerAddressRecord[] memory);
    function GetAllAddressTransactions(
        address addr
    ) external view returns (bytes32[] calldata);
}

// update structs
abstract contract EthereumScammerRegistry is IESR, ReportModel {
    mapping(address => ScammerReported) public scammerMap;
    mapping(address => ScammerAddressRecord[]) public publicReports;
    mapping(address => uint256[]) private userReportIndex;

    function AddScammerReport(
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

    function NewScammerAddressRecord(
        uint8 _stage,
        address _to,
        bytes32 _txId,
        uint256 _timestamp
    ) internal returns (ScammerAddressRecord memory) {
        return ScammerAddressRecord(_stage, _to, _txId, _timestamp);
    }
    function AddScammerAddressRecord(
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

    function GetAllMyReports(
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

    function GetAllAddressTransactions(
        address addr
    ) external view returns (bytes32[] memory) {
        return scammerMap[addr].transactionHash;
    }

    function IsAddressReported(address addr) external view returns (bool) {
        return scammerMap[addr].reported;
    }

    function GetAllAddressReports(
        address addr
    ) external view override returns (ScammerAddressRecord[] memory) {
        return publicReports[addr];
    }
}

// src/BLS_NEW.sol

// import {ReportModel} from "./src/BLSModels.sol";

contract Blacklist is Ownable, EthereumScammerRegistry {
    constructor() Ownable(msg.sender) {}

    function ReportAddress(UserReport calldata report) external {
        if (report.scammers.length <= 0 || report.transactions.length <= 0)
            revert InvalidInput();
        if (report.scammers.length != report.transactions.length)
            revert InvalidInput();
        for (uint8 i = 0; i < report.scammers.length; i++) {
            AddScammerReport(true, report.scammers[i], report.transactions[i]);
            AddScammerAddressRecord(
                i,
                report.scammers[i],
                report.transactions[i],
                block.timestamp
            );
        }
    }
}
