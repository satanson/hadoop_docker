create table if not exists FOOBAR.EMP (
"PK" VARCHAR PRIMARY KEY
,"NAME" VARCHA
,"AGE" INTEGE
,"GENDER" VARCHA
,"BOSS" VARCHA
,"EMAIL" VARCHA
) compression='snappy',UPDATE_CACHE_FREQUENCY=30000, COLUMN_ENCODED_BYTES=0;
