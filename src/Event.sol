// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IEvent.sol";
import "./Constants.sol";

contract Event is IEvent, Constants {
    // @dev payout to ourselves??
    constructor() {
        payoutAddress = msg.sender;
    }

    function setPayoutAddress(address _newPayoutAddress) external onlyAdmin {
        payoutAddress = _newPayoutAddress;
    }

    function subscribe(
        SubscriptionType _type,
        SubscriptionTier _tier,
        address _subscriber
    ) external payable override {
        // @todo Implement the subscription logic

        uint256 duration;
        uint256 price;

        if (_type == SubscriptionType.EVENT) {
            if (_tier == SubscriptionTier.LIMITED) {
                duration = EVENT_LIMITED_DURATION;
                price = EVENT_LIMITED_SUBSCRIPTION_PRICE;
            } else if (_tier == SubscriptionTier.UNLIMITED) {
                duration = type(uint256).max; // Unlimited
                price = EVENT_UNLIMITED_SUBSCRIPTION_PRICE;
            }
        } else if (_type == SubscriptionType.NETWORKING) {
            if (_tier == SubscriptionTier.LIMITED) {
                duration = NETWORKING_LIMITED_DURATION;
                price = NETWORKING_BOOSTER_PRICE;
            } else if (_tier == SubscriptionTier.UNLIMITED) {
                duration = type(uint256).max; // Unlimited
                price = NETWORKING_UNLIMITED_SUBSCRIPTION_PRICE;
            }
        }

        require(msg.value == price, "Incorrect subscription cost");

        // @dev Update subscription information
        subsPerWallet[_subscriber][_type] = Subscription({
            subscriptionType: _type,
            subscriptionTier: _tier,
            endDate: block.timestamp + duration,
            subscriber: _subscriber
        });
    }

    // @todo Add remaining logic
    function subscriptionInfo(
        address _wallet
    )
        external
        view
        override
        returns (Subscription memory, Subscription memory)
    {
        return (
            subsPerWallet[_wallet][SubscriptionType.EVENT],
            subsPerWallet[_wallet][SubscriptionType.NETWORKING]
        );
    }

    // @todo Add logic to check if the wallet can create an event
    function canCreateEvent(
        address _wallet
    ) external view override returns (bool) {
        return
            block.timestamp <
            subsPerWallet[_wallet][SubscriptionType.EVENT].endDate;
    }

    // @todo Add logic to check if the wallet can make contact
    function canMakeContact(
        address _wallet
    ) external view override returns (bool) {
        return
            block.timestamp <
            subsPerWallet[_wallet][SubscriptionType.NETWORKING].endDate;
    }

    // @todo Add payout logic
    // @todo e.g. transfer funds to the payout address
    function payout() external override {
        require(msg.sender == payoutAddress, "Unauthorized payout");
        payable(payoutAddress).transfer(address(this).balance);
    }
}
