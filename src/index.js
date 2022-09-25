
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