// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";

contract OffURIUnchangeable is ERC721URIStorage, Ownable
{
    constructor() ERC721("OffURIUnchangeable","OFFU"){}

    /** 
     * @dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - nftMint関数の実効アドレスにtokenIdを紐づけ
     * - mintの際にURIを_setTokenURI()で設定
     */
    function nfgMint(uint256 tokenId, string calldata uri) public onlyOwner{
        _mint(_msgSender(),tokenId);
        _setTokenURI(tokenId,uri);
    }

}