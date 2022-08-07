package com.sec.pc.api;

import java.util.List;

public class Product {
    private int serialID;
    private String type;
    private String name;
    private int price;

    public Product(int serialID, String type, String name, int price) {
        this.serialID = serialID;
        this.type = type;
        this.name = name;
        this.price = price;
    }

    public int getSerialID() {
        return serialID;
    }

    public void setSerialID(int serialID) {
        this.serialID = serialID;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }
}
