// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

//SPDX-License-Identifier:MIT


pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FakeNFTMarketPlace is ERC721Enumerable,Ownable{


    uint256 public constant PRICE=0.009 ether;
    uint256[] public tokenCounters;
    bool public mintFinished=false;

    //mapping
    mapping(uint256 => bool)public tokenIdExists;
    mapping(uint256 => address)tokenIdToAddress;

    //modifiers
    modifier canMint{
        require(!mintFinished,"Already minted");
        _;
    }


    constructor()ERC721("ALTD","ALT"){
    }

    function mintNFT(uint256 numTokens)public onlyOwner canMint{
        for(uint i=0;i<=numTokens;i++){

            uint256 tokenID=tokenCounters.length+1;
            tokenCounters.push(tokenID);
            mintFinished=true;

            //mints NFT to this contract from which users can later purchase
            _mint(address(this),tokenID);

            tokenIdExists[tokenID]=true;

            //sets URI in the given tokenId's metadata
            //_setTokenURI(tokenId,tokenURIs[i]);
        }
    }

    function purchase(uint256 _tokenId,address _buyer)external payable {
        require(msg.value>=PRICE,"insufficient purchase amount");
        require(tokenIdExists[_tokenId],"NFT with this tokenId doesn't exist");

        tokenIdToAddress[_tokenId]=_buyer;
        (bool sent,)=payable(msg.sender).call{value:msg.value}("");
        require(sent,"transfer failed");
        /**
         * 
        approve(msg.sender,_tokenId);
        transferFrom(address(this),_buyer,_tokenId);
         * 
         */
        _transfer(address(this),_buyer,_tokenId);
    }

    function available(uint256 _tokenId)public view returns(bool){
        return tokenIdExists[_tokenId];
    }

    function getPrice()public pure returns(uint256){

        return PRICE;
    }
    function getTokenId(uint256 tokenIndex)public view returns(uint256){
        return tokenCounters[tokenIndex];
    }
    function getTokenOwner(uint256 _tokenId)external view returns(address){
        return tokenIdToAddress[_tokenId];
    }
    function getNumNFTs()public view returns(uint256){
        return tokenCounters.length;
    }

}