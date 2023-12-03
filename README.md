# Loopso smart contracts

## Contract addresses:     
- Mumbai:     
Loopso.sol: 0xF077ad939698F5240699Fd900C3536eE1Be445e5      
TokenFactory.sol: 0x650C13cc6C043fc361fc459c487bf173654CD944     
Lajo$Token: 0x8cBF42B6590614AbE7AB5ffc89aF153F5d620fC3     
LajosNFT: 0xdc1C3734165aB9f0336eb6d10feCFD62c9CF28cc   
WMATIC: 0xBAABeA853DD0BE32Df73083129070c65314cF0Ea  
     
- LUKSO:     
Loopso.sol: 0xD2dd677cfb7e31E7F8467d53585c3b517930ff52
TokenFactory.sol: 0x75d66bD4750f2f0A08B0BdD49df9eeC82Fa964eE   
WrappedLajo$Token: 0x4EFCc784eA3E259bdA3c6311D448416959B9bB9C     
WrappedLajosNFT: 0xf60b63DbA61F14647D9a146113548fB341A87d12  
WLYX: 0x5119A7Af90339D645ccdf9332d7813d4940DA19B  
     
AttestationID on Lukso for Lajo$Token: 0xa458b7ff0eb3c12e6e58c218f2a3111ab6cf26f757548bce2c887731f419675c      
AttestationID on Lukso for LajosNFT: 0x16521564d9ada82ba73fddb52616ffd7adc98ff5efe46035f86429e55cb66736      
     
## Token attestation:    
- Chain B must be able to identify a Chain A token   
- addresses don't mean anything since they can differ from chain-to-chain    
- we use attestations: The bridge admin calls on Chain B with details of a Chain A token    
- afterwards Chain B can use this to idenfity a Chain A token    

## Example: bridging 200 USDC from mainnet to Lukso.    
1. user calls ```bridgeTokens(uint256 _amount, address _to, bytes32 _tokenID)```, where ```_tokenID``` is the id of the attestation we recorded about the token. The bridge takes ```_amount``` tokens from the user.    
2. Bridge emits ```TokensBridged``` event with the transfer ID.    
3. Relayer uses the transfer ID to get the transfer details from the bridge. We can implement verification etc. here.    
4. Relayer calls ```releaseWrappedTokens``` on Chain B.    
5. Chain B mints ```_amount``` wrapped tokens, and emits an event that we can use on the frontend to notify the user that briding was successful.    

If the user wants to bridge back, it calls ```bridgeTokensBack```, which burns the amounts of wrapped tokens, and emits a ```TokensBridgedBack``` event which is similar to ```TokensBridged```. Relayer picks it up, calls ```releaseTokens``` on Chain A. The Chain A bridge transfers the amount of tokens to the user.  

![loopso](https://github.com/useloopso/contracts/assets/44027725/0fe78522-4a53-4cc7-8b90-7333e38ed38e)
