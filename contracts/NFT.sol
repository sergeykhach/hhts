// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; //sa poxum enq takinov, upgradable enq sarqum sagh, takinnern el nuyn dzev

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";//es toghy avaleacnu enq vor modificator initializer ogtagorcenq constructory poxaren
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol"; //uups

contract MyToken is Initializable, ERC721Upgradeable, ERC721URIStorageUpgradeable, OwnableUpgradeable, UUPSUpgradeable 
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter private _tokenIdCounter;
    
// constructor() ERC721("MyToken", "MTK") {} //upgradable contractnery chen karogh constructor unenal, dra hamar ogtagorcum enq taki psevdo konstructory initial...

//initializer- modificator a vercvum a verevic vor mi angam kanchenq constructori nman //sarqum u initilize enq anum construtori nman 
    function initialize() initializer public {
        __ERC721_init("MyToken", "MTK");
        __ERC721URIStorage_init();
        __Ownable_init();
        __UUPSUpgradeable_init(); 
    }//sranq el initialize enq anum vor or vladeleci v momont depolya ustanovit ani

     function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

   function _authorizeUpgrade(address newImplementation) internal onlyOwner override {}
} //es funkcian uupsi mej menak vortev stegh qani vor sagh contracti mej a linelu himnaka funkcianery pity pashtpanvac only owner lini
//ete tery chi upgrade anum apa tranzakcian het kgna