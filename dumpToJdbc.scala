import java.util.Properties;
val posts = spark.sql("select * from posts")
val props = new Properties()
props.setProperty("user", "root")
props.setProperty("password", "123456")

posts.write.mode("overwrite").jdbc("jdbc:mysql://mysqld1/mydb?createDatabaseIfNotExist=true&userUnicode=true&characterEncoding=UTF-8", "posts", props)
