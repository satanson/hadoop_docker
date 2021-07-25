tab_name=orc_hive_table0
tab_name=parquet_hive_table0
tab_name=parquet_nullable_hive_table0

DROP TABLE IF EXISTS parquet_hive_table0

DROP TABLE IF EXISTS parquet_nullable_hive_table0

CREATE TABLE if not exists parquet_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS PARQUET

CREATE TABLE if not exists parquet_nullable_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS PARQUET

DROP TABLE IF EXISTS orc_hive_table0

CREATE TABLE if not exists orc_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///hive_table0_orc_files/hive_table0_0.orc'  INTO TABLE orc_hive_table0

INSERT INTO parquet_hive_table0 select * from orc_hive_table0

DROP TABLE IF EXISTS orc_hive_table0

CREATE TABLE if not exists orc_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///hive_table0_orc_files/hive_table0_1.orc'  INTO TABLE orc_hive_table0

INSERT INTO parquet_hive_table0 select * from orc_hive_table0

DROP TABLE IF EXISTS orc_hive_table0

CREATE TABLE if not exists orc_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///hive_table0_orc_files/hive_table0_4095.orc'  INTO TABLE orc_hive_table0

INSERT INTO parquet_hive_table0 select * from orc_hive_table0

DROP TABLE IF EXISTS orc_hive_table0

CREATE TABLE if not exists orc_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///hive_table0_orc_files/hive_table0_4096.orc'  INTO TABLE orc_hive_table0

INSERT INTO parquet_hive_table0 select * from orc_hive_table0

DROP TABLE IF EXISTS orc_hive_table0

CREATE TABLE if not exists orc_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///hive_table0_orc_files/hive_table0_4097.orc'  INTO TABLE orc_hive_table0

INSERT INTO parquet_hive_table0 select * from orc_hive_table0

DROP TABLE IF EXISTS orc_hive_table0

CREATE TABLE if not exists orc_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///hive_table0_orc_files/hive_table0_8191.orc'  INTO TABLE orc_hive_table0

INSERT INTO parquet_hive_table0 select * from orc_hive_table0

DROP TABLE IF EXISTS orc_hive_table0

CREATE TABLE if not exists orc_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///hive_table0_orc_files/hive_table0_8192.orc'  INTO TABLE orc_hive_table0

INSERT INTO parquet_hive_table0 select * from orc_hive_table0

DROP TABLE IF EXISTS orc_hive_table0

CREATE TABLE if not exists orc_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///hive_table0_orc_files/hive_table0_8193.orc'  INTO TABLE orc_hive_table0

INSERT INTO parquet_hive_table0 select * from orc_hive_table0

DROP TABLE IF EXISTS orc_nullable_hive_table0

CREATE TABLE if not exists orc_nullable_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///nullable_hive_table0_orc_files/nullable_hive_table0_0.orc'  INTO TABLE orc_nullable_hive_table0

INSERT INTO parquet_nullable_hive_table0 select * from orc_nullable_hive_table0

DROP TABLE IF EXISTS orc_nullable_hive_table0

CREATE TABLE if not exists orc_nullable_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///nullable_hive_table0_orc_files/nullable_hive_table0_1.orc'  INTO TABLE orc_nullable_hive_table0

INSERT INTO parquet_nullable_hive_table0 select * from orc_nullable_hive_table0

DROP TABLE IF EXISTS orc_nullable_hive_table0

CREATE TABLE if not exists orc_nullable_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///nullable_hive_table0_orc_files/nullable_hive_table0_4095.orc'  INTO TABLE orc_nullable_hive_table0

INSERT INTO parquet_nullable_hive_table0 select * from orc_nullable_hive_table0

DROP TABLE IF EXISTS orc_nullable_hive_table0

CREATE TABLE if not exists orc_nullable_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///nullable_hive_table0_orc_files/nullable_hive_table0_4096.orc'  INTO TABLE orc_nullable_hive_table0

INSERT INTO parquet_nullable_hive_table0 select * from orc_nullable_hive_table0

DROP TABLE IF EXISTS orc_nullable_hive_table0

CREATE TABLE if not exists orc_nullable_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///nullable_hive_table0_orc_files/nullable_hive_table0_4097.orc'  INTO TABLE orc_nullable_hive_table0

INSERT INTO parquet_nullable_hive_table0 select * from orc_nullable_hive_table0

DROP TABLE IF EXISTS orc_nullable_hive_table0

CREATE TABLE if not exists orc_nullable_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///nullable_hive_table0_orc_files/nullable_hive_table0_8191.orc'  INTO TABLE orc_nullable_hive_table0

INSERT INTO parquet_nullable_hive_table0 select * from orc_nullable_hive_table0

DROP TABLE IF EXISTS orc_nullable_hive_table0

CREATE TABLE if not exists orc_nullable_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///nullable_hive_table0_orc_files/nullable_hive_table0_8192.orc'  INTO TABLE orc_nullable_hive_table0

INSERT INTO parquet_nullable_hive_table0 select * from orc_nullable_hive_table0

DROP TABLE IF EXISTS orc_nullable_hive_table0

CREATE TABLE if not exists orc_nullable_hive_table0
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
col_decimalv2 DECIMAL(27, 9)
)
STORED AS ORC

LOAD DATA INPATH 'hdfs:///nullable_hive_table0_orc_files/nullable_hive_table0_8193.orc'  INTO TABLE orc_nullable_hive_table0

INSERT INTO parquet_nullable_hive_table0 select * from orc_nullable_hive_table0
