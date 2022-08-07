package com.sec.pc;

import com.sec.pc.api.Consumer;
import com.sec.pc.api.Producer;
import com.sec.pc.api.Product;
import com.sec.pc.api.Storehouse;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Main {

    public static void main(String[] args) {

        ExecutorService pool = Executors.newFixedThreadPool(20);
        Storehouse<Product> ps = new PhoneStorehouse(10000);

        Consumer consumer = new Consumer(ps);
        Producer<Product> producer = new Producer<>(ps);
        pool.execute(consumer);
        pool.execute(consumer);
        pool.execute(consumer);
        pool.execute(producer);
        pool.shutdown();


    }
}
