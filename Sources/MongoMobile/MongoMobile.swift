import libmongodbcapi
import MongoSwift

/// Settings for constructing a `MongoClient`
public struct MongoClientSettings {
  /// the database path to use
  let dbPath: String
}

public class MongoMobile {
  private static let databases: [String: OpaquePointer]

  /**
   * Perform required operations to initialize the embedded server.
   */
  public static func initialize() {
    // no-op for now
  }

  /**
   * Perform required operations to cleanup the embedded server.
   */
  public static func close() {
    for (dbPath, database) in databases {
      libmongodbcapi_db_destroy(database)
    }
  }

  /**
   * Create a new `MongoClient` for the database indicated by `dbPath` in
   * the passed in settings.
   *
   * - Parameters:
   *   - settings: required settings for client creation
   *
   * - Returns: a new `MongoClient`
   */
  public static func create(settings: MongoClientSettings) -> MongoClient {
    var database: OpaquePointer
    if let _database = databases[settings.dbPath] {
      database = _database
    } else {
      database = libmongodbcapi_db_new(/* int argc, const char** argv, const char** envp */)

      if database == nil {
        // throw an error!
      }

      databases[settings.dbPath] = database
    }

    guard let client_t = embedded_mongoc_client_new(database) else {
      // throw an error!
    }

    return MongoClient(fromPointer: client_t)
  }
}