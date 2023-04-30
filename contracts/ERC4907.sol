// SPDX-License-Identifier: MIT

//Standart NFT Arenda enq talis inch vor jamanakov
//ogtagorcum a
//https://eips.ethereum.org/EIPS/eip-4907 
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./IERC4907.sol";

contract ERC4907 is ERC721, IERC4907 {
    //struct useri masin ova usery erba prcnum arendan
    struct UserInfo {
        address user;
        uint64 expires;
    }
// u ed sagh kpahenq _users mappingum vortex key tokenIDna uint256-i tesqov isk znachenin verevi structy
    mapping(uint256 => UserInfo) internal _users;
//constructory kynduni NFT- anuny ev symvoly, u heto prosto deligiruem 721-iy
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {

    }
//asum enq vor satarum enq hamapatasxan interfacy kam gnum enq vererv yst herarxiayi u harcnum enq yndegh poderjivaem ili net
 //partidr chi es funkcian bayc lav tona cankali a vor lini
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC4907).interfaceId || super.supportsInterface(interfaceId);
    }

//user enq dnum u ov kara ayn ani 
    function setUser(uint tokenId, address user, uint64 expires) public virtual {
        //ERC721-ic a _isaprov....
        require(_isApprovedOrOwner(msg.sender, tokenId));//ov vor es kanchum a kam tery piti lini kam operatorna(voch yuser) aysinqn iran tuyl en atalis upravlyat
// ete sagh lava uremn 
//struct UserInfo pahum enq storagum info popoxakan, vorin veragrum enq
//_users maping token ID keyov
//heto structi mej user i anuny u expires enq dnum
        UserInfo storage info = _users[tokenId];
        info.user = user;
        info.expires = expires;
//sobitiya en qemit anum
        emit UpdateUser(tokenId, user, expires);
    }

//ova es tokenId-ov NFT usery
    function userOf(uint tokenId) public view virtual returns(address) {
        // ete ka userExpire data vory uint64 a ev vory menq sarqum enq uint256 qani vor bloc.timestamy uint256 aveli meca qan da
        if(uint256(userExpires(tokenId)) >= block.timestamp) {
            //veradardznum enq usery addressy
            return _users[tokenId].user;
        } else {
            //hakarak depqum 0yakan
            return address(0);
        }
    }// u sa cuyc a talis vor inchi kariq chka arandzin gorcoghutyamb
    //iran jnjel, ete jamanaky prcela uremn meka 0ya talis, uint- defaultnel a 0

//stegh el nayum enq erba verjanum, arendayi sroky ed NFT-i hamar
    function userExpires(uint tokenId) public view virtual returns(uint) {
        return _users[tokenId].expires;
    }

//partadir chi bayc, ete tokeny gnacel urish tiroj sepakanutyun apa cankali a veracnel
//userin vory yndegh arendadator a 
//OP ZEp-ic a
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint batchSize //paketi chapy
    ) internal virtual override {
        //asum enq mi makardak verev dzer aharcery luceq
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
// asum enq ete mard ka vor yndegh hima inch vor bana arenda a anum
        if(from != to && _users[tokenId].user != address(0)) {
           //default kanenq 0 ksarqenq iran
            delete _users[tokenId];
//voch mek meznic voch mi ban arenda chi anum
            emit UpdateUser(tokenId, address(0), 0);
        }
    }
} 
