/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DBConnection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author HP
 */
public class DBConnection {
    private static final String urlConnect = Utils.AppConfig.DB_URL;

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
            System.out.println("SQLServerDriver: " + ex);
        }
    }

    public static Connection connect() {
        try {
            return DriverManager.getConnection(urlConnect);
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }

    public static void main(String[] args) {
        Connection conn = connect();

        if (conn != null) {
            System.out.println("Connect SQL Server SUCCESS!");
        } else {
            System.out.println("Connect SQL Server FAILED!");
        }
    }
}
