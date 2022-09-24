/* Versión del compilador con el que compilar el código */
pragma solidity 0.8.7;  
contract NuclioTestDapp {
    /*
    Variables del contrato
     */
    private owner;
    private ultimoComentario;
    public maxOpenUsers;
    private userToRegistered;
    private numRegisteredUsers;
    maxSizeProposal;

    constructor() { 
        //Rellenar
    }

    modifier isOwner() {
        _;
    }
    modifier isRegistered() {
        _;
    }
    modifier isNotOwnerAndRegistered() {
        _;
    }
    
    function setUltimoComentario() public returns () {
    }
    function getUltimoComentario() public view returns () {
    }
    function IsRegisteredUser() public view returns (){
    }
    function registerOpenUser() public {
    }
    function setMaxOpenUsers() public isOwner {
    }
}