// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Strings.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Burnable.sol";

contract BurnableNFT is ERC721URIStorage, ERC721Burnable,Ownable
{
    /** 
     * @dev
     * - Counters というライブラリのCounterという構造体に対し、Countersライブラりの全関数をattachする
     * - _tokenIdsはCountersの全関数が利用可能
     */  
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    /** 
     * @dev
     * - URI設定時に誰がどのtokenIdに何のURIを設定したか記録する
     */    
    event TokenURIChanged(address indexed sender, uint256 indexed tokenId, string uri);
    
    constructor() ERC721("BurnableNFT","BURN"){}


    /** 
     * @dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - tokenIdをインクリメント（デフォルトは0なので今回は1始まりのIDになる）
     * - nftMint関数の実効アドレスにtokenIdを紐づけ
     * - mintの際にURIを_setTokenURI()で設定
     * - EVENT 発火　emit TokenURIChanged
     */
    function nftMint() public onlyOwner{
        
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(_msgSender(),newTokenId);

        string memory jsonFile = string(abi.encodePacked('metadata',Strings.toString(newTokenId),'.json'));
        _setTokenURI(newTokenId,jsonFile);

        emit TokenURIChanged(_msgSender(), newTokenId, jsonFile);
    }

    /** 
     * @dev
     * - URIプレフィックスの設定
     */ 
    function _baseURI() internal pure override returns(string memory){
        return "ipfs://bafybeigyod7ldrnytkzrw45gw2tjksdct6qaxnsc7jdihegpnk2kskpt7a/";
    }

    /** 
     * @dev
     * オーバーライド
     */ 
    function tokenURI(uint256 tokenId) public view override(ERC721,ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }
    /** 
     * @dev
     * オーバーライド
     */ 
    function _burn(uint256 tokenId) internal override(ERC721,ERC721URIStorage){
        super._burn(tokenId);
    }

}