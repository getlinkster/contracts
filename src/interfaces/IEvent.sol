// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IEvent {
    enum SubscriptionType {
        EVENT,
        NETWORKING
    }

    enum SubscriptionTier {
        NONE,
        LIMITED,
        UNLIMITED
    }

    struct Subscription {
        SubscriptionType subscriptionType;
        SubscriptionTier subscriptionTier;
        uint256 endDate;
        address subscriber;
    }

    struct SubscriptionInfo {
        uint256 duration;
        uint256 priceInUSD;
    }

    event SentSubscriptionCrossChain(bytes32 indexed messageId);

    function setPayoutAddress(address _newPayoutAddress) external;

    function subscribe(
        SubscriptionType _type,
        SubscriptionTier _tier,
        address _subscriber
    ) external payable;

    function getSubscriptionInfo(
        address _wallet
    ) external view returns (Subscription memory, Subscription memory);

    function canCreateEvent(address _wallet) external view returns (bool);

    function canMakeContact(address _wallet) external view returns (bool);

    function payout() external;
}
