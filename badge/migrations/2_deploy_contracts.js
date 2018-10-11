var GenesisBadge = artifacts.require("./GenesisBadge.sol");
var BadgeMetadataConverter = artifacts.require("./BadgeMetadataConverter.sol");

module.exports = function(deployer) {
  deployer.deploy(GenesisBadge);
  deployer.deploy(BadgeMetadataConverter);
};
