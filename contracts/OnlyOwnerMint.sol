// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";

contract OnlyOwnerMint is ERC721
{
    /**
     * @dev
     * - このコントラクトをデプロイしたアドレス用変数owner
     */
    address public owner;
    
    constructor() ERC721("OnlyOwnerMint","OWNER"){
        ///transaction送信者のアドレス
        owner = _msgSender();
    }

    /** 
     * @dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 require
     * - nftMint関数の実効アドレスにtokenIdを紐づけ
     */
    function nfgMint(uint256 tokenId) public {
        ///transactionの発行者==contractのowner
        require(owner == _msgSender(),"Caller is not the owner.");
        _mint(_msgSender(),tokenId);
    }
}