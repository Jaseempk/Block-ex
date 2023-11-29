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


    uint256 public constant PRICE=0.01 ether;
    uint256[] public tokenCounters;
    bool public mintFinished=false;

    //mapping
    mapping(uint256 => bool)public tokenIdExists;
    mapping(uint256 => address)tokenIdToAdress;

    //modifiers
    modifier canMint{
        require(!mintFinished,"Already minted");
        _;
    }


    constructor()ERC721("ALTD","ALT"){
    }

    function mintNFT(uint256 numTokens)public onlyOwner canMint{
        for(uint i=0;i<=numTokens;i++){

            uint256 tokenId=tokenCounters.length;
            tokenCounters.push(tokenId);
            mintFinished=true;

            //mints NFT to this contract from which users can later purchase
            _mint(address(this),tokenId);

            tokenIdExists[tokenId]=true;
            //sets URI in the given tokenId's metadata
            //_setTokenURI(tokenId,tokenURIs[i]);
        }
    }

    function purchase(uint256 _tokenId)external payable {
        require(msg.value>=PRICE,"insufficient purchase amount");
        require(tokenIdExists[_tokenId],"NFT with this tokenId doesn't exist");

        tokenIdToAdress[_tokenId]=tx.origin;
        (bool sent,)=payable(tx.origin).call{value:msg.value}("");
        require(sent,"transfer failed");
        _transfer(address(this),tx.origin,_tokenId);
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
        return tokenIdToAdress[_tokenId];
    }
    function getNumNFTs()public view returns(uint256){
        return tokenCounters.length;
    }

}