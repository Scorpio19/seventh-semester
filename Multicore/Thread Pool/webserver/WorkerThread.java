/*-------------------------------------------------------------------
 * Práctica 2: Implementación de un pool de threads en Java
 * Fecha: 28-Ago-2015
 * Autores:
 *          A01370815 Diego Galindez Barreda 
 *          A01165988 Eduardo Yatziri Gaytan Martinez
 *-------------------------------------------------------------------*/

import java.net.Socket;

public class WorkerThread extends Thread {
    private Worker worker;
    public ThreadPool<WorkerThread> workers;

    public WorkerThread(ThreadPool<WorkerThread> workers) {
        this.worker = new Worker("200");
        this.workers = workers;
    }

    public void setSocket(Socket sock) {
        this.worker.setSocket(sock);
    }

    public void run() {
        while (true) {
            synchronized (this) {
                while (this.worker.sock == null) { 
                    try {
                        this.wait();
                    } catch (InterruptedException e) {
                    }
                }
            }
            this.worker.doWork();
            this.workers.push(this);
        }
    }
}
