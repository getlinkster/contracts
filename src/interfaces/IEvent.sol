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

    function subscribe(
        SubscriptionType _type,
        SubscriptionTier _tier,
        address _subscriber
    ) external payable;

    function subscriptionInfo(
        address _wallet
    ) external view returns (Subscription memory, Subscription memory);

    function canCreateEvent(address _wallet) external view returns (bool);

    function canMakeContact(address _wallet) external view returns (bool);

    function payout() external;
}
