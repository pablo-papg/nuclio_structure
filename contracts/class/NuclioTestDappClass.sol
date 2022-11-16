pragma solidity 0.8.7;  
/* Versión del compilador con el que compilar el código */

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

/*
Contrato creado en clase, añadiendo unos ajustes rapidos a la forma en la que se añaden los votos
para tener en cuenta el número de tokens que posee cada usuario
*/
contract NuclioTestDapp {
    address private owner;
    string private ultimoComentario;
    uint public maxOpenUsers;
    mapping(address => User) addressToUser;
    uint256 private userCounter;

    uint256 maxSizeProposal;
    string[] private proposals;
    mapping(string => bool) proposalToExists;
    uint256 private numProposal;

    mapping(uint256 => Proposal) idToProposal;

    struct Proposal {
        uint256 id;
        string message;
        uint256 numVotes;
        bool exists;
    }

    struct User {
        uint256 id;
        address direccion;
        bool registered;
        bool banned;
        uint256 tokens;
    }


    constructor() { 
        owner = msg.sender;
        maxOpenUsers = 3;
        maxSizeProposal = 50;
        numProposal = 0;
        userCounter = 0;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Acceso restringido a administrador");
        _;
    }
    modifier isRegistered() {
        require(
            msg.sender == owner ||
            addressToUser[msg.sender].registered, "Usuario no registrado");
        _;
    }
    modifier isNotOwnerAndRegistered() {
        require(
            msg.sender != owner &&
            addressToUser[msg.sender].registered
            , "Acceso limitado a usuarios restringidos. Prohibido administrador"
        );
        _;
    }
    modifier isProposalRegistered(uint256 id) {
        require(idToProposal[id].exists, "La propuesta no ha sido registrada");
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
        registered = addressToUser[_user].registered;
    }
    function registerOpenUser() public {
        require(userCounter < maxOpenUsers, "Alcanzado el numero maximo de usuarios. Por favor, contacte con el administrador");
        require(!addressToUser[msg.sender].registered, "Usuario ya registrado");
        User storage user = addressToUser[msg.sender];
        user.registered = true;
        user.direccion = msg.sender;
        user.id = userCounter++;
        // TODO obtener del ERC20 asociado a la dApp
        //IERC20(token.address).transfer(msg.sender, 50);
        user.tokens = 50;
    }
    function setMaxOpenUsers(uint _maxOpenUsers) public isOwner {
        maxOpenUsers = _maxOpenUsers;
    }
    function addProposal(string memory _message) public isNotOwnerAndRegistered{
        require(bytes(_message).length <= maxSizeProposal, "La propuesta supera el limite");
        require(!proposalToExists[_message], "La propuesta ya esta registrada");
        proposalToExists[_message] = true;
        proposals.push(_message);

        idToProposal[numProposal] = Proposal(numProposal, _message, 0, true);
        numProposal++;
    }
    function getProposals() public view returns(string[] memory _proposals){
        _proposals = proposals;
    }
    function isRegisteredProposal(uint256 _id) public view returns(bool _isRegistered) {
        _isRegistered = idToProposal[_id].exists;
    }
    function voteProposal(uint256 _id, bool _vote) public isRegistered isProposalRegistered(_id){
        Proposal storage proposal = idToProposal[_id];
        if (_vote) {
            // El número de votos es proporcional a la cantidad de tokens que posea el usuario.
            proposal.numVotes = proposal.numVotes + 1 * (1 + addressToUser[msg.sender].tokens/100);
            // Como estamos utilizando el compilador 0.8.7 no es necesario utilizar la libreria SafeMath
            // porque solidity la incluye por defecto desde 0.8.
            
        }
        // El número de votos vamos a hacer no pueda ser negativo
        else if (proposal.numVotes > 0) {
            uint256 totalVotes = 1 * (1 + addressToUser[msg.sender].tokens/100);
            if (totalVotes > proposal.numVotes) {
                // Si el total de votos negativos que va a hacer el usuario es mayor que el numero de votos de la propuesta
                // lo asignamos como 0
                proposal.numVotes = 0;
            }
            else {
                proposal.numVotes = proposal.numVotes - totalVotes;
            }

        }
    }
}