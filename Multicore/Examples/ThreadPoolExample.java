package mx.itesm.cem.sam;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

class Thing implements Runnable {
	@Override
	public void run() {
		System.out.println("Algo");
	}
}

public class ThreadPoolExample {
	public static void main(String[] args) {
		//métodos para crear thread pools
		//ExecutorService pool = Executors.newFixedThreadPool(2);
		//ExecutorService pool = Executors.newCachedThreadPool();
		ExecutorService pool = Executors.newSingleThreadExecutor();
		for(int i = 0; i < 10; i++) {
			pool.execute(new Thing());
		}
		pool.shutdown();
	}
}