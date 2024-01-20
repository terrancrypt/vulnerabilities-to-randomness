// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {ChainlinkVRF} from "src/ChainlinkVRF.sol";
import {VRFCoordinatorV2Mock} from "lib/chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2Mock.sol";

contract ChainlinkVRFTest is Test {
    ChainlinkVRF chainlinkVRF;

    // Chainlink VRF V2 Mock
    uint96 baseFee = 0.25 ether;
    uint96 gasPriceLink = 1e9;
    VRFCoordinatorV2Mock vrfCoordinator;

    function setUp() external {
        vrfCoordinator = new VRFCoordinatorV2Mock(baseFee, gasPriceLink);
        uint64 vrfSubId = vrfCoordinator.createSubscription();
        uint96 fundAmount = 3 ether;
        vrfCoordinator.fundSubscription(vrfSubId, fundAmount);

        chainlinkVRF = new ChainlinkVRF(vrfSubId, address(vrfCoordinator));

        vrfCoordinator.addConsumer(vrfSubId, address(chainlinkVRF));
    }

    function test_can_getRandomWords() public {
        uint256 requestId = chainlinkVRF.requestRandomWords();

        vrfCoordinator.fulfillRandomWords(requestId, address(chainlinkVRF));

        uint256 randomWord = chainlinkVRF.s_randomWord();

        console.log("Random Word After All Process: ", randomWord);
    }
}
