//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Script} from "lib/forge-std/src/Script.sol";

struct Set {
    address contract_address;
    uint256 token_id;
}

contract SendEth is Script {
    function run() external {
        address from = 0xf3e4D421E826a03848254095455ce818Ace25AF6;
        address to = 0xB078b7db743103a17A1Bad664C8172CAC9beF4f3;

        Set[] memory assets = new Set[](4);
        // assets[0] = Set(0x97CA7FE0b0288f5EB85F386FeD876618FB9b8Ab8, 4686); //
        // assets[1] = Set(0xAdeEAF8A540b79b11fAb9ce008d1De68BD39bB94, 683); //
        // assets[2] = Set(0x0A098221bb295704AC70F60deF959828F935Ac4E, 4410);
        // assets[0] = Set(0x2A46f2fFD99e19a89476E2f62270e0a35bBf0756, 66188);
        // assets[1] = Set(
        //     0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85,
        //     31454628001679799008737945661928461194404124345981566290825646655171877507083
        // );
        // assets[0] = Set(
        //     0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85,
        //     53441800155075373382179176051030037391414137077740982316683898035324416983405
        // );
        // assets[1] = Set(
        //     0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85,
        //     85090676491754845085457365056798642251174911340225756075814576198066962321657
        // );

        // assets[0] = Set(0x5f5541C618E76ab98361cdb10C67D1dE28740cC3, 675);
        // assets[1] = Set(0x3B3ee1931Dc30C1957379FAc9aba94D1C48a5405, 32413);
        // assets[0] = Set(0xDa22422592Ee3623c8d3c40Fe0059CdEcF30CA79, 25254);
        // assets[1] = Set(0xFC0946B334B3bA133D239207a4d01Da1B75CF51B, 502);
        // assets[0] = Set(0x27b4bC90fBE56f02Ef50f2E2f79D7813Aa8941A7, 44461);
        // assets[1] = Set(0x9546eEb89Df8F010DA4953c2ef456E282B3DB25a, 7086);
        // assets[2] = Set(0x9546eEb89Df8F010DA4953c2ef456E282B3DB25a, 2817);

        // assets[0] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2651);
        // assets[1] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2472);
        // assets[0] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2454);
        // assets[1] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2426);
        // assets[0] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2420);
        // assets[1] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2121);
        // assets[2] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2446);
        assets[0] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2410);
        assets[1] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2336);
        assets[2] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2294);
        assets[3] = Set(0x9a8C5DA383f3B6a4d07Fb9fDEF3ac54044e5e6bE, 2410);

        vm.startBroadcast();

        for (uint256 y = 0; y < assets.length; y++) {
            IERC721(assets[y].contract_address).safeTransferFrom(
                address(from),
                to,
                assets[y].token_id,
                ""
            );
        }

        vm.stopBroadcast();
    }
}
