package tech.cryptonomic.conseil.metadata

import tech.cryptonomic.conseil.config.MetadataOverridesConfiguration
import tech.cryptonomic.conseil.generic.chain.PlatformDiscoveryTypes.{Attribute, Entity, Network, Platform}
import tech.cryptonomic.conseil.util.OptionUtil.when

class UnitTransformation(overrides: MetadataOverridesConfiguration) {

  def overridePlatform(platform: Platform, path: PlatformPath): Option[Platform] = when(overrides.isVisible(path)) {
    val overridePlatform = overrides.platform(path)

    platform.copy(
      displayName = overridePlatform
        .flatMap(_.displayName)
        .getOrElse(platform.displayName),
      description = overridePlatform
        .flatMap(_.description))
  }

  def overrideNetwork(network: Network, path: NetworkPath): Option[Network] = when(overrides.isVisible(path)) {
    val overrideNetwork = overrides.network(path)

    network.copy(
      displayName = overrideNetwork
        .flatMap(_.displayName)
        .getOrElse(network.displayName),
      description = overrideNetwork
        .flatMap(_.description))
  }

  def overrideEntity(entity: Entity, path: EntityPath): Option[Entity] = when(overrides.isVisible(path)) {
    val overrideEntity = overrides.entity(path)

    entity.copy(
      displayName = overrideEntity
        .flatMap(_.displayName)
        .getOrElse(entity.displayName),
      description = overrideEntity
        .flatMap(_.description))
  }

  def overrideAttribute(attribute: Attribute, path: AttributePath): Option[Attribute] = when(overrides.isVisible(path)) {
    val overrideAttribute = overrides.attribute(path)

    attribute.copy(
      displayName = overrideAttribute
        .flatMap(_.displayName)
        .getOrElse(attribute.displayName),
      description = overrideAttribute
        .flatMap(_.description),
      placeholder = overrideAttribute
        .flatMap(_.placeholder),
      dataformat = overrideAttribute
        .flatMap(_.dataformat))
  }
}
