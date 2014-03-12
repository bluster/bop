package bop;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.Types;
import java.sql.DriverManager;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.logging.Logger;
import java.lang.ClassNotFoundException;

/**
 * Database interface class used to hide the database from the rest of the
 * program. 
 *
 * The intention is to restrict bop's public interface's access to the
 * database. By limiting the server's abilities to a defined set of methods used
 * to modify the database we minimize the possibility of corruption.
 *
 * Currently implemented are:
 *  - next_url: Supplies the next site to visit based on the current state of
 *  the database.
 */
public class DbInterface extends Object {
    private String dbUser;
    private String dbPassword;
    private String dbHost;
    private int dbPort;
    private String dbName;

    private static Logger logger = Logger.getLogger("bop.DbInterface");

    public DbInterface(String user, String passwd, String host,
            int port, String dbName) throws ClassNotFoundException {

        Class.forName("com.mysql.jdbc.Driver");

        this.dbUser = user;
        this.dbPassword = passwd;
        this.dbHost = host;
        this.dbPort = port;
        this.dbName = dbName;

    }

    /**
     * Get a URI for the database connection.
     */
    private URI getDbURI() throws URISyntaxException {
        return new URI("jdbc+mysql", this.dbUser + ":" + this.dbPassword,
           this.dbHost, this.dbPort, this.dbName, null, null);
    }

    /**
     * Connect to the database.
     *
     * Uses getDbURI to source the instance's database URI and attempts a
     * connection.
     */
    private Connection connect() throws SQLException,URISyntaxException {
        return DriverManager.getConnection(getDbURI().toString());
    }

    /**
     * Supplies the next site to visit based on the current state of the
     * database.
     */
    public URI nextUrl() throws SQLException,URISyntaxException {
        Connection conn = connect();
        try {
            CallableStatement call = conn.prepareCall("CALL next_url(?)");
            call.registerOutParameter("url", Types.LONGVARCHAR);
            call.execute();
            return new URI(call.getNString("url"));
        } catch (SQLException sqlexc) {
            logger.severe("Failed to get next url: " +  sqlexc.toString());
            throw sqlexc;
        } finally {
            conn.close();
        }
    }
}
