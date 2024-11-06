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
