package tech.cryptonomic.conseil.config

import tech.cryptonomic.conseil.tezos.TezosTypes.BlockHash

import scala.concurrent.duration.FiniteDuration

final case class ServerConfiguration(hostname: String, port: Int, cacheTTL: FiniteDuration, maxQueryResultSize: Int)

final case class LorreConfiguration(
  sleepInterval: FiniteDuration,
  bootupRetryInterval: FiniteDuration,
  bootupConnectionCheckTimeout: FiniteDuration,
  feeUpdateInterval: Int,
  numberOfFeesAveraged: Int,
  depth: Depth,
  headHash: Option[BlockHash]
)

final case class BatchFetchConfiguration(
  blockConcurrencyLevel: Int,
  accountConcurrencyLevel: Int,
  delegateConcurrencyLevel: Int,
  blockPageSize: Int,
  accountPageSize: Int
)

/** configurations related to a chain-node network calls */
final case class NetworkTimeoutConfiguration(
  GETResponseEntityTimeout: FiniteDuration,
  POSTResponseEntityTimeout: FiniteDuration
)

/** holds custom-verified lightbend configuration for the akka-http-client hostpool used to stream requests */
final case class HttpStreamingConfiguration(pool: com.typesafe.config.Config)

/** sodium library references */
final case class SodiumConfiguration(libraryPath: String) extends AnyVal with Product with Serializable

/** holds configuration for the akka-http-caching used in metadata endpoint */
final case class HttpCacheConfiguration(cacheConfig: com.typesafe.config.Config)

/** used to pattern match on natural numbers */
object Natural {
  def unapply(s: String): Option[Int] = util.Try(s.toInt).filter(_ > 0).toOption
}

final case class VerboseOutput(on: Boolean) extends AnyVal
