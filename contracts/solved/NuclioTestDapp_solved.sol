pragma solidity 0.8.7;  
/* Versión del compilador con el que compilar el código */
contract NuclioTestDapp {
    address private owner;
    string private ultimoComentario;
    uint public maxOpenUsers;
    mapping(address => bool) private userToRegistered;
    uint256 private numRegisteredUsers;
    // Fija el tamaño máximo que puede tener una propuesta
    uint256 maxSizeProposal;

    /**
    En esta estructura vamos a ir guardando los votos a favor de cada propuesta.
     */
    mapping(string => uint) private proposalToVotes;
    /**
    En esta vamos a almacenar las propuestas para poder recorrerlas.
     */
    string[] private proposals;
    /**
    Esta variable servirá como guía para almacenar las propuestas en el array de propuestas.
     */
    uint256 private proposalsCounter;
    /**
    Esta estructura asocia cada propuesta a un booleano, para comprobar si ya existe o no.
    En Solidity los mapping a bool por defecto tienen el bool a false.
     */
    mapping(string => bool) private proposalToExists;

    constructor() { 
        owner = msg.sender;
        ultimoComentario = "Pared en blanco";
        maxOpenUsers = 3;
        userToRegistered[owner] = true;
        numRegisteredUsers = 0;
        // Por defecto el tamaño máximo es 50
        maxSizeProposal = 50;
        // Se inicializa a 0 para llevar el conteo de las propuestas
        proposalsCounter = 0;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Acceso restringido a administrador");
        _;
    }
    modifier isRegistered() {
        require(userToRegistered[msg.sender], "Usuario no registrado");
        _;
    }
    modifier isNotOwnerAndRegistered() {
        require(
            msg.sender != owner &&
            userToRegistered[msg.sender]
        , "Acceso limitado a usuarios registrados. Prohibido administrador"
        );
        _;
    }
    /**
    Modificador que comprueba si la propuesta que se está pasando ha sido registrada
     */
    modifier isProposalRegistered(string memory _proposal) {
        require(proposalToExists[_proposal], "La propuesta no ha sido registrada");
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
    /**
    Permite fijar un nuevo tamaño máximo de propuesta para las nuevas propuestas
     */
    function setMaxProposalSize(uint256 _maxSizeProposal) public isOwner{
        maxSizeProposal = _maxSizeProposal;
    }
    /**
    Obtener propuesta. Tanto su cadena como el numero de votos que tiene
     */
    function getProposal(string memory _proposal) public view isRegistered isProposalRegistered(_proposal) returns(string memory proposal, uint256 numVotes) {
        proposal = _proposal;
        numVotes = proposalToVotes[_proposal];
    }
    function getProposals() public view isRegistered returns(string[] memory) {
        return proposals;
    }
    /**
    Añadir una nueva propuesta. Para esta primera versión el identificador de la propuesta será el propio string de la propuesta.
     */
    function addProposal(string memory _proposal) public isNotOwnerAndRegistered {
        require(bytes(_proposal).length <= maxSizeProposal, "La propuesta es demasiado larga");
        require(!proposalToExists[_proposal], "La propuesta ya esta registrada");
        proposalToExists[_proposal] = true;
        proposals.push( _proposal);
        proposalsCounter++;
    }
    /**
    Votar una propuesta. Si es positivo se suma, si es negativo se resta
    */
    function voteProposal(string memory _proposal, bool _vote) public isRegistered isProposalRegistered(_proposal){
        uint256 voteCount = proposalToVotes[_proposal];
        if (_vote) {
            proposalToVotes[_proposal] = voteCount + 1;
        }
        else if (voteCount > 0) {
            proposalToVotes[_proposal] = voteCount - 1;
        }
    }
}