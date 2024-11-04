// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "lib/forge-std/src/Script.sol";

import {BLS} from "../src/BLS.sol";

contract DeployBLS is Script {
    function run() external {
        vm.startBroadcast();

        BLS bls = BLS(0x27Ebe9e152f14b3e00185b04FEb3Db22C25279eE);

        address[] memory addresses = new address[](1);
        addresses[0] = 0x88EC4FaDF351d034e2dCf395883d6F2f12895D70;
        // addresses[1] = 0x7DBB4bdCfE614398D1a68ecc219F15280d0959E0;
        // addresses[2] = 0x444ab79616b4a790dC7Ffa9cEb8Dc82Cbc47cCDD;

        string[] memory stin = new string[](1);
        stin[
            0
        ] = "This was a 'free mint' scam that I fell for because of Phantom's wallet UX not showing what is getting signd";
        // stin[
        // 1
        // ] = "https://finnigantechnology.notion.site/Scammer-Report-8b2b4929e6374806b91f1f5442d6105b";
        // stin[
        //     2
        // ] = "https://finnigantechnology.notion.site/Scammer-Report-8b2b4929e6374806b91f1f5442d6105b";

        bytes32[] memory byt = new bytes32[](1);
        byt[
            0
        ] = 0x9a1ffbe0d0a8eb3eb197552ced5afe913162b3e455e41dd22905b3133a50117b;
        // byt[
        //     1
        // ] = 0x50ec052a3705c1d1a4639485ca814596ffa89a41ae4df3edf7bfde20e8577a9c;
        // byt[
        //     2
        // ] = 0x15a9ccd3fbc2dc1a07fa2b6f44bfa189619a672970650ebebc52665fe24c4e5e;

        address[] memory cur = new address[](1);
        cur[0] = (0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        // cur[1] = address(1);
        // cur[2] = address(2);

        uint256[] memory guy = new uint256[](1);
        guy[0] = 20446646;
        // guy[1] = 500000000000000000;
        // guy[2] = 500000000000000000;

        bls.reportAddresses(addresses, stin, byt, cur, guy);

        vm.stopBroadcast();
        // console.log("BLS deployed at", address(bls));
    }
}

// 4b55fe53d5a47599fcd1335de6569ad7ed8845ba18616dbc3c705a8ed3e75781
