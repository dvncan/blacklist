// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "lib/forge-std/src/Script.sol";

import {BLS} from "../src/BLS.sol";

contract DeployBLS is Script {
    function run() external {
        vm.startBroadcast();

        BLS bls = new BLS();

        address[] memory addresses = new address[](3);
        addresses[0] = 0x58172e0b0fFB243D6F691d5b30152b6032f12a06;
        addresses[1] = 0x7DBB4bdCfE614398D1a68ecc219F15280d0959E0;
        addresses[2] = 0x444ab79616b4a790dC7Ffa9cEb8Dc82Cbc47cCDD;

        string[] memory stin = new string[](3);
        stin[
            0
        ] = "https://finnigantechnology.notion.site/Scammer-Report-8b2b4929e6374806b91f1f5442d6105b";
        stin[
            1
        ] = "https://finnigantechnology.notion.site/Scammer-Report-8b2b4929e6374806b91f1f5442d6105b";
        stin[
            2
        ] = "https://finnigantechnology.notion.site/Scammer-Report-8b2b4929e6374806b91f1f5442d6105b";

        bytes32[] memory byt = new bytes32[](3);
        byt[
            0
        ] = 0xcbe633433eee6c07bd6f5a0d54541c81f6e5281c2bdf60001c4e12d8051dafeb;
        byt[
            1
        ] = 0x50ec052a3705c1d1a4639485ca814596ffa89a41ae4df3edf7bfde20e8577a9c;
        byt[
            2
        ] = 0x15a9ccd3fbc2dc1a07fa2b6f44bfa189619a672970650ebebc52665fe24c4e5e;

        address[] memory cur = new address[](3);
        cur[0] = address(0);
        cur[1] = address(1);
        cur[2] = address(2);

        uint256[] memory guy = new uint256[](3);
        guy[0] = 500000000000000000;
        guy[1] = 500000000000000000;
        guy[2] = 500000000000000000;

        bls.reportAddresses(addresses, stin, byt, cur, guy);

        vm.stopBroadcast();
        // console.log("BLS deployed at", address(bls));
    }
}

// 4b55fe53d5a47599fcd1335de6569ad7ed8845ba18616dbc3c705a8ed3e75781
