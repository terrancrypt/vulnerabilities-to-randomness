// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console} from "forge-std/Test.sol";
import {Randomness, AttackRandomness} from "src/Randomness.sol";
import {DeployRandomness} from "script/DeployRandomness.s.sol";

contract RandomnessTest is Test {
    Randomness randomness;
    DeployRandomness deployer;

    address owner;
    uint256 ownerPK;

    uint256 sepoliaFork;
    string SEPOLIA_RPC_URL = "https://rpc.sepolia.org";

    function setUp() external {
        sepoliaFork = vm.createFork(SEPOLIA_RPC_URL);
        vm.selectFork(sepoliaFork);

        (owner, ownerPK) = makeAddrAndKey("owner");

        deployer = new DeployRandomness();
        randomness = deployer.run(ownerPK);
    }

    function test_can_getBlockTimestamp() public view {
        uint blockTimestamp = randomness.getBlockTimestamp();
        console.logUint(blockTimestamp);
    }

    function test_can_getBlockNumber() public view {
        uint blockNumber = randomness.getBlockNumber();
        console.logUint(blockNumber);
    }

    function test_can_getBlockHash() public view {
        uint blockNumber = block.number - 1;
        console.log(blockNumber);

        bytes32 blockHash = randomness.getBlockHash();
        console.logBytes32(blockHash);
    }

    function test_can_encode() public view {
        bytes memory encoded = randomness.getEncode("Example Text");
        console.logBytes(encoded);
    }

    function test_can_encodePacked() public view {
        bytes memory encodePacked = randomness.getEncodePacked("Example Text");
        console.logBytes(encodePacked);
    }

    function test_can_getHashData() public view {
        bytes32 hashData = randomness.getHashData("Example Text");
        console.logBytes32(hashData);
    }

    function test_can_getRandom() public view {
        uint8 randomNumber = randomness.getRandom();
        console.logUint(randomNumber);
    }

    function test_can_attackRandomness() public {
        deal(address(randomness), 10 ether);

        uint balanceBeforeAttack = address(randomness).balance;
        console.log(
            "Balance Of Randomness Contract Before Attack",
            balanceBeforeAttack
        );

        AttackRandomness attackContract = new AttackRandomness(
            address(randomness)
        );

        attackContract.attackGuessDice();

        uint balanceAfterAttack = address(randomness).balance;
        console.log(
            "Balance Of Randomness Contract After Attacked",
            balanceAfterAttack
        );

        uint balanceAttackContract = address(attackContract).balance;
        console.log(
            "Balance Of Attack Contract After Attacked",
            balanceAttackContract
        );
    }
}
