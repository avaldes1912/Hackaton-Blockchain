pragma solidity 0.4.25;

contract silat
{
    //Estructura que almacena la informacion de cada bidder
    struct Bidder
    {
        uint256 id_bidder;
        string name;
        address bidder_address;
    }

    //Estructura que almacena la informacion de la Bid actual
    struct Bid
    {
        uint256 id_bid;
        uint256 budget;
        bool registration_finished;

        uint256 id_winner;
        mapping(uint256 => Bidder) bidders;
        uint256 bidders_count;
    }

    uint256 public bid_count;//Variable que nos almacena la cantidad de bids que se han agregado al smart contract hasta ahora

    constructor() public //metodo constructor
    {
        bid_count = 0;
    }
    
    mapping(uint256 => Bid) public bids; //Declaramos el arreglo de bids
    
    function addBid(uint256 id_bid, uint256 budget) public //Funcion publica que agrega una nueva Bid
    {
        bids[id_bid].id_bid = id_bid;
        bids[id_bid].budget = budget;
        bids[id_bid].registration_finished = false;
        bids[id_bid].id_winner = 0;
        
        bid_count++;
    }

    //Funcion que le agrega un bidder a una bid en especifico
    function addBidder(uint256 id_bid, uint256 id_bidder, string name) public
    {
        bids[id_bid].bidders[id_bidder].id_bidder = id_bidder;
        bids[id_bid].bidders[id_bidder].name = name;
        bids[id_bid].bidders[id_bidder].bidder_address = msg.sender;

        bids[id_bid].bidders_count++;
    }

    /*TODO
    agregar funcion que cambie el estado del registro de la licitacion a terminado
    validacion de que si ya se termino el periodo de registro no puedan agregarse mas bidders
    validar que no se puedan agregar bidders si no existe ninguna bid actualmente
    agregar variable para identificar que la licitacion esta en curso
    validar que el numero de id no sea 0, y que sea unico, al agregar bids
    agregar variables para detalles de la licitacion
    */
    
}