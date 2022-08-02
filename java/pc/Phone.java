package com.sec.pc;

import com.sec.pc.api.Product;

public class Phone extends Product {
    public Phone(int serialID, String type, String name, int price) {
        super(serialID, type, name, price);
    }

    @Override
    public String toString() {
        return "Phone{}";
    }
}
