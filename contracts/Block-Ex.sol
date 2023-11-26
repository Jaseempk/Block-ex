//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IFakeNFTMarketPlace{
    function purchase(uint256 _tokenId)external payable{}
    function available(uint256 tokenId)public pure returns(bool){}
    function getTokenId(uint256 tokenIndex)public pure returns(uint256){}
}

contract BlockEx is ERC721{

    IFakeNFTMarketPlace marketPlace;
    
    //enum
    enum Operation{
        BUY,
        SELL
    }

    struct TransactionData{
        uint256 tokenId;
        Operation operation;
        uint256 buyOrSellPrice;
        address from;

    }

    constructor(IFakeNFTMarketPlace _fakeNFTMarketPlace){
        marketPlace=IFakeNFTMarketPlace(_fakeNFTMarketPlace);
    }

}