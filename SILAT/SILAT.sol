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

    validar que el numero de id no sea 0, y que sea unico, al agregar bids
    agregar variables de rubro y de numero de partida, a la estructura bid
    agregar estructuras de fecha para controlar el periodo de registro e implementarlo con la estructura bid
    agregar variables de estado para las licitaciones
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

    //Estructura que almacena la informacion de la licitacion (bid)
    struct Bid
    {
        uint256 id_bid;
        uint256 budget;
        string details;

        bool registration_finished;
        bool ongoing;

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

        bids[id_bid].registration_finished = false;
        bids[id_bid].ongoing = true;
        
        bids[id_bid].id_winner = 0;

        bid_count++;
    }

    //Funcion que le agrega un competidor (bidder) a una licitacion (bid) en especifico
    function addBidder(uint256 id_bid, uint256 id_bidder, string name) public returns(string)
    {
        if(bids[id_bid].registration_finished == false && bids[id_bid].ongoing == true )
        {
            bids[id_bid].bidders[id_bidder].id_bidder = id_bidder;
            bids[id_bid].bidders[id_bidder].name = name;
            bids[id_bid].bidders[id_bidder].bidder_address = msg.sender;

            bids[id_bid].bidders_count++;

            return("Competidor agregado exitosamente");
        }
        else
        {
            return("Error, Competidor no agregado");
        }
    }

    //cuando el proceso de registro se termina, cambia la variable
    function endRegistrationPeriod(uint256 id_bid) public returns(string)
    {
        if(bid_count>0)
        {
            bids[id_bid].registration_finished = true;
            return("Periodo de registro de licitacion terminado");
        }
        else
        {
            return("Error, No existen licitaciones aun");
        }
    }

    //cambia la variable ongoing cuando la licitacion ya no este en curso, osea cuando se termine
    function endOngoingPeriod(uint256 id_bid) public returns(string)
    {
        if(bid_count>0 || bids[id_bid].registration_finished == true)
        {
            bids[id_bid].ongoing = false;
            return("Periodo de curso de licitacion terminado");
        }
        else
        {
            if(bid_count==0)
            {
                return("Error, No existen licitaciones aun");
            }
            else
            {
                if(bids[id_bid].registration_finished == true)
                {
                    return("Error, El periodo de registro de esta licitacion aun sigue en curso");
                }
            }
        }
    }
}