// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Randomness} from "src/Randomness.sol";

contract DeployRandomness is Script {
    Randomness randomness;

    function run(uint256 privateKey) external returns (Randomness) {
        vm.startBroadcast(privateKey);
        randomness = new Randomness();
        vm.stopBroadcast();
        return randomness;
    }
}
