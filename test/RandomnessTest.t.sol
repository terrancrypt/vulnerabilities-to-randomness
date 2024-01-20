// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Randomness, AttackRandomness} from "src/Randomness.sol";
import {DeployRandomness} from "script/DeployRandomness.s.sol";

contract RandomnessTest is Test {
    uint256 sepoliaFork;
    string SEPOLIA_RPC_URL = "https://rpc.sepolia.org";

    Randomness randomness;
    DeployRandomness deployer;
    AttackRandomness attackRandomness;

    address owner;
    uint256 ownerPK;
    address attacker;

    function setUp() external {
        sepoliaFork = vm.createFork(SEPOLIA_RPC_URL);
        vm.selectFork(sepoliaFork);

        (owner, ownerPK) = makeAddrAndKey("owner");
        deployer = new DeployRandomness();
        randomness = deployer.run(ownerPK);
    }

    function test_can_encode() public view {
        bytes memory encode = randomness.encode("Example Text");
        console.logBytes(encode);
    }

    function test_can_encodePacked() public view {
        bytes memory encodePacked = randomness.encodePacked("Example Text");
        console.logBytes(encodePacked);
    }

    function test_can_hashData() public view {
        bytes32 hashData = randomness.hashData("Example Text");
        console.logBytes32(hashData);
    }

    function test_can_getBlockhash() public view {
        uint blockNumber = randomness.getBlockNumber();
        console.logUint(blockNumber);

        bytes32 blockhashResult = randomness.getBlockhash();
        console.logBytes32(blockhashResult);
    }

    function test_can_getRandom() public view {
        uint256 blockValue = randomness.getBlockValue();
        console.logUint(blockValue);

        uint8 randomNumber = randomness.getRandom();
        console.logUint(randomNumber);
    }

    function test_can_getBlockValue() public view {
        uint256 blockValue = randomness.getBlockValue();
        console.logUint(blockValue);
    }

    function test_can_attackGuessDice() public {
        // Chuyển cho contract randomness số dư để chi trả ether
        deal(address(randomness), 10 ether);

        // Kiểm tra số dư của contract Randomness trước khi bị tấn công
        uint balanceBeforeAttack = address(randomness).balance;
        console.log(
            "Balance of Randomness before attack: ",
            balanceBeforeAttack
        );

        // Deploy contract Attack Randomness
        attackRandomness = new AttackRandomness(address(randomness));

        // Chạy function attackGuessDice từ attack contract
        attackRandomness.attackGuessDice();

        // Kiểm tra số dư của contract Randomness sau khi bị tấn công
        uint balanceAfterAttack = address(randomness).balance;
        console.log(
            "Balance of Randomness after attacked: ",
            balanceAfterAttack
        );

        assertEq(balanceBeforeAttack - 1 ether, balanceAfterAttack);
    }
}
