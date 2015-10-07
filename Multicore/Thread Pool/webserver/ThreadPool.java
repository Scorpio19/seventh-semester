/*-------------------------------------------------------------------
 * Práctica 2: Implementación de un pool de threads en Java
 * Fecha: 28-Ago-2015
 * Autores:
 *          A01370815 Diego Galindez Barreda 
 *          A01165988 Eduardo Yatziri Gaytan Martinez
 *-------------------------------------------------------------------*/

import java.util.LinkedList;

public class ThreadPool<T> {

    private LinkedList<T> pool;

    public ThreadPool() {
        this.pool = new LinkedList<T>();
    }

    public synchronized void push(T item) {
        this.pool.add(item);
    }

    public synchronized T checkAndPop() {
        if (!this.pool.isEmpty()) {
            return this.pool.removeFirst();
        }
        return null;
    }

    public synchronized int length() {
        return this.pool.size();
    }
}
