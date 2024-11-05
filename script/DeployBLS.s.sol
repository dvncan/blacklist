// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "lib/forge-std/src/Script.sol";

import {Blacklist} from "../src/BLS_NEW.sol";
import {ReportModel} from "../src/utils/BLSModels.sol";
contract DeployBLS is Script {
    function run() external {
        vm.startBroadcast();

        Blacklist bls = new Blacklist();

        address[] memory addresses = new address[](3);
        addresses[0] = 0x58172e0b0fFB243D6F691d5b30152b6032f12a06;
        addresses[1] = 0x7DBB4bdCfE614398D1a68ecc219F15280d0959E0;
        addresses[2] = 0x444ab79616b4a790dC7Ffa9cEb8Dc82Cbc47cCDD;

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

        bls.ReportAddress(ReportModel.UserReport(addresses, byt));

        vm.stopBroadcast();
        // console.log("BLS deployed at", address(bls));
    }
}

// 4b55fe53d5a47599fcd1335de6569ad7ed8845ba18616dbc3c705a8ed3e75781
