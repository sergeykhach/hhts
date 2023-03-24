pragma solidity ^0.8.0;

interface IERC1155 {
   //sob. bil pereveden odin tip tokena na kakoy to addres
    //operator ov inicia arel tx, vorteghic ur, konkret tokeni ID, inchqan token enq ugharkel es tx-ov
    event TransferSingle( 
        address indexed operator,
        address indexed from,
        address indexed to,
        uint id,
        uint value
    );
// sob., vor gazi ekonomiya hamar minagamich pachkov token ugharkelu masina
//operator ov inicia arel tx, vorteghic ur, tokenneri ID-neri array, inchqan tokenneri array enq ugharkel es tx-ov
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint[] ids,
        uint[] values
    );

//721 el ka bolor tokkennri hamar inch vor operatorin karavarelu iravunq enq tali
//or. khanut bool kam talis enq kam vekalum enq
    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approved
    );

// sob. talis enq konkret token ID silka vortegh karanq iran gtnenq
    event URI(string value, uint indexed id);

//yndun enq en acc. vori hamar uzum enq balancy nayenq, ev tokeni ID-n 
    function balanceOf(address account, uint id) external view returns(uint);

//mi vizovo karum enq mi qani acc balancnery yndunenq dra hamar massivnery
    function balanceOfBatch(
        address[] calldata accounts,
        uint[] calldata ids
    ) external view returns(uint[] memory);

// tasli enq mi op.mer tokenneri karav. iravunq talis enq kam vercnum 
    function setApprovalForAll(
        address operator,
        bool approved
    ) external;

// stugum enq mi op.mer tokenneri karav. iravunq uni te che 
    function isApprovedForAll(
        address account,
        address operator
    ) external view returns(bool);

//stegh menak safe transfera, verjum stugum enq karuma ynduni teche  ete sm.c a petqa funena funkcia u veradarzdnum chisht selector
    function safeTransferFrom(
        address from,
        address to,
        uint id,
        uint amount,
        bytes calldata data
    ) external;

//nuyny paketova dra hamar massivnera
    function safeBatchTransferFrom(
        address from,
        address to,
        uint[] calldata ids,
        uint[] calldata amounts,
        bytes calldata data
    ) external;
}