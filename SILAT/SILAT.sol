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
    (DONE) validar que solo el que tenga la direccion de admin pueda agregar licitaciones
    (DONE) diferenciar variables de parametros
    (DONE) agregar variable de numero de partida, a la estructura bid
    (DONE) agregar variables de puntuacion a los bidders
    (DONE) asignar id automaticamente con contadores

    funcion para calificar a cada competidor bidder
    funcion para calcular el competidor bidder ganador
    reemplazar los requires repetidos por una sola funcion modifier
    agregar estructuras de fecha para controlar el periodo de registro e implementarlo con la estructura bid
    validar que el numero de id no sea 0, y que sea unico, al agregar bids
    */

contract silat
{
    //Estructura que almacena la informacion de cada competidor (bidder)
    struct Bidder
    {
        uint256 id_bidder;
        string name;
        address bidder_address;
        uint256 score;
    }

    enum StatusType {Open_Registration, JuryEvaluation, JuryConfirmation, Bid_Execution, Bid_End}
    //Estructura que almacena la informacion de la licitacion (bid)
    struct Bid
    {
        uint256 id_bid;
        uint256 budget;
        uint256 no_partida;
        string details;

        StatusType status;
        uint256 id_winner;
        mapping(uint256 => Bidder) bidders;
        uint256 bidders_count;
    }

    uint256 public bid_count;//Variable que nos almacena la cantidad de bids que se han agregado al smart contract hasta ahora
    address admin;

    constructor() public //metodo constructor, lo que esta aqui dentro se ejecuta al depslegar el contrato
    {
        bid_count = 0;
        admin = msg.sender;
    }
    
    mapping(uint256 => Bid) public bids; //Declaramos el arreglo de licitaciones (bids)
    
    //Funcion publica que agrega una nueva licitacion (bid)
    function addBid(uint256 _budget, string _details, uint256 _no_partida) public returns(string)
    {
        require(msg.sender == admin, "Error, solo los administradores pueden agregar licitaciones");

        bids[bid_count].id_bid = bid_count;
        bids[bid_count].budget = _budget;
        bids[bid_count].details = _details;
        bids[bid_count].no_partida = _no_partida;

        bids[bid_count].status = StatusType.Open_Registration;
        bids[bid_count].id_winner = 0;

        bid_count++;

        return("Licitacion agregada exitosamente");
    }

    //Funcion que le agrega un competidor (bidder) a una licitacion (bid) en especifico
    function addBidder(uint256 _id_bid, string _name) public returns(string)
    {
        require(bids[_id_bid].status == StatusType.Open_Registration, "La etapa de registro ya acabo, competidor no agregado");
        require(_id_bid >= 0 && _id_bid <= bid_count, "Error, id de licitacion no valido");

        bids[_id_bid].bidders[bids[_id_bid].bidders_count].id_bidder = bids[_id_bid].bidders_count;
        bids[_id_bid].bidders[bids[_id_bid].bidders_count].name = _name;
        bids[_id_bid].bidders[bids[_id_bid].bidders_count].bidder_address = msg.sender;

        bids[_id_bid].bidders_count++;

        return("Competidor agregado exitosamente");
    }

    //cuando el proceso de registro se termina, cambia la variable de estado
    function endRegistrationPeriod(uint256 _id_bid) public returns(string)
    {
        require(msg.sender == admin, "Solo el administrador puede terminar el periodo de registro");
        require(bid_count>0, "Error, aun no existen licitaciones que modificar");
        require(_id_bid >= 0 && _id_bid <= bid_count, "Error, id de licitacion no valido");
        require(bids[_id_bid].status == StatusType.Open_Registration, "Error, periodo de registro yaterminado");

        bids[_id_bid].status = StatusType.JuryEvaluation;
        return("Periodo de registro de licitacion terminado");
    }
}