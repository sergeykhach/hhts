//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "./IERC20.sol"; //inter vor transfer u from transfer a anum

//glavniy contract , controller vory pti cni contracter
//voroc anuny klini Campaign, kompaniya po sboru sredstv na chto to
//karainq structov el anein q, bayc praktikayi hamar contractre enq sarqum

contract LowkickStarter //is IERC20
 {
    struct LowkickCampaign { // amen kompaniayi hamar
        Campaign targetContract; //konkret kontractna, senc arecinq vor karanq es dashti vra kanchenq compaign um eghac funkcianer
        bool claimed;
    }
    mapping(uint => LowkickCampaign) public campaigns; //sranc mappingna karar ev masiv el liner 
    uint private currentCampaign; //konkret compan
    address owner; //controlerri terna karogha hetp% stana
    uint constant MAX_DURATION = 30 days;

    event CampaignStarted(uint id, uint endsAt, uint goal, address organizer);

//glkhavor funkcian,  inchqan enq uzum havaqenq
    function start(uint _goal, uint _endsAt) external {
        require(_goal > 0); 
        require(
            _endsAt <= block.timestamp + MAX_DURATION &&
            _endsAt > block.timestamp
        );

        currentCampaign = currentCampaign + 1; //identifikator

        Campaign newCampaign = new Campaign(_endsAt, _goal, msg.sender, currentCampaign);//nor contract enq saqum

        campaigns[currentCampaign] = LowkickCampaign({
            targetContract: newCampaign, //sa el npastum vor karananq verevic sra funcery kanchenq
            claimed: false
        });

        emit CampaignStarted(currentCampaign, _endsAt, _goal, msg.sender);
    }

// funkcian kanchvum a taki compained koghmic vor anvtangutyu enq anum ID-n enq stugum
    function onClaimed(uint id) external {
        LowkickCampaign storage targetCampaign = campaigns[id];

        require(msg.sender == address(targetCampaign.targetContract));

        targetCampaign.claimed = true; //u asum enq stacav vse
    }
}

contract Campaign {

    uint public endsAt; //verjy
    uint public goal; //inchqana
    uint public pledged;
    uint public id;
    address public organizer; // ova kanchev papayi start funcy
    LowkickStarter parent; //addres papayi controlleri
    bool claimed;
    mapping(address => uint) pledges;//hasce poghi chap ugharkac mapping

    event Pledged(uint amount, address pledger);

    constructor(uint _endsAt, uint _goal, address _organizer, uint _id) {
        endsAt = _endsAt; //pahum enq sagh es infon
        goal = _goal;
        organizer = _organizer;
        parent = LowkickStarter(msg.sender);
        id = _id;
    }

    function pledge() external payable { //compaigne der chi avartvel, jertvovat!
        require(block.timestamp <= endsAt);
        require(msg.value > 0);//asum enq vor o-ic shata poxancvum

        pledged += msg.value; //yndhanur havaqacy mecanum a ugharkvaci chap
        pledges[msg.sender] += msg.value;//konkret uggharkoghi ugharkac chapy mecanu a edqaniiov

        //transferFrom(msg.sender, address(this), _amount); //stegh sxal ka poxancum chka
        //msg.sender.transfer(address(this), _amount); 

        emit Pledged(msg.value, msg.sender); //sobitiya
    }

//karogha mardy uzum a ira poghery kam dra masy het vercni
    function refundPledge(uint _amount) external { 
        require(block.timestamp <= endsAt); //ed kara ani ete der chi avartvel fundingy

        pledges[msg.sender] -= _amount;//vercnelu depqum vercraci chapov pakasum a ed hasceyic, ete uzena iranic 
        pledged -= _amount; //u yndhanur havaqacic

        payable(msg.sender).transfer(_amount);
    }

    function claim() external {//poghery vercnelu funkcia
        require(block.timestamp > endsAt);
        require(msg.sender == organizer); //pti organizatory kines
        require(pledged >= goal); //pti pakas chlini qan naahnshac gumary
        require(!claimed);//mtcnum enq vor mi angam vercni

        claimed = true; //sarqum enq vor karan vercni 
        payable(organizer).transfer(pledged); //poxancum enq 

        parent.onClaimed(id); //cnoghum teghekacnum enq 
    }
//pattern push
    function fullRefund() external { //ete npataky chi stacvel mardy kara dimi u ira drac sagh poghery vercni
        require(block.timestamp > endsAt);
        require(pledged < goal);

        uint refundAmount = pledges[msg.sender];
        pledges[msg.sender] = 0; //0yacnum enq 
        payable(msg.sender).transfer(refundAmount);
    }
}