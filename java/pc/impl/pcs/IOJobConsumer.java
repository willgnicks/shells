package com.sec.pc.impl.pcs;

import com.sec.pc.impl.houses.IOJobStorehouse;

public class IOJobConsumer implements Runnable{

    private com.sec.pc.impl.houses.IOJobStorehouse ioJobStorehouse;

    public IOJobConsumer(IOJobStorehouse ioJobStorehouse){
        this.ioJobStorehouse = ioJobStorehouse;
    }
    @Override
    public void run() {
        ioJobStorehouse.consume();
    }
}
