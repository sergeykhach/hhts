// SPDX-License-Identifier: MIT

//openzepi fitcheri mej Supply trackingy jetevum a skolko vsego tokenov oborotum ka
//pausablenel jamanakavorapes argelum a tokenneri transferu u minty
//kareli a nayel nayev opzep-contracts/token/ERC1155/extensions
pragma solidity ^0.8.0;

import "./IERC1155.sol";
import "./IERC1155MetadataURI.sol";
import "./IERC1155Receiver.sol";

contract ERC1155 is IERC1155, IERC1155MetadataURI {// jaranguma
    //skolko raznix tipov tokenov lejit na tom ili addrese v kakom to kolichest
    mapping(uint => mapping(address => uint)) private _balances;
    //tuyl a talis a inch vor acc tokenneri upravleni kam chuni ed iravunqy
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    string private _uri; //URI cuyc talis vortegh kareli agtnel

    constructor(string memory uri_) {
        _setURI(uri_); //func pti yndunenq basaviy silken, vory sam razrabotchiky kara poxi 
    }

//veradardznum a URI, virtual tuyl atalisy pereopredelyat
    function uri(uint) external view virtual returns(string memory) {
        return _uri;
    }

//yndun enq en acc. vori hamar uzum enq balancy nayenq, ev tokeni ID-n 
    function balanceOf(address account, uint id) public view returns(uint) {
        require(account != address(0)); //stugum enq 0yakan hascen
        return _balances[id][account]; // stugum enq vorqan konkret ID token ka kokret hasceum
    }

//mi vizovo karum enq mi qani acc balancnery yndunenq dra hamar massivnery
    function balanceOfBatch(
        address[] calldata accounts,
        uint[] calldata ids
    ) public view returns(uint[] memory batchBalances)//return masivin anun enq talis, u ira erk. el havasar acc masivin 
    {
        require(accounts.length == ids.length); //asum enq vor vor es erku massivneri erkarutyuny pti nuyny lini

        batchBalances = new uint[](accounts.length);//qani vor memory um chenq kara dimnaik massiv sarqen dra ahamr ogt havasar erk, steghcum enq fiqsvac erk massiv

        for(uint i = 0; i < accounts.length; ++i) {// massivov pttvum enq
            batchBalances[i] = balanceOf(accounts[i], ids[i]);//u amen mi andmin veragrum konkret ID ov balans kokret acc
        }//return el chenq grum qani vor avtomat kber verevum anun enq tvel
    }

// tasli enq mi op.mer tokenneri karav. iravunq talis enq kam vercnum 
    function setApprovalForAll(
        address operator,
        bool approved
    ) external {
        _setApprovalForAll(msg.sender, operator, approved);
    }

// stugum enq mi op.mer tokenneri karav. iravunq uni te che 
    function isApprovedForAll(
        address account,
        address operator
    ) public view returns(bool) {
        return _operatorApprovals[account][operator];
    }

//stegh menak safe transfera, verjum stugum enq karuma ynduni teche  ete sm.c a petqa funena funkcia u veradarzdnum chisht selector
    function safeTransferFrom(
        address from,
        address to,
        uint id,
        uint amount,
        bytes calldata data
    ) external {
        require(
            from == msg.sender ||
            isApprovedForAll(from, msg.sender)
        );//kam terna kam uni sagh aac karavarelu tuyla

        _safeTransferFrom(from, to, id, amount, data);//deligate enq anum slujebnia
    }

//nuyny paketova dra hamar massivnera
    function safeBatchTransferFrom(
        address from,
        address to,
        uint[] calldata ids,
        uint[] calldata amounts,
        bytes calldata data
    ) external {
        require(
            from == msg.sender ||
            isApprovedForAll(from, msg.sender)
        );//nuyn inch verev

        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }//slujebni funkcia

//slujebni funkcia
    function _safeTransferFrom(
        address from,
        address to,
        uint id,
        uint amount,
        bytes calldata data
    ) internal {
        require(to != address(0));//burn a 

        address operator = msg.sender;
       //vorpeszi nman lini batchin miangamic stegh el masiv sarqum vor arg- masivov tanq
        uint[] memory ids = _asSingletonArray(id);
        uint[] memory amounts = _asSingletonArray(amount); //sluj, funkcianera

//minch perev ev dranic heto karogha ooeracia anenq, stegh enq talis ed masiv argery
        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        uint fromBalance = _balances[id][from]; //balanc ayd acc inchqan token ka
        require(fromBalance >= amount);//stugum enq edqan ka
        _balances[id][from] = fromBalance - amount;//hanum enq balnsic amount
        _balances[id][to] += amount; //stacoghin avelacnum enq

        emit TransferSingle(operator, from, to, id, amount); //sobitya  token inch vor qanakov

        _afterTokenTransfer(operator, from, to, ids, amounts, data);

        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);//sluj ardyoq patrast a yndunel te che
    }

    function _safeBatchTransferFrom(
        address from,
        address to,
        uint[] calldata ids,
        uint[] calldata amounts,
        bytes calldata data
    ) internal {
        require(ids.length == amounts.length);

        address operator = msg.sender;

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        for(uint i = 0; i < ids.length; ++i) {
            uint id = ids[i]; //hertakan ID vor petqa nayenq
            uint amount = amounts[i]; //inchaqan 
            uint fromBalance = _balances[id][from]; //balacy stugum

            require(fromBalance >= amount);// ardyoq edan ka vor poxancenq

            _balances[id][from] = fromBalance - amount;//tirojic pkasum a
            _balances[id][to] += amount; //stgeh avelanum
        }

        emit TransferBatch(operator, from, to, ids, amounts);

        _afterTokenTransfer(operator, from, to, ids, amounts, data);

        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);//sluj
    }
//URI a ustanovit anum, virtual vor cragravoroghy ani karogha uzum a tarber tokenner tarber uRInerum pahi
    function _setURI(string memory newUri) internal virtual {
        _uri = newUri;
    }
//mapingi mej grogh slujebni talisa te vercnu tuyla
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal {
        require(owner != operator);
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

//datarky virt vor ete petqa pereopr
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint[] memory ids,
        uint[] memory amounts,
        bytes memory data
    ) internal virtual {}

    function _afterTokenTransfer(
        address operator,
        address from,
        address to,
        uint[] memory ids,
        uint[] memory amounts,
        bytes memory data
    ) internal virtual {}

//selectorna stugum ,aysinqn yndunum a te che
    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint id,
        uint amount,
        bytes calldata data
    ) private { // es aranc assembly kam yul
        if(to.code.length > 0) {//smart contravta?
            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns(bytes4 resp) {
                if(resp != IERC1155Receiver.onERC1155Received.selector) {//ete havasar chi chem uzum
                    revert("Rejected tokens!");
                }
            } catch Error(string memory reason) {//brnum enq sxaly ete patchary gruma 
                revert(reason);
            } catch {
                revert("Non-ERC1155 receiver!"); //ete chka patchary uremn es texty
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint[] memory ids,
        uint[] memory amounts,
        bytes calldata data
    ) private {
        if(to.code.length > 0) { //stegh sa massiva
            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns(bytes4 resp) {
                if(resp != IERC1155Receiver.onERC1155BatchReceived.selector) {
                    revert("Rejected tokens!");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("Non-ERC1155 receiver!");
            }
        }
    }
//sluj  tivy cerapoxum a massivi u veradzardznumm ayn
    function _asSingletonArray(uint el) private pure returns(uint[] memory result) {
        result = new uint[](1);//memory um chenq kara sarqenq dinamik, u qani vor mi hat asarqum enq masiv vory 1 erk uni
        result[0] = el; //0indexov masivi andamiv veragrum enq mer mutqi tivy
    }
}
