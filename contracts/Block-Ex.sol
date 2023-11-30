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

/**
 * import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.9/contracts/access/Ownable.sol";
   import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.9/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
 */

//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

interface IFakeNFTMarketPlace{
    function available(uint256 tokenId)external pure returns(bool);
    function getTokenId(uint256 tokenIndex)external pure returns(uint256);
    function getPrice()external pure returns(uint256);
    function getNumNFTs()external pure returns(uint256);
    function getTokenOwner(uint256 _tokenId)external view returns(address);
    function purchase(uint256 _tokenId,address _buyer)external payable;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
}

contract BlockEx {

    //Structs
    struct TxnData{
        uint256 tokenId;
        address owner;
        address seller;
        uint256 price;
    }

    //State variables
    IFakeNFTMarketPlace marketPlace;
    
    address public owner;
    uint256 public constant tradeFee=0.001 ether;
    uint256 public purchaseCount;

    //mapping
    mapping(uint256 =>TxnData)public idToData;


    //events
    event InitialNFTPurchaseDone(address buyer,uint256 tokenId);
    event ListedForSale(
        uint256 tokenId,
        address owner,
        address seller,
        uint256 price
    );

    constructor(IFakeNFTMarketPlace _fakeNFTMarketPlace){
        marketPlace=IFakeNFTMarketPlace(_fakeNFTMarketPlace);
        owner=payable(msg.sender);
    }

    function initialPurchase(uint256 __tokenId)public payable{
        uint256 initialPurchaseAmt=marketPlace.getPrice();

        require(msg.value>=initialPurchaseAmt,"insufficient purchase amount");
        require(marketPlace.available(__tokenId),"NFT _tokenId doesn't exist");
        marketPlace.purchase{value:initialPurchaseAmt}(__tokenId,msg.sender);
        purchaseCount+=1;

        emit InitialNFTPurchaseDone(msg.sender,__tokenId);
    }

    function listingForSale(uint256 _tokenId,uint256 _price)external payable {
        
        //Checks whether the person listing the NFT is its actual owner
        require(marketPlace.getTokenOwner(_tokenId)==msg.sender,"Only owner can list their NFTs");

        require(msg.value>=tradeFee,"No trading fee,no listing!!");

        //Ensuring if the given tokenId is valid
        require(marketPlace.available(_tokenId),"This NFT doesn't exist");

        idToData[_tokenId]=TxnData(

            _tokenId,
            payable(address(this)),
            payable(msg.sender),
            _price
        );
        //transfering the NFT for sale into the exchange contract from the seller
        marketPlace.transferFrom(msg.sender,address(this),_tokenId);

        emit ListedForSale(
            _tokenId,
            address(this),
            msg.sender,
            _price
        );

    }
    //To access all the transaction datas happened sofar
    function getAllDatas()public view returns(TxnData[] memory){

        //array of type TxnData which contains all TxnDatas
        TxnData[] memory txnDatas=new TxnData[](purchaseCount);
        uint256 currentId;
        uint256 currentIndex=0;

        for(uint i=0;i<=purchaseCount;i++){
            currentId=i+1;
            TxnData storage currentItem = idToData[currentId];
            txnDatas[currentIndex]=currentItem;
            currentIndex+=1;
        }

        return txnDatas;
    }

    function getMyDatas() public view returns(TxnData[] memory){
        uint256 numNFTs=0;
        uint256 currentId;
        uint256 currentIndex=0;
        for(uint i=0;i<=purchaseCount;i++){
            //Obtain the number of nfts the function caller owns
            if(idToData[i+1].owner==msg.sender || idToData[i+1].seller==msg.sender){
                numNFTs+=1;
            }
        }
        TxnData[] memory myNFTs=new TxnData[](numNFTs);
        for(uint i=0;i<=purchaseCount;i++){
            if(idToData[i+1].seller==msg.sender || idToData[i+1].owner==msg.sender){
                currentId=i+1;
                TxnData storage currentItem = idToData[currentId];

                //NFTs owned by the msg.sender
                myNFTs[currentIndex]=currentItem;
            }
        }
        return myNFTs;
    }
    //selling of the listed NFTs
    function executeSale(uint256 _tokenId)external payable {

        uint256 price=idToData[_tokenId].price;
        address seller=idToData[_tokenId].seller;
        require(msg.value>=price,"insufficient trading fee");

        //Re-assigning the buyer as the new seller of that particular NFT
        idToData[_tokenId].seller=payable(msg.sender);


        //transferring the NFT from the exchange to the buyer address
        marketPlace.transferFrom(address(this),msg.sender,_tokenId);
        //approving the contract to spend the this NFT on behalf of the buyer for the future resell or trades like that
        marketPlace.approve(address(this),_tokenId);

        //paying the owner of the contract a trading fee for the transaction
        payable(owner).transfer(tradeFee);

        //sending the buyer the price of their NFT
        payable(seller).transfer(msg.value);


    }

    function getPurchaseCount()public view returns(uint256){
        return purchaseCount;
    }
    receive() external payable {}

}