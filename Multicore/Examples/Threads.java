
class Turn {
    private int who = 0;

    public synchronized void toggle() {
        who = 1 - who;
    }

    public int getWho() {
        return who;
    }
}

public class Threads implements Runnable {

    private int threadId;
    private Turn turn;

    public Threads(int threadId, Turn turn) {
        this.threadId = threadId;
        this.turn = turn;
    }

    public void run() {
        for (int i=0; i<10; i++) {
            synchronized (turn) {
                while (threadId != turn.getWho()) {
                    try {
                        turn.wait();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                System.out.println("Hello from thread: " + threadId);
                turn.toggle();
                turn.notifyAll();
            }
        }
    }

    public static void main(String args[]) throws Exception {
        Turn turn = new Turn();
        Thread t1 = new Thread(new Threads(0, turn));
        Thread t2 = new Thread(new Threads(1, turn));

        t1.start();
        t2.start();

        t1.join();
        t2.join();

        System.out.println("End");
    }
}
