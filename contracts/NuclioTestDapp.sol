pragma solidity 0.8.7;  
/* Versión del compilador con el que compilar el código */
contract NuclioTestDapp {
    owner;
    ultimoComentario;
    maxOpenUsers;
    userToRegistered;
    numRegisteredUsers;

    proposalToVotes;
    proposals;
    proposalToExists;

    constructor() { 
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
    
    function setUltimoComentario(string memory _ultimoComentario) public isRegistered returns (bool success) {
        ultimoComentario = _ultimoComentario;
        return true;
    }
    function getUltimoComentario() public view returns (string memory) {
        return ultimoComentario;
    }
    function IsRegisteredUser(address _user) public view returns (bool registered){
        registered = userToRegistered[_user];
    }
    function registerOpenUser() public {
        require(numRegisteredUsers <= maxOpenUsers, "Alcanzado el numero maximo de usuarios. Por favor, contacte con el administrador");
        require(!userToRegistered[msg.sender], "Usuario ya registrado");
        userToRegistered[msg.sender] = true;
        numRegisteredUsers += 1;
    }
    function setMaxOpenUsers(uint _maxOpenUsers) public isOwner {
        maxOpenUsers = _maxOpenUsers;
    }
}