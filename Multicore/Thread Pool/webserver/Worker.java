/**
 * @author Ariel Ortiz
 */

/*-------------------------------------------------------------------
 * Práctica 2: Implementación de un pool de threads en Java
 * Fecha: 28-Ago-2015
 * Modificado por:
 *          A01370815 Diego Galindez Barreda 
 *          A01165988 Eduardo Yatziri Gaytan Martinez
 *-------------------------------------------------------------------*/

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.net.Socket;

/**
 * Processes a client connection. Reads the request information from a socket 
 * and produces a simple response.
 */
public class Worker {

    public static final String EOL = "\r\n";

    public Socket sock;
    private String statusCode;

    public Worker(String statusCode) {
        this.statusCode = statusCode;
        this.sock = null;
    }

    public void setSocket(Socket sock) {
        this.sock = sock;
    }

    public void doWork() {
        String content, statusCodeMessage;

        switch (this.statusCode) {
            case ("200"):
                try {
                    Thread.sleep(2000);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                content = "Hello World!\n";
                statusCodeMessage = "OK";
                break;
            case("503"):
                content = "Service Unavailable\n";
                statusCodeMessage = "Service Unavailable";
                break;
            default:
                content = "Unknown\n";
                statusCodeMessage = "Unknown status code";
                break;
        }

        try (
                InputStream input = this.sock.getInputStream();
                PrintStream output = new PrintStream(this.sock.getOutputStream())
            ) {

            System.out.println("-------------------------------------");            
            System.out.println(readInputBytes(input));

            output.print("HTTP/1.0 " + this.statusCode + " " + statusCodeMessage + EOL);
            output.print("Content-type: text/plain" + EOL);
            output.print("Content-length: " + content.length() + EOL);
            output.print(EOL);
            output.print(content);

        } catch (IOException e) {
            e.printStackTrace();

        } finally {
            try {
                this.sock.close();
                this.sock = null;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    // A utility function (just an ugly hack)
    private static String readInputBytes(InputStream input) {

        try {
            while (true) {
                int n = input.available();
                if (n == 0) {
                    Thread.sleep(50);
                    continue;
                }
                byte[] bytes = new byte[n];
                input.read(bytes);
                return new String(bytes);
            }

        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
            return null;
        }
    }
}
