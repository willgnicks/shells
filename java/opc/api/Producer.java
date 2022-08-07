package com.sec.pc.api;

import com.sec.pc.Phone;
import com.sec.pc.PhoneStorehouse;
import com.sec.pc.untils.PrintUntil;

import java.util.ArrayList;
import java.util.List;

public class Producer<Product> implements Runnable {

    private Storehouse<Product> st;

    private List<Product> data;

    public Producer(Storehouse<Product> st, List<Product> data) {
        this.st = st;
        this.data = data;
    }

    public Producer(Storehouse<Product> ps) {
        this.st = ps;
    }

    @Override
    public void run() {
        // insert data
        PrintUntil.inform("生产者", Thread.currentThread().getName(), "hashcode",Thread.currentThread().hashCode());
        List<Product> objects = new ArrayList<>();
        Product iphone = (Product) new Phone(1, "iphone 13", "iphone", 22);
        for (int i = 0; i < 100000; i++) {
            objects.add((Product) iphone);
            if ( objects.size() > 0 && objects.size() % 1000 ==0){
                st.produce(objects, true);
                objects.clear();
            }
        }
        st.produce(objects, false);

    }
}
