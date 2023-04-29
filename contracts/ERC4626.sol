// SPDX-License-Identifier: MIT

/* https://eips.ethereum.org/EIPS/eip-4626 stegha standarti tesqy

Definitions:
asset: The underlying token managed by the Vault. Has units defined by the corresponding EIP-20 contract.
share: The token of the Vault. Has a ratio of underlying assets exchanged on mint/deposit/withdraw/redeem (as defined by the Vault).
fee: An amount of assets or shares charged to the user by the Vault. Fees can exists for deposits, yield, AUM, withdrawals, or anything else prescribed by the Vault.
slippage: Any difference between advertised share price and economic realities of deposit to or withdrawal from the Vault, which is not accounted by fees.
*/
pragma solidity ^0.8.0;

import "./ERC20.sol";  //podklyuchayu
import "./IERC4626.sol";
import "./utils/Math.sol";//openzepica gcel em utilis

//ushadir sa abstract contracta sra himan vra petqa inch vor ban sarqel, inqy ira deploy chi linum 
abstract contract ERC4626 is ERC20, IERC4626 { //stegh jarangum a
    using Math for uint256; //stegh gradarann em kpcnum

    IERC20 private immutable _asset; //_asset tokenna vor vklad enq anum
    uint8 private immutable _underlyingDecimals; // tveri qanakna storgrutyunic heto

    constructor(IERC20 asset_) { //IERC20 asset_ tokenni kontractna vor tokeni het enq ashxatelu es xranilishayum
        //aystegh mez petqa haskanal, asset_ kontractum tiv ka storaketic heto
        //dra hamar es _tryGetAssetDecimals OPZEp funkcianaogtagorcvum
        (bool success, uint8 assetDecimals) = _tryGetAssetDecimals(asset_);
       //u ete karacanq kardanq uremn ogtagorcum enq da, ete voch apa 18
        _underlyingDecimals = success ? assetDecimals : 18;
        _asset = asset_;
    } // sa num enq nra hamar vor decimals chka sra interfacum , bayc ka metadanninerum

   //ays func-ov yndunum enq SC-y u veradardznum enq ardyoq hajogh kardacvec ev mek el uin8 qani vor yst metadatayi standarti decimaly uint 8 a
    function _tryGetAssetDecimals(IERC20 asset_) private view returns(bool, uint8) {
     //nizkourovnevi vizov enq anum assety sarqum enq sovorakan hasce,heto staticcall-ov vortev view-a decimy metadadnnium   
        (bool success, bytes memory encodedDecimals) = address(asset_).staticcall(
    //aysinqn menq mtadan -  interf-ic vercnum enq decimelsi selectory, heto kodavorum enq u kanchum
            abi.encodeWithSelector(IERC20Metadata.decimals.selector)
        );
//stugum enq ete hajogha u uint8-a(stegh 32byte enq stugum vortev mnacac masy meka 0-ner a lcnum)
        if(success && encodedDecimals.length >= 32) {
          //hima decode enq anum u stegh 256bit a vor 32 bytna u vor chisht lini
            uint returnedDecimals = abi.decode(encodedDecimals, (uint256));
           //heto stugum enq vor en vor veradardzela gtnvum a uint8-i diapazoni mej
            if(returnedDecimals <= type(uint8).max) {
              //ete ok apa veradardznum enq true u uint8 enq sarqum ayd tivy
                //avel 0nery ktrtum enq
                return(true, uint8(returnedDecimals));
            }
        }
        return(false, 0);//hakarak depqum
    }

//veradardznum hascen asseti hascen vor vklad enq anum
    function asset() public view virtual returns(address) {
        return address(_asset);
    }
//asset-tokeni  balancy vor mer voultsi hasceyin ka
    function totalAssets() public view virtual returns(uint) {
        //dra hamar _asset.balanc...
        return _asset.balanceOf(address(this));
    }
//converta anum asety shari
    function convertToShares(uint assets) public view virtual returns(uint) {
        //kloracnum a nerqev Math.Rounding.Down, qani vor bajanumic misht chi vor celi tiva talis u petqa kloracnel
        return _convertToShares(assets, Math.Rounding.Down);
    }
//converta anum  shary aseti
    function convertToAssets(uint shares) public view virtual returns(uint) {
       //kloracnum a nerqev Math.Rounding.Down, qani vor bajanumic misht chi vor celi tiva talis u petqa kloracnel
        return _convertToAssets(shares, Math.Rounding.Down);
    }
//qani vor virtuala karas popoxes
    function maxDeposit(address) public view virtual returns(uint) {
        return type(uint256).max;//sahmanapakvac a uint256-ov
    }

    function maxMint(address) public view virtual returns(uint) {
        return type(uint256).max;//sahmanapakvac a uint256-ov
    }

//sahmanapakum inchqan kara asset hani yst ir hasceyi shari qanaki
    function maxWithdraw(address owner) public view virtual returns(uint) {
       //ushadir stegh balance kanchvuma nerqi tokeni aysinqn shari hamar
        //heto el konvert a anum asseti
        return _convertToAssets(balanceOf(owner), Math.Rounding.Down);
    }

//prosto stugum enq inchqan share uni u henc ed el max kara hani
    function maxRedeem(address owner) public view virtual returns(uint) {
        return balanceOf(owner);
    }

//esqan asseti nerdrman dimac inchqan share kstanam, prosto harc
    function previewDeposit(uint assets) public view virtual returns(uint) {
        return _convertToShares(assets, Math.Rounding.Down);
    }

//esqan share-i nerdrman dimac inchqan asset kstanam, prosto harc
    function previewMint(uint shares) public view virtual returns(uint) {
        return _convertToAssets(shares, Math.Rounding.Up);
    }

//esqan asseti haneluc dimac inchqan share piti tam, prosto harc
    function previewWithdraw(uint assets) public view virtual returns(uint) {
        return _convertToShares(assets, Math.Rounding.Up);
    }

//esqan share dimac inchqan asseti ktas, prosto harc
     function previewRedeem(uint shares) public view virtual returns(uint) {
        return _convertToAssets(shares, Math.Rounding.Down);
    }

//deposit anelu func himnakan
    function deposit(uint assets, address receiver) public virtual returns(uint) {
        require(assets <= maxDeposit(receiver));//pti <= lini im tuylatrvac max-ic

        uint shares = previewDeposit(assets); //hashvum enq inchqan a hasnum shares ed asseti dimac

        _deposit(msg.sender, receiver, assets, shares); //slujebni func asum enq msg.sendery vklad aanum receiver -i hamar asset u esqan shar a stanum 

        return shares;//verdardzbum a
    }

//asum em uzum em arnel es qan share
    function mint(uint shares, address receiver) public virtual returns(uint) {
        require(shares <= maxMint(receiver));//stugu asahmanapakumic mec chi

        uint assets = previewMint(shares);//hashvum a inchqan asset pti uzi, inchqan asset arji edqan shary

        _deposit(msg.sender, receiver, assets, shares);//slujebni func asum enq msg.sendery vklad aanum receiver -i hamar asset u esqan shar a stanum 

        return assets;
    }

//uzum em hanel edqan token, inchqan shar pti varenq
    function withdraw(
        uint assets,
        address receiver,
        address owner
    ) public virtual returns(uint) {
        require(assets <= maxWithdraw(owner));

        uint shares = previewWithdraw(assets);//tesnenq inchqan asset a linum edqan shari dimac

        _withdraw(msg.sender, receiver, owner, assets, shares); //slujebni func asum enq msg.sendery esqan asset a hanum receiver -i hamar u varuma esqan shar 

        return shares;
    }
//esel nuyn bany hakarak 
    function redeem(
        uint shares,
        address receiver,
        address owner
    ) public virtual returns(uint) {
        require(shares <= maxRedeem(owner));

        uint assets = previewRedeem(shares);

        _withdraw(msg.sender, receiver, owner, assets, shares);

        return assets;
    }
//nerqin funkcia voults ban mtcnelu hamar
    function _deposit(
        address caller,
        address receiver,
        uint assets,
        uint shares
    ) internal virtual {
       //ira tuylatvutyamb, aysinqn transferfrom-ov vercnum enq kanchoghic hashvic i ogut ays SC-i ira uzac qanaki asset
        _asset.transferFrom(caller, address(this), assets);
     // hima piti mint anenq hamapatasxan reciever-i ogtin chisht qanaki share
        _mint(receiver, shares);
//SOBITIYA sagh infoyo poradit
        emit Deposit(caller, receiver, assets, shares);
    }

//slujebni
    function _withdraw(
        address caller,
        address receiver,
        address owner,
        uint assets,
        uint shares
    ) internal virtual {
    //aysinqn ete es funkcian kanchum a voch te ownery, apap petqa stan     
     //nra tuylatvutyuny, shari vra qani vor ayl ban chenqnshel demic
        if(caller != owner) {
            _spendAllowance(owner, caller, shares);
        }
//uremn varum enq qani vor dra dimac pogh enq anum
        _burn(owner, shares);
//dranic heto xranilishayic chisht qanaki assetner ugharkum enq recieverin
        _asset.transfer(receiver, assets);
//sobitiya emit enq anum
        emit Withdraw(caller, receiver, owner, assets, shares);
    }

//eli slujebni
    function _convertToShares(
        uint assets,//yndunvac assetneri tivy vor pti konvert anenq
        Math.Rounding rounding //kloracnummenq
    ) internal view virtual returns(uint) {
        // (assets * totalSupply) / totalAssets inchqan shares pti tanq hashvum enq ays banadzevov
        //ogtvum en mathic muldiv = * heto /
        return assets.mulDiv(
            totalSupply() + 10 ** _decimalOffset(),//sranov bazmapatkuma, en decimal stroaketic heto tveri masin a heto ka
            totalAssets() + 1, //sra vra bajanum
            rounding //kloracnuma
        );
    }
//es el sharna convert anum assetneri nerqin func
    function _convertToAssets(
        uint shares,
        Math.Rounding rounding
    ) internal view virtual returns(uint) {
        return shares.mulDiv(
            totalAssets() + 1,
            totalSupply() + 10 ** _decimalOffset(),
            rounding
        );
    }
//decimal vrtual enq sarqum inchqan uzum es gri defaulty 0ya
    function _decimalOffset() internal view virtual returns(uint8) {
        return 0;
    }
}