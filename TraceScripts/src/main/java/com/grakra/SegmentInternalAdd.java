package com.grakra;

import com.sun.btrace.BTraceUtils;
import com.sun.btrace.annotations.BTrace;
import com.sun.btrace.annotations.OnMethod;
import com.sun.btrace.annotations.ProbeMethodName;

@BTrace
public class SegmentInternalAdd {
 @OnMethod(
        clazz="org.apache.hadoop.hbase.regionserver.Segment",
        method="internalAdd"
    )
    public static void segmentInternalAdd(@ProbeMethodName String methodName) {
        // println is defined in BTraceUtils
        // you can only call the static methods of BTraceUtils
        BTraceUtils.println("invoke:" + methodName);
        BTraceUtils.jstack();
    }
}
