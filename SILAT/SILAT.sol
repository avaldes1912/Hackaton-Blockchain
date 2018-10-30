pragma solidity 0.4.25;

    /*TODO
    (DONE) agregar variables para detalles de la licitacion
    (DONE) agregar variable para identificar que la licitacion esta en curso
    (DONE) agregar funcion que cambie el estado del registro de la licitacion a terminado
    (DONE) agregar funcion que cambie el estado del curso de la licitacion a "ya no esta en curso"
    (DONE) validacion de que si ya se termino el periodo de registro no puedan agregarse mas bidders
    (DONE) validacion de que si ya la licitacion no esta ongoing (en curso) no puedan agregarse mas bidders
    (DONE) validar que no se puedan solicitar terminar el periodo de registro ni el periodo de en curso si el numero de licitaciones es de 0
    (DONE) endOngoingPeriod func return succes and error messages
    (DONE) endRegistrationPeriod func return success and error messages
    (DONE) addBidder func return success and error messages
    (DONE) validar que no se puedan agregar bidders si no existe ninguna bid actualmente
    (DONE) cambiar las validaciones de los if por los requires correspondientes
    (DONE) agregar variables de estado a la estructura de las licitaciones

    validar que el numero de id no sea 0, y que sea unico, al agregar bids
    agregar variable de numero de partida, a la estructura bid
    agregar estructuras de fecha para controlar el periodo de registro e implementarlo con la estructura bid
    */

contract silat
{
    //Estructura que almacena la informacion de cada competidor (bidder)
    struct Bidder
    {
        uint256 id_bidder;
        string name;
        address bidder_address;
    }

    enum StatusType {Open_Registration, JuryEvaluation, JuryConfirmation, Bid_Execution, Bid_End}
    //Estructura que almacena la informacion de la licitacion (bid)
    struct Bid
    {
        uint256 id_bid;
        uint256 budget;
        string details;

        StatusType status;
        uint256 id_winner;
        mapping(uint256 => Bidder) bidders;
        uint256 bidders_count;
    }

    uint256 public bid_count;//Variable que nos almacena la cantidad de bids que se han agregado al smart contract hasta ahora

    constructor() public //metodo constructor, lo que esta aqui dentro se ejecuta al depslegar el contrato
    {
        bid_count = 0;
    }
    
    mapping(uint256 => Bid) public bids; //Declaramos el arreglo de licitaciones (bids)
    
    function addBid(uint256 id_bid, uint256 budget, string details) public //Funcion publica que agrega una nueva licitacion (bid)
    {
        bids[id_bid].id_bid = id_bid;
        bids[id_bid].budget = budget;
        bids[id_bid].details = details;

        bids[id_bid].status = StatusType.Open_Registration;
        bids[id_bid].id_winner = 0;

        bid_count++;
    }

    //Funcion que le agrega un competidor (bidder) a una licitacion (bid) en especifico
    function addBidder(uint256 id_bid, uint256 id_bidder, string name) public returns(string)
    {
        require(bids[id_bid].status == StatusType.Open_Registration, "La etapa de registro ya acabo, competidor no agregado");
        
        bids[id_bid].bidders[id_bidder].id_bidder = id_bidder;
        bids[id_bid].bidders[id_bidder].name = name;
        bids[id_bid].bidders[id_bidder].bidder_address = msg.sender;

        bids[id_bid].bidders_count++;

        return("Competidor agregado exitosamente");
    }

    //cuando el proceso de registro se termina, cambia la variable
    function endRegistrationPeriod(uint256 id_bid) public returns(string)
    {
        require(msg.sender == admin, "Solo el administrador puede terminar el periodo de registro");
        require(bid_count>0, "Error, aun no existen licitaciones que modificar");
        require(bids[id_bid].status != StatusType.Open_Registration, "Error, periodo de registro yaterminado");

        bids[id_bid].status = StatusType.JuryEvaluation;
        return("Periodo de registro de licitacion terminado");
    }
}