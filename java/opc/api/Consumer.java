package com.sec.pc.api;

public class Consumer implements Runnable {

    private Storehouse<Product> st;


    public Consumer(Storehouse<Product> st) {
        this.st = st;
    }


    @Override
    public void run() {
        st.consume();
    }
}
