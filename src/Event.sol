// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "./interfaces/IEvent.sol";
import "./Constants.sol";

contract Event is IEvent, Constants {
    event Console(
        uint256 costInEther,
        uint256 ethPriceInUSD,
        uint256 priceInUSD
    );
    AggregatorV3Interface internal dataFeed;

    mapping(address => mapping(uint256 => Subscription)) public subsPerWallet;
    mapping(SubscriptionType => mapping(SubscriptionTier => SubscriptionInfo))
        public subscriptionInfo;

    modifier onlyAdmin() {
        payoutAddress = msg.sender;
        _;
    }

    constructor() {
        payoutAddress = msg.sender;

        dataFeed = AggregatorV3Interface(
            0x71b95cEA998831C28Eb7FF0AbFC80564C38Cf5A8
        ); // @dev AVAX / USD on Fuji

        subscriptionInfo[SubscriptionType.EVENT][
            SubscriptionTier.LIMITED
        ] = SubscriptionInfo({
            duration: EVENT_DURATION,
            priceInUSD: EVENT_LIMITED_SUBSCRIPTION_PRICE
        });

        subscriptionInfo[SubscriptionType.EVENT][
            SubscriptionTier.UNLIMITED
        ] = SubscriptionInfo({
            duration: EVENT_DURATION,
            priceInUSD: EVENT_UNLIMITED_SUBSCRIPTION_PRICE
        });

        subscriptionInfo[SubscriptionType.NETWORKING][
            SubscriptionTier.LIMITED
        ] = SubscriptionInfo({
            duration: NETWORKING_LIMITED_DURATION,
            priceInUSD: NETWORKING_BOOSTER_PRICE
        });

        subscriptionInfo[SubscriptionType.NETWORKING][
            SubscriptionTier.UNLIMITED
        ] = SubscriptionInfo({
            duration: NETWORKING_UNLIMITED_DURATION,
            priceInUSD: NETWORKING_UNLIMITED_SUBSCRIPTION_PRICE
        });
    }

    function setPayoutAddress(address _newPayoutAddress) external onlyAdmin {
        payoutAddress = _newPayoutAddress;
    }

    function setDataFeedAddress(address _dataFeed) external onlyAdmin {
        dataFeed = AggregatorV3Interface(_dataFeed);
    }

    function payout() external {
        require(msg.sender == payoutAddress, "Unauthorized payout");
        payable(payoutAddress).transfer(address(this).balance);
    }

    function subscribe(
        SubscriptionType _type,
        SubscriptionTier _tier,
        address _subscriber
    ) external payable {
        SubscriptionInfo memory info = subscriptionInfo[_type][_tier];

        uint256 ethPriceInUSD = uint256(getChainlinkDataFeedLatestAnswer());
        // @dev costInEther overflows and returns 0
        uint256 costInEther = info.priceInUSD / ethPriceInUSD;

        emit Console(costInEther, ethPriceInUSD, info.priceInUSD);

        // @dev trigger every 3600 seconds or high deviation
        require(msg.value >= costInEther, "Incorrect subscription cost");

        subsPerWallet[_subscriber][uint256(_type)] = Subscription({
            subscriptionType: _type,
            subscriptionTier: _tier,
            endDate: block.timestamp + info.duration,
            subscriber: _subscriber
        });
    }

    // @todo Add remaining logic
    function getSubscriptionInfo(
        address _wallet
    ) external view returns (Subscription memory, Subscription memory) {
        return (
            subsPerWallet[_wallet][uint256(SubscriptionType.EVENT)],
            subsPerWallet[_wallet][uint256(SubscriptionType.NETWORKING)]
        );
    }

    // @todo Add logic to check if the wallet can create an event
    function canCreateEvent(address _wallet) external view returns (bool) {
        return
            block.timestamp <
            subsPerWallet[_wallet][uint256(SubscriptionType.EVENT)].endDate;
    }

    // @todo Add logic to check if the wallet can make contact
    function canMakeContact(address _wallet) external view returns (bool) {
        return
            block.timestamp <
            subsPerWallet[_wallet][uint256(SubscriptionType.NETWORKING)]
                .endDate;
    }

    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        (, int answer, , , ) = dataFeed.latestRoundData();
        return answer;
    }
}
