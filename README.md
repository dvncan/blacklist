## Blacklist 

Blacklist was created for the public to report scams or malicious addresses. Each report is a set of addresses and transactions which demonstrate funds leaving your your wallet.

`publicReports` is a map of address => `ScammerAddressRecord[]` 

A report should be the series of transactions & addresses demonstraighting the route of funds from your wallet[A] to another wallet[D]; via wallet[B], [C], & [D].

To recover addresses you have reported, use getAllMyReports(); there is a gas limit on this function of the length has to be within uint8.

To check if an Address is Reported you can use isAddressReported(address addr) which will returns(bool).

getAllAddressTransactions(addr) returns TransactionDetails[] 

TransactionDetails{
    bytes32 transactionHash;
    uint256 chainId;
}

### How to report

```solidity
reportAddress(
    UserReport(address[] memory addressList, bytes32[] memory transactionList)
);

```solidity
struct UserReport {
        address[] scammers; // msg.sender -> 1 -> 2 -> 3 -> 4
        bytes32[] transactions; // 1 -> 2 -> 3
}
```

### Other Data Types:
```solidity
    /// @notice TransactionDetails is a struct that contains the transaction hash and chain id of a transaction.
    /// @dev transactionHash is the hash of the transaction.
    /// @dev chainId is the chain id of the transaction.
    struct TransactionDetails {
        bytes32 transactionHash;
        uint256 chainId;
    }

    /// @notice ScammerReported is a struct that contains the reported status, scammer address, and transaction details of a scammer.
    /// @dev reported is the reported status of the scammer.
    /// @dev scammerAddress is the address of the scammer.
    /// @dev transaction is the list of transaction details of the scammer.
    struct ScammerReported {
        bool reported;
        address scammerAddress;
        TransactionDetails[] transaction;
    }

    /// @notice ScammerAddressRecord is a struct that contains the stage, address, transaction hash, and timestamp of a scammer.
    /// @dev stage is the stage of the scammer.
    /// @dev to is the address of the scammer.
    /// @dev txIn is the transaction hash of the scammer.
    /// @dev timestamp is the timestamp of the transaction.
    struct ScammerAddressRecord {
        uint8 stage;
        address to;
        bytes32 txIn;
        uint256 timestamp;
    }

    /// @notice Set is a struct that contains the index and address of a scammer.
    /// @dev index is the index of the scammer.
    /// @dev addr is the address of the scammer.
    struct Set {
        uint256 index;
        address addr;
    }
```

### Public Mappings
- mappings are for mapping scammer address's to the fraudulent transaction hash.
- when a scammer is laundering money they will use new addresses to create links in the chain
- report the entire chain as two lists reportAddress([address1, address2, address3, ..., addressN], [transaction1, transaction2, transaction3, ..., transactionN]), this will add all addresses and transactions to the mappings
```solidity
    mapping(address => ScammerReported) public scammerMap;
    mapping(address => ScammerAddressRecord[]) public publicReports;
    mapping(address => Set[]) private userReportSet;
```

### Getters
- provide easy access to querying data
- for example querying an address for scammer use `isAddressReported()`
```solidity
    function getAllAddressTransactions(address addr) external view returns (TransactionDetails[] memory) {
        TransactionDetails[] memory returnTransactions = scammerMap[addr].transaction;
        return returnTransactions;
    }

    function isAddressReported(address addr) external view returns (bool) {
        return scammerMap[addr].reported;
    }

    function getAllAddressReports(address addr) external view override returns (ScammerAddressRecord[] memory) {
        return publicReports[addr];
    }
```

## Use-Cases
Interface can be used within smart contracts to reject users addresses that have been involved in a scam. 

### How to use

Anyone can use the abi to read isAddressReported() for any address you are curious about.
Importing the Interface IESR will give any contract a lightweight way to query if an address has been involved in a scam & the transaction details. 

### TypeScript WebApp

add the abi to your project and you can use ethers or wagmi to read the desired value from the Scammer Registry.


### Roadmap

API - QueryAddress(userAddress) => returns true | false 
SDK - Could be included in webapp to improve the overall user safety
