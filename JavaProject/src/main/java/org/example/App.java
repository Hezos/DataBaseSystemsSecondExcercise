package org.example;
import java.sql.*;

public class App 
{
    public static void main( String[] args )
    {
        try{
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Connect to the database
            String url = "jdbc:oracle:thin:@193.6.5.58:1521:XE";
            Connection conn = DriverManager.getConnection(url, "H23_FVIQLY", "FVIQLY_A9");

            // Connection successful, print message
            System.out.println("Connected to database!");

            // Clean up resources
            conn.close();
            System.out.println( "Connection established" );
        }catch (Exception exception){
            exception.printStackTrace();
        }
    }
}
