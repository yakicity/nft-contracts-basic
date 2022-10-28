// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";

contract OnlyOwnerMintWithModifier is ERC721
{
    /**
     * @dev
     * - このコントラクトをデプロイしたアドレス用変数owner
     */
    address public owner;
    
    constructor() ERC721("OnlyOwnerMintWithModifier","OWNERMOD"){
        ///transaction送信者のアドレス
        owner = _msgSender();
    }

    /**
     * @dev
     * - このコントラクトをデプロイしたアドレスだけに制御する
     */
    modifier onlyOwner{
        ///transactionの発行者==contractのowner
        require(owner == _msgSender(),"Caller is not the owner.");
        ///呼び出しもとに戻る
        _;
    }

    /** 
     * @dev
     * - このコントラクトをデプロイしたアドレスだけがmint可能 onlyOwner
     * - nftMint関数の実効アドレスにtokenIdを紐づけ
     */
    function nfgMint(uint256 tokenId) public onlyOwner{
        _mint(_msgSender(),tokenId);
    }
}