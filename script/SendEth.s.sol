import {Script} from "lib/forge-std/src/Script.sol";

contract SendEth is Script {
    function run() external {
        vm.startBroadcast();
        address from = 0xB078b7db743103a17A1Bad664C8172CAC9beF4f3;
        address to = 0xf3e4D421E826a03848254095455ce818Ace25AF6;
        // receiver wallet
        (bool s, ) = to.call{value: 0.025 ether}("");
        require(s, "Transfer failed");
        vm.stopBroadcast();
    }
}
