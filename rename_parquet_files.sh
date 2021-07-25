#!/bin/bash
set -e -o pipefail
mv 000000_0 data_0.parquet
mv 000000_0_copy_1 data_1.parquet 
mv 000000_0_copy_2 data_4095.parquet
mv 000000_0_copy_3 data_4096.parquet
mv 000000_0_copy_4 data_4097.parquet
mv 000000_0_copy_5 data_8191.parquet
mv 000000_0_copy_6 data_8192.parquet
mv 000000_0_copy_7 data_8193.parquet
