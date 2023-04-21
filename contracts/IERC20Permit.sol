// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20Permit {
    //ays funkciayum stugvum a nayev vor ardyoq storagryuny korekt a, ev ownerna storagrel
    function permit( //himnakan funkcian tuylatvutyun, vortegh poxancum enq
        address owner, //ova tuyl talis
        address spender,// uma tuyl talis
        uint value, //inchqan atuyl talis
        uint deadline, // minchev erb
        uint8 v, // Storagrutyan ereq masery
        bytes32 r,//
        bytes32 s//
    ) external;

    function nonces(address owner) external view returns(uint);//hashvum a te ownery inchqan mesage a ugharkel storagrac, vor mi qani angam mi bany chugharken

// stroka vor mtcnum a element sluchaynosti, dranum drvuma info ova stugelu storagrutyuny, aysinqn inch sc inch versia ev ayln
    function DOMAIN_SEPARATOR() external view returns(bytes32);
}