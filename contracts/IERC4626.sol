// SPDX-License-Identifier: MIT

//https://eips.ethereum.org/EIPS/eip-4626 stegha standarti tesqy
/*
Definitions:
asset: The underlying token managed by the Vault. Has units defined by the corresponding EIP-20 contract.
share: The token of the Vault. Has a ratio of underlying assets exchanged on mint/deposit/withdraw/redeem (as defined by the Vault).
fee: An amount of assets or shares charged to the user by the Vault. Fees can exists for deposits, yield, AUM, withdrawals, or anything else prescribed by the Vault.
slippage: Any difference between advertised share price and economic realities of deposit to or withdrawal from the Vault, which is not accounted by fees.
*/

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./IERC20Metadata.sol"; //anun simvol decimals

interface IERC4626 is IERC20, IERC20Metadata {
    event Deposit(
        address indexed sender,
        address indexed owner,
        uint assets, 
        uint shares
    ); //sob, token nerdrecinq

    event Withdraw(
        address indexed sender,
        address indexed receiver,
        address indexed owner,
        uint assets,
        uint shares
    );//token vercrecinq sobitiya

    function asset() external view returns(address assetTokenAddress);//asset ayn tokenna vor konkret, nerdrvuma. Ays funcy pastaci veradardznum a ays tokeny realizacnogh SC hascen.

//inchqan ka yndhanur es tokenic xranilishayum
    function totalAssets() external view returns(uint totalManagedAssets);

//convert a num asety shari
    function convertToShares(uint assets) external view returns(uint shares);
//ev hakaraky
    function convertToAssets(uint shares) external view returns(uint assets);
//inchqan max asset karas nerdnes
    function maxDeposit(address receiver) external view returns(uint maxAssets);
//ays funkcian cuyc a talis (aranc nerdrman) te vorqan karas stanas share drvac asset-i dimac
    function previewDeposit(uint assets) external view returns(uint shares);

// himnakan deposit кладёт указанное количество токенов, создаёт n-ное кол-во долей
    function deposit(uint assets, address receiver) external returns(uint shares);

    //inchqan maximum kara linel shares ed hasceyov
    function maxMint(address receiver) external view returns(uint maxShares);
   
    //gnahatum enq inchqan asset ktanq edqan shares i dimac mint aneluc
    function previewMint(uint shares) external view returns(uint assets);

    // создаёт указанное кол-во долей, высчитывает сколько токенов нужно взять
    // у юзера, который ф-цию вызвал
    function mint(uint shares, address receiver) external returns(uint assets);

    //sahmanapakum inchqan kara asset hani
    function maxWithdraw(address owner) external view returns(uint maxAssets);
    
    //harcnum enq esqan asset vercnem het inchqan share ktam
    function previewWithdraw(uint assets) external view returns(uint shares);

    // возвращает указанное кол-во токенов, сжигает соотв. кол-во долей
    function withdraw(uint assets, address receiver, address owner) external returns(uint shares);
    
   //aravelaguyny im unecac hasceyi shari dimac inchqan karam stanamasset het
    function maxRedeem(address owner) external view returns(uint maxShares);

    //hashvuma inchqan karam stanam im shari dimac token
    function previewRedeem(uint shares) external view returns(uint assets);

    // сжигает ровно указанное кол-во долей, возвращает некоторое кол-во токенов
    // в соответствии с этими долями, 
    function redeem(uint shares, address receiver, address owner) external returns(uint assets);
}