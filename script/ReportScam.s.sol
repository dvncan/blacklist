// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script} from "lib/forge-std/src/Script.sol";

import {Blacklist} from "../src/BLS_NEW.sol";
import {ReportModel} from "../src/utils/BLSModels.sol";
contract DeployBLS is Script {
    function run() external {
        vm.startBroadcast();

        Blacklist bls = Blacklist(0xEE5085D66FE9D6dD3A52C9197EbC526B730CaBb0);

        address[] memory addresses = new address[](1);
        addresses[0] = 0x88EC4FaDF351d034e2dCf395883d6F2f12895D70;

        bytes32[] memory byt = new bytes32[](1);
        byt[
            0
        ] = 0x9a1ffbe0d0a8eb3eb197552ced5afe913162b3e455e41dd22905b3133a50117b;

        bls.reportAddress(ReportModel.UserReport(1, addresses, byt));

        vm.stopBroadcast();
        // console.log("BLS deployed at", address(bls));
    }
}

// 4b55fe53d5a47599fcd1335de6569ad7ed8845ba18616dbc3c705a8ed3e75781
