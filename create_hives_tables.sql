DROP TABLE IF EXISTS orc_table_with_decimal_v3;
DROP TABLE IF EXISTS parquet_table_with_decimal_v3;
CREATE TABLE if not exists orc_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
CREATE TABLE if not exists parquet_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS PARQUET;
DROP TABLE IF EXISTS orc_table_with_decimal_v3;
CREATE TABLE if not exists orc_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/not_nullable/table_with_decimal_v3_0.orc'  INTO TABLE orc_table_with_decimal_v3;
INSERT INTO parquet_table_with_decimal_v3 select * from orc_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_table_with_decimal_v3;
CREATE TABLE if not exists orc_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/not_nullable/table_with_decimal_v3_1.orc'  INTO TABLE orc_table_with_decimal_v3;
INSERT INTO parquet_table_with_decimal_v3 select * from orc_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_table_with_decimal_v3;
CREATE TABLE if not exists orc_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/not_nullable/table_with_decimal_v3_4095.orc'  INTO TABLE orc_table_with_decimal_v3;
INSERT INTO parquet_table_with_decimal_v3 select * from orc_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_table_with_decimal_v3;
CREATE TABLE if not exists orc_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/not_nullable/table_with_decimal_v3_4096.orc'  INTO TABLE orc_table_with_decimal_v3;
INSERT INTO parquet_table_with_decimal_v3 select * from orc_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_table_with_decimal_v3;
CREATE TABLE if not exists orc_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/not_nullable/table_with_decimal_v3_4097.orc'  INTO TABLE orc_table_with_decimal_v3;
INSERT INTO parquet_table_with_decimal_v3 select * from orc_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_table_with_decimal_v3;
CREATE TABLE if not exists orc_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/not_nullable/table_with_decimal_v3_65535.orc'  INTO TABLE orc_table_with_decimal_v3;
INSERT INTO parquet_table_with_decimal_v3 select * from orc_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_table_with_decimal_v3;
CREATE TABLE if not exists orc_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/not_nullable/table_with_decimal_v3_65536.orc'  INTO TABLE orc_table_with_decimal_v3;
INSERT INTO parquet_table_with_decimal_v3 select * from orc_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_table_with_decimal_v3;
CREATE TABLE if not exists orc_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/not_nullable/table_with_decimal_v3_65537.orc'  INTO TABLE orc_table_with_decimal_v3;
INSERT INTO parquet_table_with_decimal_v3 select * from orc_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_nullable_table_with_decimal_v3;
DROP TABLE IF EXISTS parquet_nullable_table_with_decimal_v3;
CREATE TABLE if not exists orc_nullable_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
CREATE TABLE if not exists parquet_nullable_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS PARQUET;
DROP TABLE IF EXISTS orc_nullable_table_with_decimal_v3;
CREATE TABLE if not exists orc_nullable_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/nullable/nullable_table_with_decimal_v3_0.orc'  INTO TABLE orc_nullable_table_with_decimal_v3;
INSERT INTO parquet_nullable_table_with_decimal_v3 select * from orc_nullable_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_nullable_table_with_decimal_v3;
CREATE TABLE if not exists orc_nullable_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/nullable/nullable_table_with_decimal_v3_1.orc'  INTO TABLE orc_nullable_table_with_decimal_v3;
INSERT INTO parquet_nullable_table_with_decimal_v3 select * from orc_nullable_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_nullable_table_with_decimal_v3;
CREATE TABLE if not exists orc_nullable_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/nullable/nullable_table_with_decimal_v3_4095.orc'  INTO TABLE orc_nullable_table_with_decimal_v3;
INSERT INTO parquet_nullable_table_with_decimal_v3 select * from orc_nullable_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_nullable_table_with_decimal_v3;
CREATE TABLE if not exists orc_nullable_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/nullable/nullable_table_with_decimal_v3_4096.orc'  INTO TABLE orc_nullable_table_with_decimal_v3;
INSERT INTO parquet_nullable_table_with_decimal_v3 select * from orc_nullable_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_nullable_table_with_decimal_v3;
CREATE TABLE if not exists orc_nullable_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/nullable/nullable_table_with_decimal_v3_4097.orc'  INTO TABLE orc_nullable_table_with_decimal_v3;
INSERT INTO parquet_nullable_table_with_decimal_v3 select * from orc_nullable_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_nullable_table_with_decimal_v3;
CREATE TABLE if not exists orc_nullable_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/nullable/nullable_table_with_decimal_v3_65535.orc'  INTO TABLE orc_nullable_table_with_decimal_v3;
INSERT INTO parquet_nullable_table_with_decimal_v3 select * from orc_nullable_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_nullable_table_with_decimal_v3;
CREATE TABLE if not exists orc_nullable_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/nullable/nullable_table_with_decimal_v3_65536.orc'  INTO TABLE orc_nullable_table_with_decimal_v3;
INSERT INTO parquet_nullable_table_with_decimal_v3 select * from orc_nullable_table_with_decimal_v3;
DROP TABLE IF EXISTS orc_nullable_table_with_decimal_v3;
CREATE TABLE if not exists orc_nullable_table_with_decimal_v3
(
col_date DATE,
col_datetime TIMESTAMP,
col_char CHAR(20),
col_varchar VARCHAR(20),
col_boolean BOOLEAN,
col_tinyint TINYINT,
col_smallint SMALLINT,
col_int INT,
col_bigint BIGINT,
col_float FLOAT,
col_double DOUBLE,
col_decimal_p6s2 DECIMAL(6, 2),
col_decimal_p14s5 DECIMAL(14, 5),
col_decimal_p27s9 DECIMAL(27, 9),
col_decimal32_p6s2 DECIMAL(6, 2),
col_decimal64_p14s5 DECIMAL(14, 5),
col_decimal128_p27s9 DECIMAL(33, 9)
)
STORED AS ORC;
LOAD DATA INPATH 'hdfs:///decimal_v3_load_test/orc/nullable/nullable_table_with_decimal_v3_65537.orc'  INTO TABLE orc_nullable_table_with_decimal_v3;
INSERT INTO parquet_nullable_table_with_decimal_v3 select * from orc_nullable_table_with_decimal_v3;
