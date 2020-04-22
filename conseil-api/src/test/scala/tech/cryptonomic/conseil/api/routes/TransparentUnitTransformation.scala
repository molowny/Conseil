package tech.cryptonomic.conseil.api.routes

import tech.cryptonomic.conseil.common.config.MetadataConfiguration
import tech.cryptonomic.conseil.common.generic.chain.PlatformDiscoveryTypes
import tech.cryptonomic.conseil.common.metadata.{EntityPath, NetworkPath, PlatformPath, UnitTransformation}

//TODO This class is a duplicate from conseil-common,
// which will be updated once entire project will be split properly

/* UnitTransformation implementation for test purposes. It overrides nothing. */
object TransparentUnitTransformation extends UnitTransformation(MetadataConfiguration(Map.empty)) {
  override def overridePlatforms(
      platforms: List[PlatformDiscoveryTypes.Platform]
  ): List[PlatformDiscoveryTypes.Platform] = platforms

  override def overrideNetworks(
      platformPath: PlatformPath,
      networks: List[PlatformDiscoveryTypes.Network]
  ): List[PlatformDiscoveryTypes.Network] = networks

  override def overrideEntities(
      networkPath: NetworkPath,
      entities: List[PlatformDiscoveryTypes.Entity],
      shouldLog: Boolean
  ): List[PlatformDiscoveryTypes.Entity] = entities

  override def overrideAttributes(
      path: EntityPath,
      attributes: List[PlatformDiscoveryTypes.Attribute],
      shouldLog: Boolean
  ): List[PlatformDiscoveryTypes.Attribute] = attributes
}
