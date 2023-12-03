// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Constants {
    mapping(address => mapping(uint256 => Subscription)) public subsPerWallet;

    uint256 public constant EVENT_LIMITED_DURATION = 2629746; // 1 month
    uint256 public constant NETWORKING_LIMITED_DURATION = 864000; // 10 days

    uint256 public EVENT_LIMITED_SUBSCRIPTION_PRICE = 0.01 ether;
    uint256 public EVENT_UNLIMITED_SUBSCRIPTION_PRICE = 0.02 ether;

    uint256 public NETWORKING_BOOSTER_PRICE = 0.01 ether;
    uint256 public NETWORKING_UNLIMITED_SUBSCRIPTION_PRICE = 0.02 ether;

    address public payoutAddress;
}
