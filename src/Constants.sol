// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Constants {
    uint256 public constant EVENT_DURATION = 2629746; // 1 month
    uint256 public constant NETWORKING_LIMITED_DURATION = 864000; // 10 days
    uint256 public constant NETWORKING_UNLIMITED_DURATION = 31536000; // 365 days

    uint256 public EVENT_LIMITED_SUBSCRIPTION_PRICE = 19000000000000000000; // $19
    uint256 public EVENT_UNLIMITED_SUBSCRIPTION_PRICE = 39000000000000000000; // $39

    uint256 public NETWORKING_BOOSTER_PRICE = 1990000000000000000; // $1.99
    uint256 public NETWORKING_UNLIMITED_SUBSCRIPTION_PRICE =
        99000000000000000000; // $59

    address public payoutAddress;

    uint64 MUMBAI_CHAIN_SELECTOR = 12532609583862916517;
}
