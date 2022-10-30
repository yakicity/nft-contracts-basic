// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";

contract EventNFT is ERC721URIStorage, Ownable
{
    /** 
     * @dev
     * - URI設定時に誰がどのtokenIdに何のURIを設定したか記録する
     */    
    event TokenURIChanged(address indexed sender, uint256 indexed tokenId, string uri);
    
    constructor() ERC721("EventNFT","EVENTNFT"){}


    /** 
     * @dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - nftMint関数の実効アドレスにtokenIdを紐づけ
     * - mintの際にURIを_setTokenURI()で設定
     * - EVENT 発火　emit TokenURIChanged
     */
    function nftMint(uint256 tokenId, string calldata uri) public onlyOwner{
        _mint(_msgSender(),tokenId);
        _setTokenURI(tokenId,uri);
        emit TokenURIChanged(_msgSender(), tokenId, uri);
    }

}