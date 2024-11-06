// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SCAMMER is ERC721, Ownable {
    uint256 private _nextTokenId;
    uint256 public ethAmount;
    address payable private o;

    event ngmi();

    constructor(
        address initialOwner
    ) ERC721("SCAMMER", "BICH") Ownable(initialOwner) {
        o = payable(initialOwner);
        ethAmount = 11.2 ether;
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://arweave.net/drPyQNNAXnu3iXsurAe2UQ-FQvO9vmo2ATQYj9tlnug";
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function payback(uint256 tokenId) public payable {
        require(msg.value > ethAmount);
        o.transfer(msg.value);
        _transfer(msg.sender, address(0), tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        tokenId = _nextTokenId++;
        _safeMint(from, tokenId);
        emit ngmi();
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        tokenId = _nextTokenId++;
        _safeMint(from, tokenId);
        emit ngmi();
    }
}
