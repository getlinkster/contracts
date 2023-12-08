// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Client} from "@ccip/src/v0.8/ccip/libraries/Client.sol";
import {CCIPReceiver} from "@ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";

import "./interfaces/IEvent.sol";

contract SubscriptionRecorderPolygon is CCIPReceiver {

    mapping(address => mapping(uint256 => IEvent.Subscription)) public subscriptions;

    address AVAX_CONTRACT_ADDRESS;

    constructor(address _avaxContractAddress, address router) CCIPReceiver(router) {
        AVAX_CONTRACT_ADDRESS = _avaxContractAddress;
    }

    function _ccipReceive(
        Client.Any2EVMMessage memory any2EvmMessage
    ) internal override {
        (IEvent.SubscriptionType subType, IEvent.SubscriptionTier subTier, uint256 endDate, address subscriber) = abi.decode(any2EvmMessage.data, (IEvent.SubscriptionType, IEvent.SubscriptionTier, uint256, address));

        IEvent.Subscription memory _subscription = IEvent.Subscription(
            subType,
            subTier,
            endDate,
            subscriber
        );
        subscriptions[subscriber][uint256(subType)] = _subscription;
    }

    function hasValidSubscription(address _address, IEvent.SubscriptionType _type) external view returns (bool) {
        return subscriptions[_address][uint256(_type)].endDate > block.timestamp;
    }

    function setAvaxContractAddress(address _avaxContractAddress) external {
        AVAX_CONTRACT_ADDRESS = _avaxContractAddress;
    }

}