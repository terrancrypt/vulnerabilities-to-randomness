// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {RrpRequesterV0} from "lib/airnode/packages/airnode-protocol/contracts/rrp/requesters/RrpRequesterV0.sol";

// sử dụng import dưới thay thế khi dùng Remix để test, hoặc sử dụng remappings cho Foundry
// import {RrpRequesterV0} from "@api3/airnode-protocol/contracts/rrp/requesters/RrpRequesterV0.sol";

contract API3QRNG is RrpRequesterV0 {
    uint256 public s_randomUint256;

    address public s_airnode;
    bytes32 public s_endpointIdUint256;
    bytes32 public s_endpointIdUint256Array;
    address public s_sponsorWallet;

    constructor(address _airnodeRrp) RrpRequesterV0(_airnodeRrp) {}

    event RequestedRandomUint256(bytes32 requestId);
    event ReceiveRandomUint256(bytes32 requestId, uint256 randomUint256);

    function setRequestParameters(
        address _airnode,
        bytes32 _endpointIdUint256,
        bytes32 _endpointIdUint256Array,
        address _sponsorWallet
    ) external {
        s_airnode = _airnode;
        s_endpointIdUint256 = _endpointIdUint256;
        s_endpointIdUint256Array = _endpointIdUint256Array;
        s_sponsorWallet = _sponsorWallet;
    }

    function makeRequestUint256() external {
        bytes32 requestId = airnodeRrp.makeFullRequest(
            s_airnode,
            s_endpointIdUint256,
            address(this),
            s_sponsorWallet,
            address(this),
            this.fulfillRandomUnit256.selector,
            ""
        );

        emit RequestedRandomUint256(requestId);
    }

    function fulfillRandomUnit256(
        bytes32 requestId,
        bytes calldata data
    ) external onlyAirnodeRrp {
        s_randomUint256 = abi.decode(data, (uint256));

        emit ReceiveRandomUint256(requestId, s_randomUint256);
    }
}
