package com.sec.pc.impl.pcs;

import com.sec.pc.api.Storehouse;
import com.sec.pc.impl.beans.Product;

public class ProductConsumer implements Runnable {

    private Storehouse<Product> st;


    public ProductConsumer(Storehouse<Product> st) {
        this.st = st;
    }


    @Override
    public void run() {
        st.consume();
    }
}
