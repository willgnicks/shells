package com.sec.pc.utils;

import com.sec.pc.impl.houses.IOJobStorehouse;
import com.sec.pc.impl.beans.Product;

import java.util.List;

public class DataHandler {

//    private static volatile PhoneStorehouse.Handler handler;
//
//    private Handler() {
//
//    }
//
//    public static PhoneStorehouse.Handler getInstance() {
//        if (handler == null) {
//            synchronized (PhoneStorehouse.Handler.class) {
//                if (handler == null) {
//                    handler = new PhoneStorehouse.Handler();
//                }
//            }
//        }
//        return handler;
//    }

    private com.sec.pc.impl.houses.IOJobStorehouse IOJobStorehouse;

    public DataHandler(){}

    public DataHandler(IOJobStorehouse pst){
        this.IOJobStorehouse = pst;
    }

    // 省略中间数据加工过程，直接到最后数据处理情况
    public void handleData(List<Product> list) {
        IOJobStorehouse.produce(list, true);
    }


}
