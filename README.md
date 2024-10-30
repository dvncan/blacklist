## Blacklist 

Blacklist was created for the public to report scams or malicious addresses. The report will be saved alongside the user address submitted. Each report will increment the report count potentially adding more credibility to the claim. 

### How to report

reportAddress(
    list of addresses used in the scam,
    a link to the hosted report of the incident
)


Interface can be used within smart contracts to reject users addresses that have been involved in a scam


### Roadmap

API - QueryAddress(userAddress) => returns true | false 
SDK - Could be included in webapp to improve the overall user safety
