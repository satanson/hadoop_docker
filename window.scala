import java.sql.Timestamp
val rd = sc.textFile("/data/timestamp.dat").map(Timestamp.valueOf(_))
rd.take(10)
val df = rd.toDF("ts")
df.printSchema
df.show
import org.apache.spark.sql
import org.apache.spark.sql.expressions.Window
df.withColumn("value", lit(1L))
df.withColumn("value", lit(1L)).show
df.withColumn("value", lit(1L)).printSchema
df.withColumn("value", lit(1L)).withColumn("ts1", unix_timestamp('ts))
df.withColumn("value", lit(1L)).withColumn("ts1", unix_timestamp('ts)).show
val df2 = df.withColumn("value", lit(1L)).withColumn("ts1", unix_timestamp('ts)).show
val df2 = df.withColumn("value", lit(1L)).withColumn("ts1", unix_timestamp('ts))
df2.show
val lastMinuteWindow = Window.orderBy('ts1).rangeBetween(Window.currentRow, 60)
df2.withColumn("count", sum('value) over lastMinuteWindow).show
df2.withColumn("count", sum('value) over lastMinuteWindow).show(100)
df.show
df2.show
df.groupBy('ts).agg(count('ts))
df.groupBy('ts).agg(count('ts)).show
df.groupBy('ts).agg(count('ts))
df.groupBy('ts).agg(count('ts))
df.groupBy('ts).agg(count('ts))
df.groupBy('ts).agg(count('ts))
df.groupBy('ts).agg(count('ts) as "count").
show
df.groupBy('ts).agg(count('ts) as "count").count
df.withColumn("ts_30s", from_unixtime(unix_timestamp('ts) - second('ts)%30)).show
df.withColumn("ts_30s", from_unixtime(unix_timestamp('ts) - second('ts)%30)).show(100)
df.withColumn("ts_30s", from_unixtime(unix_timestamp('ts) - second('ts)%30)).show(1000)
df.withColumn("ts_30s", from_unixtime(unix_timestamp('ts) - second('ts)%30)).select('ts_30s as "ts")
df.withColumn("ts_30s", from_unixtime(unix_timestamp('ts) - second('ts)%30)).select('ts_30s as "ts").show
df.withColumn("ts_30s", from_unixtime(unix_timestamp('ts) - second('ts)%30)).select('ts_30s as "ts").count
df.withColumn("ts_30s", from_unixtime(unix_timestamp('ts) - second('ts)%30)).select('ts_30s as "ts").groupBy('ts).agg(count('ts) as "count").show
df.withColumn("ts_30s", from_unixtime(unix_timestamp('ts) - second('ts)%30)).select('ts_30s as "ts").groupBy('ts).agg(count('ts) as "count").count
val df2 = df.withColumn("ts_30s", from_unixtime(unix_timestamp('ts) - second('ts)%30)).select('ts_30s as "ts").groupBy('ts).agg(count('ts) as "count").count
val df2 = df.withColumn("ts_30s", from_unixtime(unix_timestamp('ts) - second('ts)%30)).select('ts_30s as "ts").groupBy('ts).agg(count('ts) as "count")
df2.filter(last_day(current_timestamp) < 'ts)
df2.filter(last_day(current_timestamp) < 'ts).show
df2.filter(last_day(current_timestamp()) < 'ts).show
df2.show
df2.withColumn("last_day", last_day(current_timestamp()))
df2.withColumn("last_day", last_day(current_timestamp())).show
df2.filter(datediff(current_timestamp(),'ts) < 86400).show
df2.filter(datediff(current_timestamp(),'ts) < 864).show
df2.withColumn("diff", datediff(current_timestamp(),'ts)).show
df2.filter(date_sub(current_timestamp(),1) < 'ts ).show
df2.filter(date_sub(current_timestamp(),1) < 'ts ).count
df2.filter(date_sub(current_timestamp(),1) < 'ts ).show(1000)
df2.filter(date_sub(current_timestamp(),1) < 'ts )
val  lastMinutes = Window.orderBy('ts).rangeBetween(Window.currentRow, _:Long)
val  lastMinutes = (n:Long) => Window.orderBy('ts).rangeBetween(Window.currentRow, 60*n)
val df3 = df2.filter(date_sub(current_timestamp(),1) < 'ts )
val last1Minutes = lastMinutes(1)
df3.printSchema
lastMinutes
df3.show
val df4 = df3.withColumn("ts0", unix_timestamp('ts))
df4.show
import org.apache.spark.sql.Column
val  lastMinutes = (col:Column, n:Long) => Window.orderBy(col).rangeBetween(Window.currentRow, 60*n)
df4.select(sum('count).over(lastMinutes('ts0,1)))
df4.select(sum('count).over(lastMinutes('ts0,1))).show
df4.select('ts, 'count, sum('count).over(lastMinutes('ts0,1)) as "aggr").show
df4.select('ts, 'count, sum('count).over(lastMinutes('ts0,60)) as "aggr").show
df4.select('ts, 'count, sum('count).over(lastMinutes('ts0, 1440)) as "aggr").show
df4.select('ts, 'count, sum('count).over(lastMinutes('ts0, 100)) as "aggr").show
df4.select('ts, 'count, sum('count).over(lastMinutes('ts0, 60)) as "aggr").show
df4.select('ts, 'count, sum('count).over(lastMinutes('ts0, 60)) as "aggr").show(100)
df4.select('ts, 'count, sum('count).over(lastMinutes('ts0, 60)) as "aggr").show(100)
df4.select('ts, 'count, lag('ts,1).over(Window.orderBy('ts)) as "prev", lead('ts, 1).over(Window.orderBy('ts)) as "next")
df4.select('ts, 'count, lag('ts,1).over(Window.orderBy('ts)) as "prev", lead('ts, 1).over(Window.orderBy('ts)) as "next").show
df4.select('ts, 'count, ntile(10).over(Window.orderBy('ts0)) as "aggr").show(100)
df4.select('ts, 'count, ntile(10).over(Window.orderBy('ts0)) as "aggr").show(1000)
df4.select('ts, 'count, ntile(1000).over(Window.orderBy('ts0)) as "aggr").show(1000)
val df5 = sc.parallelize(1 to 10 by 1).toDF("num")
val df5 = sc.parallelize(1 to 10 by 1).toDF("num").select(ntile(100).over(Window.orderBy('num))).show
val df5 = sc.parallelize(1 to 10 by 1).toDF("num").select(cume_dist().over(Window.orderBy('num))).show
val df5 = sc.parallelize(1 to 100 by 1).toDF("num").select(cume_dist().over(Window.orderBy('num))).show
val df5 = sc.parallelize(1 to 1000 by 1).toDF("num").select(cume_dist().over(Window.orderBy('num))).show
val df5 = sc.parallelize(1 to 1000 by 1).toDF("num").select(cume_dist().over(Window.orderBy('num))).show(1000)
val df5 = sc.parallelize(1 to 1000 by 1).toDF("num").select(row_number.over(Window.orderBy('num).rowsBetween(Window.unboundedPreceding, Window.currentRow)))
val df5 = sc.parallelize(1 to 1000 by 1).toDF("num").select(row_number.over(Window.orderBy('num).rowsBetween(Window.unboundedPreceding, Window.currentRow))).show
val df5 = sc.parallelize(1 to 1000 by 1).toDF("num").select(row_number.over(Window.orderBy('num).rowsBetween(Window.unboundedPreceding, Window.currentRow))).show
val df5 = sc.parallelize(1 to 1000 by 1).toDF("num").select(row_number.over(Window.orderBy('num).rowsBetween(Window.unboundedPreceding, Window.currentRow)) as "rowIdx").show
val df5 = sc.parallelize(1 to 1000 by 1).toDF("num").select(row_number.over(Window.orderBy('num).rowsBetween(Window.unboundedPreceding, Window.currentRow)) as "rowIdx").toString
val df5 = sc.parallelize(1 to 1000 by 1).toDF("num").select(row_number.over(Window.orderBy('num).rowsBetween(Window.unboundedPreceding, Window.currentRow)) as "rowIdx")
