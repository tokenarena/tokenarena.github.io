var Controller = artifacts.require("Controller")
var TokenArena = artifacts.require("TokenArena")

module.exports = function(deployer) {
  deployer.deploy(Controller).then(controllerInstance => {
    console.log('CONTROLLER: ' + controllerInstance.address)
      deployer.deploy(
        TokenArena,
        controllerInstance.address,
        'TestArena'
      ).then(tokenArenaInstance => {
        console.log('TOKEN ARENA (test): ' + tokenArenaInstance.address)
      })
  }).catch(err => {
    console.log('ERROR', error)
  })
};
