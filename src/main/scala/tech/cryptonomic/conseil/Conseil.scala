package tech.cryptonomic.conseil

import java.io.InputStream
import java.security.{KeyStore, SecureRandom}
import javax.net.ssl.{KeyManagerFactory, SSLContext, TrustManagerFactory}

import akka.actor.ActorSystem
import akka.http.scaladsl.{ConnectionContext, Http, HttpsConnectionContext}
import akka.http.scaladsl.server.Directives._
import akka.stream.ActorMaterializer
import com.typesafe.config.ConfigFactory
import com.typesafe.scalalogging.LazyLogging
import tech.cryptonomic.conseil.directives.EnableCORSDirectives
import tech.cryptonomic.conseil.routes.Tezos
import tech.cryptonomic.conseil.util.SecurityUtil
import akka.http.scaladsl.model.StatusCodes._
import com.typesafe.sslconfig.akka.AkkaSSLConfig

import scala.concurrent.ExecutionContextExecutor

object Conseil extends App with LazyLogging with EnableCORSDirectives {

  val validateApiKey = headerValueByName("apikey").tflatMap[Tuple1[String]]{
    case Tuple1(apiKey) =>
      if (SecurityUtil.validateApiKey(apiKey)) {
        provide(apiKey)
      } else {
        complete((Unauthorized, "Incorrect API key"))
      }
  }

  val conf = ConfigFactory.load
  val conseil_hostname = conf.getString("conseil.hostname")
  val conseil_port = conf.getInt("conseil.port")

  implicit val system: ActorSystem = ActorSystem("conseil-system")
  implicit val materializer: ActorMaterializer = ActorMaterializer()
  implicit val executionContext: ExecutionContextExecutor = system.dispatcher
  val sslConfig = AkkaSSLConfig()

  val route = enableCORS {
    validateApiKey { _ =>
      pathPrefix("tezos") {
        Tezos.route
      }
    }
  }

  // Begin HTTPS setup
  // Drawn from https://doc.akka.io/docs/akka-http/10.0.11/scala/http/server-side/server-https-support.html#ssl-config

  val password: Array[Char] = conf.getString("security.ssl.keystore-password").toCharArray
  val ks: KeyStore = KeyStore.getInstance("PKCS12")
  val keystore: InputStream = getClass.getClassLoader.getResourceAsStream("conseil.p12")

  require(keystore != null, "Keystore required!")
  ks.load(keystore, password)

  val keyManagerFactory: KeyManagerFactory = KeyManagerFactory.getInstance("SunX509")
  keyManagerFactory.init(ks, password)

  val tmf: TrustManagerFactory = TrustManagerFactory.getInstance("SunX509")
  tmf.init(ks)

  val sslContext: SSLContext = SSLContext.getInstance("TLS")
  sslContext.init(keyManagerFactory.getKeyManagers, tmf.getTrustManagers, new SecureRandom)
  val https: HttpsConnectionContext = ConnectionContext.https(sslContext)

  // End HTTPS setup

  Http().setDefaultServerHttpContext(https)
  val bindingFuture = Http().bindAndHandle(route, conseil_hostname, conseil_port)
  logger.info(s"Bonjour..")
  while(true){}
  bindingFuture
    .flatMap(_.unbind())
    .onComplete(_ => system.terminate())

}