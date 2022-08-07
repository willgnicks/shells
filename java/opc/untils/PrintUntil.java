package com.sec.pc.untils;

import javax.print.DocFlavor;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PrintUntil {

    public static void inform(String role, String threadName,Object...msg){
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("[");
        stringBuffer.append(getDate());
        stringBuffer.append("]");
        stringBuffer.append("  ");
        stringBuffer.append(role);
        stringBuffer.append("  ");
        stringBuffer.append(threadName);
        for (Object obj: msg ) {
            stringBuffer.append("  ");
            stringBuffer.append(obj.toString());
        }
        System.out.println(new String(stringBuffer));
    }

    private static String getDate(){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SS");
        return simpleDateFormat.format(new Date(System.currentTimeMillis()));
    }
}
