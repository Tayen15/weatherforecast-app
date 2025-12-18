package com.weatherforecast.config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Database configuration and connection manager for PostgreSQL
 */
public class DatabaseConfig {
     private static String HOST;
     private static String PORT;
     private static String DB_NAME;
     private static String USERNAME;
     private static String PASSWORD;
     private static String URL;

     static {
          loadDatabaseProperties();
     }

     /**
      * Load database configuration from config.properties
      */
     private static void loadDatabaseProperties() {
          Properties props = new Properties();
          try (InputStream input = DatabaseConfig.class.getClassLoader()
                    .getResourceAsStream("config.properties")) {
               if (input == null) {
                    System.err.println("Unable to find config.properties");
                    setDefaults();
                    return;
               }
               props.load(input);

               // Load individual properties
               HOST = props.getProperty("db.host", "localhost");
               PORT = props.getProperty("db.port", "5432");
               DB_NAME = props.getProperty("db.name", "weatherdb");
               USERNAME = props.getProperty("db.username", "postgres");
               PASSWORD = props.getProperty("db.password", "postgres");

               // Build URL from components
               URL = String.format("jdbc:postgresql://%s:%s/%s", HOST, PORT, DB_NAME);

               System.out.println("[CONFIG] Database configuration loaded:");
               System.out.println("[CONFIG] Host: " + HOST);
               System.out.println("[CONFIG] Port: " + PORT);
               System.out.println("[CONFIG] Database: " + DB_NAME);
               System.out.println("[CONFIG] Username: " + USERNAME);
               System.out.println("[CONFIG] URL: " + URL);

          } catch (IOException e) {
               System.err.println("[ERROR] Failed to load database configuration: " + e.getMessage());
               e.printStackTrace();
               setDefaults();
          }
     }

     /**
      * Set default database configuration
      */
     private static void setDefaults() {
          HOST = "localhost";
          PORT = "5432";
          DB_NAME = "weatherdb";
          USERNAME = "postgres";
          PASSWORD = "postgres";
          URL = String.format("jdbc:postgresql://%s:%s/%s", HOST, PORT, DB_NAME);

          System.out.println("[CONFIG] Using default database configuration:");
          System.out.println("[CONFIG] Host: " + HOST);
          System.out.println("[CONFIG] Port: " + PORT);
          System.out.println("[CONFIG] Database: " + DB_NAME);
          System.out.println("[CONFIG] Username: " + USERNAME);
          System.out.println("[CONFIG] URL: " + URL);
     }

     /**
      * Get database connection
      * 
      * @return Connection object
      * @throws SQLException if connection fails
      */
     public static Connection getConnection() throws SQLException {
          try {
               Class.forName("org.postgresql.Driver");
          } catch (ClassNotFoundException e) {
               throw new SQLException("PostgreSQL JDBC Driver not found", e);
          }

          System.out.println("[DEBUG] Attempting to connect to: " + URL);

          try {
               Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
               System.out.println("[DEBUG] Database connection established successfully");
               return conn;
          } catch (SQLException e) {
               System.err.println("[ERROR] Failed to connect to database: " + e.getMessage());
               System.err.println("[ERROR] URL: " + URL);
               System.err.println("[ERROR] Username: " + USERNAME);
               throw e;
          }
     }

     /**
      * Close database connection safely
      * 
      * @param connection Connection to close
      */
     public static void closeConnection(Connection connection) {
          if (connection != null) {
               try {
                    connection.close();
                    System.out.println("[DEBUG] Database connection closed");
               } catch (SQLException e) {
                    System.err.println("[ERROR] Error closing connection: " + e.getMessage());
                    e.printStackTrace();
               }
          }
     }

     /**
      * Get configuration details
      */
     public static void printConfiguration() {
          System.out.println("\n====== Database Configuration ======");
          System.out.println("Host: " + HOST);
          System.out.println("Port: " + PORT);
          System.out.println("Database: " + DB_NAME);
          System.out.println("Username: " + USERNAME);
          System.out.println("URL: " + URL);
          System.out.println("====================================\n");
     }

     /**
      * Verify database connection and schema
      * 
      * @return true if everything is OK
      */
     public static boolean verifyDatabase() {
          System.out.println("\n[VERIFICATION] Starting database verification...");

          try (Connection conn = getConnection()) {
               System.out.println("[VERIFICATION] Connection successful");

               // Check if weather_history table exists
               System.out.println("[VERIFICATION] Checking if weather_history table exists...");
               String query = "SELECT 1 FROM information_schema.tables WHERE table_name = 'weather_history'";
               try (java.sql.Statement stmt = conn.createStatement();
                         java.sql.ResultSet rs = stmt.executeQuery(query)) {

                    if (rs.next()) {
                         System.out.println("[VERIFICATION] SUCCESS: weather_history table exists");

                         // Check table structure
                         System.out.println("[VERIFICATION] Checking table columns...");
                         String columnsQuery = "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'weather_history'";
                         try (java.sql.Statement colStmt = conn.createStatement();
                                   java.sql.ResultSet colRs = colStmt.executeQuery(columnsQuery)) {

                              int columnCount = 0;
                              while (colRs.next()) {
                                   columnCount++;
                                   System.out.println("[VERIFICATION]   - " + colRs.getString(1) + " ("
                                             + colRs.getString(2) + ")");
                              }
                              System.out.println("[VERIFICATION] Total columns: " + columnCount);

                              if (columnCount >= 10) {
                                   System.out.println("[VERIFICATION] SUCCESS: Table structure appears correct");
                              } else {
                                   System.err.println("[WARNING] Table might be incomplete (expected ~11 columns)");
                              }
                         }

                         // Check row count
                         System.out.println("[VERIFICATION] Checking row count...");
                         String countQuery = "SELECT COUNT(*) FROM weather_history";
                         try (java.sql.Statement countStmt = conn.createStatement();
                                   java.sql.ResultSet countRs = countStmt.executeQuery(countQuery)) {

                              if (countRs.next()) {
                                   int rowCount = countRs.getInt(1);
                                   System.out.println("[VERIFICATION] Total rows in weather_history: " + rowCount);
                              }
                         }

                         System.out.println("[VERIFICATION] SUCCESS: All checks passed!");
                         return true;
                    } else {
                         System.err.println("[ERROR] weather_history table does not exist");
                         System.err.println("[ERROR] Please run migration script: migrate-db.bat or migrate-db.sh");
                         return false;
                    }
               }

          } catch (SQLException e) {
               System.err.println("[ERROR] Database verification failed: " + e.getMessage());
               e.printStackTrace();
               return false;
          }
     }
}
