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
    mapping (uint256 => uint256) idToPrices;
    mapping(uint256 => address)tokenIdToAdress;

    //modifiers
    modifier canMint{
        require(!mintFinished,"Already minted");
        _;
    }


    constructor()ERC721("ALTD","ALT"){
         owner=msg.sender;
    }

    function mintNFT(string[] memory tokenURIs)public onlyOwner canMint{
        for(uint i=0;i<tokenURIs.length;i++){

            uint256 tokenId=tokenCounters.length;
            tokenCounters.push(tokenId);
            tokenIdExists[tokenId]=true;
            mintFinished=true;

            //mints NFT to this contract from which users can later purchase
            _safeMint(address(this),tokenId);

            //sets URI in the given tokenId's metadata
            //_setTokenURI(tokenId,tokenURIs[i]);
        }
    }

    function purchase(uint256 _tokenId)external payable {
        require(msg.value>=PRICE,"insufficient purchase amount");
        require(tokenIdExists[_tokenId],"NFT with this tokenId doesn't exist");

        tokenIdToAdress[_tokenId]=msg.sender;
        (bool sent,)=payable(msg.sender).call{value:msg.value}("");
        require(sent,"transfer failed");
        _safeTransfer(address(this),msg.sender,_tokenId);
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
    function getNumNFTs()public pure returns(uint256){
        return tokenCounters.length;
    }

}