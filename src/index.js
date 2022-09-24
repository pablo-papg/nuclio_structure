
// ¿Qué librería necesitamos para conectarnos a la blockchain?
import {  } from '';
/**
* Obtenemos el abi importándolo del fichero abi.json
*/
import abi_raw from './abi.json';
const domain = window.location.host;
const origin = window.location.origin;
/**
 * Cómo conectarse a la blockchain
 */
const provider;
const signer;
/**
 * Cómo interactuar con el contrato desplegado
 */
let contract_address;
let contract;


/**
 * FUNCIONALIDAD DE LA PÁGINA
 */

/**
 * Conectar nuestro wallet con la webapp
 */
// Botón
const connectWalletBtn;
// Función
function connectWallet(){
}

/**
 * Registrar nuestro usuario
 */
// Botón
const registerUserBtn;
// Función
async function registerUser() {
}

/**
 * Comprobar estado del registro de un usuario
 */
// Botón
const isRegisteredBtn;
// Función
async function isRegistered() {
}

/**
 * Obtener el último comentario grabado en el contrato
 */
// Botón
const getCommentBtn;
// Función
async function getComment() {
}


/**
 * Sobreescribir el último comentario grabado en el contrato
 */
// Botón
const setCommentBtn;
// Función
async function setComment() {
}



/**
 * FASE 2: AMPLIACIÓN A REGISTRAR PROPUESTAS
 */

// Funciones de botones
async function registerProposal() {
	const proposal = document.getElementById('register_proposal').value;
	try {
		await contract.addProposal(proposal);
	} catch (error) {
		console.log(error.message);
	}
}

async function voteProposal() {
	const aFavor = document.getElementById('vote_proposal_checkbox').checked;
	const proposal = document.getElementById('vote_proposal').value;
	try {
		await contract.voteProposal(proposal, aFavor);
	} catch (error) {
		console.log(error.message)
	}
}

async function getVotesProposal() {
	const proposal = document.getElementById('get_proposal_votes').value;
	try {
		const proposal_votes = document.getElementById('proposal_votes');
		const votes = (await contract.getProposal(proposal))[1];
		votes ? proposal_votes.value = votes.toString() : proposal_votes.value = 0;
	} catch (error) {
		proposal_votes.value = '';
		console.log(error.message);
	}
}


// Botones
// Registrar propuesta
const registerProposalBtn = document.getElementById('registerProposalBtn');
registerProposalBtn.onclick = registerProposal;
// Votar propuesta
const voteProposalBtn = document.getElementById('voteProposalBtn');
voteProposalBtn.onclick = voteProposal;
// Conteo de votos de la propuesta
const getVotesProposalBtn = document.getElementById('getVotesProposalBtn');
getVotesProposalBtn.onclick = getVotesProposal;

/**
 * MEJORA: SELECTOR DE PROPUESTAS
 */

function cleanSelector() {
	// Recuperar selector
	const selector = document.getElementById('selectProposal');
	// Eliminamos el primer elemento del selector tantas veces como elementos tenga
	for (let i = 0; i <= selector.length; i++) {
		selector.remove(0);
	}
}

// Funciones
async function updateProposalList() {
	const selector = document.getElementById('selectProposal');
	try {
		// Obtener propuestas
		const listProposals = await contract.getProposals();
		// Limpiar el selector
		cleanSelector(selector);
		// Recorrer el listado de propuestas y añadirlas al selector
		for (let i = 0; i < listProposals.length; i++) {
			let prop = listProposals[i];
			let option = document.createElement("option");
			option.textContent = prop;
			option.value = prop;
			selector.appendChild(option);
		}
	}catch (error) {
		console.log(error.message);
	}
}

async function voteProposalFromList() {
	const selector = document.getElementById('selectProposal');
	const proposal = selector.options[selector.selectedIndex].value;
	const aFavor = document.getElementById('vote_proposal_checkbox2').checked;
	try {
		await contract.voteProposal(proposal, aFavor);
	} catch (error) {
		console.log(error.message)
	}
}

// Botones
// Actualizar lista de propuestas
const updateProposalsBtn = document.getElementById("updateProposalsBtn");
updateProposalsBtn.onclick = updateProposalList;
// Votar propuesta 2
const voteProposalFromListBtn = document.getElementById('voteProposalFromListBtn');
voteProposalFromListBtn.onclick = voteProposalFromList;