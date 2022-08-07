package com.sec.pc;

import com.sec.pc.api.Product;
import com.sec.pc.api.Storehouse;
import com.sec.pc.untils.PrintUntil;

import java.util.ArrayList;
import java.util.List;

public class PhoneStorehouse implements Storehouse<Product> {
    private final Object signal = new Object();

    private boolean flag = true;

    private List<Product> data = new ArrayList<>();

    private final String producer = "生产者";

    private final String consumer = "消费者";

    private int capacity = 0;

    public PhoneStorehouse() {
        capacity = DEFAULT_CAPACITY;
    }

    public PhoneStorehouse(int capacity) {
        this.capacity = capacity;
    }

    @Override
    public void produce(List<Product> data, boolean flag) {
        synchronized (signal) {
            try {
                while (this.data.size() >= capacity) {
//                    Thread.sleep(20);
                    signal.notifyAll();
                    PrintUntil.inform(producer, Thread.currentThread().getName(), "produce waits due to capacity full usage","current size", this.data.size());
                    signal.wait();
                }
//                assert( this.data.size() < capacity) : "produce thread is process with wrong condition";
//                PrintUntil.inform(producer, Thread.currentThread().getName(), "start produce and inside lock", "before data size", this.data.size());
                this.data.addAll(data);
                PrintUntil.inform(producer, Thread.currentThread().getName(), "end produce and inside lock", "after data size", this.data.size());
                signal.notifyAll();
                this.flag = flag;
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }


    @Override
    public void consume() {
        List<Product> tmp = new ArrayList<>();
        while (flag) {
            synchronized (signal) {
//                PrintUntil.inform(consumer, Thread.currentThread().getName(), "get lock and inside lock");
                try {
                    while (this.data.isEmpty() && flag) {
                        signal.notifyAll();
//                        PrintUntil.inform(consumer, Thread.currentThread().getName(), "consume waits due to store house is empty now");
                        signal.wait();
                    }
//                    assert( !this.data.isEmpty() || !flag) : "consume thread is waken incorrectly";
//                    this.data.addAll(data);
                    tmp.addAll(this.data);
                    this.data.clear();
                    signal.notifyAll();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
//            PrintUntil.inform(consumer, Thread.currentThread().getName(), "tmp hashcode",tmp.hashCode());
            Handler.handleData(tmp);
            tmp.clear();
        }
//        PrintUntil.inform(consumer, Thread.currentThread().getName(), "end produce and outside lock", "this data size", this.data.size());
    }
    private static class Handler{

        public static void handleData(List<Product> list){
            PrintUntil.inform("处理器",Thread.currentThread().getName(),"获取列表大小 ",list.size());
            for (Product product : list) {
                try {
                    Thread.sleep(1);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

            }


        }

    }
}

