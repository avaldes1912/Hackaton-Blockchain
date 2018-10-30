pragma solidity 0.4.25;

//Sistema de Licitaciones Abiertas y Transparentes v0.1.0

//ADVERTENCIA/WARNING este archivo es una interpretacion muy basica de lo minimo que debe tener el programa
//tiene combinado nombres en castellano y en ingles porque yolo, quedan advertidos

contract silat
{
    //Estructura que almacena la informacion de cada bidder
    struct Bidder
    {
        uint256 id_bidder;
        string bidder_name;
        address direccion_bidder;
    }

    //Estructura que almacena la informacion de la licitacion actual
    struct Licitacion
    {
        uint256 id_licitacion;
        uint256 presupuesto;
        bool registro_terminado;

        uint256 bidder_ganador;
        Bidder[] bidders;
        uint256 bidderCount;
    }

    uint256 public licitacion_count;//Variable que nos almacena la cantidad de licitaciones que se han agregado al smart contract hasta ahora

    constructor() public
    {
        licitacion_count = 0;
    }
    
    mapping(uint256 => Licitacion) public licitaciones; //Declaramos el arreglo de licitaciones
    
    function addLicitacion(uint256 id_licitacion, uint256 presupuesto) public //Funcion publica que agrega una nueva licitacion, no retorna nada
    {
        licitaciones[id_licitacion].id_licitacion = id_licitacion;
        licitaciones[id_licitacion].presupuesto = presupuesto;
        licitaciones[id_licitacion].registro_terminado = false;
        //licitaciones[id_licitacion].bidder_ganador = 0; //solidity inicializa todo en 0 por defecto asi que nose si ponerle esto, pero sin esto funciona 
        //licitaciones[id_licitacion].bidders = 0
        
        licitacion_count++;
    }
    //De aqui para arriba todo ha sido probado en REMIX y corre relativamente bien
    //De aqui para abajo nada ha sido probado, cuidado

    //Funcion que le agrega un bidder a una licitacion en especifico
    function addBidder(uint256 id_licitacion, uint256 id_bidder, string bidder_name) public
    {
        licitaciones[id_licitacion].bidders[id_bidder].id_bidder = id_bidder;
        licitaciones[id_licitacion].bidders[id_bidder].bidder_name = bidder_name;
        licitaciones[id_licitacion].bidders[id_bidder].direccion_bidder = msg.sender;

        licitaciones[id_licitacion].bidderCount++;
    }
}