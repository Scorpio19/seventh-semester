/**
 * @author Ariel Ortiz
 * 
 * A very simple web server.
 * Implements a minuscule subset of RFC 1945 (HTTP/1.0)
 * http://www.ietf.org/rfc/rfc1945.txt 
 */

/*-------------------------------------------------------------------
 * Práctica 2: Implementación de un pool de threads en Java
 * Fecha: 28-Ago-2015
 * Modificado por:
 *          A01370815 Diego Galindez Barreda 
 *          A01165988 Eduardo Yatziri Gaytan Martinez
 *-------------------------------------------------------------------*/

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * Starts the web server and listens to client connections. Individual 
 * connections are processed by Worker instances.
 */
public class WebServer {

    public static final int PORT_NUMBER = 12345;
    public static final int MAX_POOL_SIZE = 4;
    public ThreadPool<WorkerThread> workers;

    public WebServer() {
        this.workers = new ThreadPool<WorkerThread>();
    }

    private void listen() {
        System.out.printf("Minuscule web server ready. Listening at port %d...%n", 
                PORT_NUMBER);

        try (ServerSocket servSock = new ServerSocket(PORT_NUMBER)) {

            for (int i = 0; i < MAX_POOL_SIZE; i++) {
                WorkerThread wt = new WorkerThread(this.workers);
                wt.start();
                this.workers.push(wt);
            }

            while (true) {
                Socket sock = servSock.accept();

                WorkerThread wt = this.workers.checkAndPop();

                if (wt != null) {
                    synchronized(wt) {
                        wt.setSocket(sock);
                        wt.notifyAll();
                    }
                } else {
                    Worker w = new Worker("503");
                    w.setSocket(sock);
                    w.doWork();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        new WebServer().listen();
    }
}
