--@test: explode - explode array with values
CREATE STREAM TEST (ID STRING KEY, MY_ARR ARRAY<BIGINT>) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT ID, EXPLODE(MY_ARR) VAL FROM TEST;
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('0', ARRAY[1, 2]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('1', ARRAY[3, 4]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('2', ARRAY[5]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('3', ARRAY[]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('4', ARRAY[6]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('5', NULL);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('6', ARRAY[7]);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('0', 1);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('0', 2);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('1', 3);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('1', 4);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('2', 5);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('4', 6);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('6', 7);

--@test: explode - udfs with table functions and no aliases, verifies intermediate generated column names don't clash with aliases
CREATE STREAM TEST (ID STRING KEY, MY_ARR ARRAY<BIGINT>, F1 BIGINT, F2 BIGINT) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT ID, ABS(F1), EXPLODE(MY_ARR), ABS(F2) FROM TEST;
INSERT INTO `TEST` (ID, F1, F2, MY_ARR) VALUES ('0', 1, 2, ARRAY[1, 2]);
ASSERT VALUES `OUTPUT` (ID, KSQL_COL_0, KSQL_COL_1, KSQL_COL_2) VALUES ('0', 1, 1, 2);
ASSERT VALUES `OUTPUT` (ID, KSQL_COL_0, KSQL_COL_1, KSQL_COL_2) VALUES ('0', 1, 2, 2);

--@test: explode - explode shouldn't accept map
--@expected.error: io.confluent.ksql.util.KsqlStatementException
--@expected.message: Function 'explode' does not accept parameters (MAP<STRING, INTEGER>).
CREATE STREAM TEST (ID STRING KEY, MY_MAP MAP<STRING, INT>) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT EXPLODE(MY_MAP) FROM TEST;
--@test: explode - shouldn't be able to have table functions with aggregation
--@expected.error: io.confluent.ksql.util.KsqlStatementException
--@expected.message: Table functions cannot be used with aggregations.
CREATE STREAM TEST (K STRING KEY, VAL INT, MY_MAP MAP<STRING, INT>) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE TABLE OUTPUT AS SELECT K, VAL, EXPLODE(MY_MAP), COUNT(*) FROM TEST GROUP BY VAL;
--@test: explode - explode different types
CREATE STREAM TEST (K STRING KEY, F0 ARRAY<INT>, F1 ARRAY<BIGINT>, F2 ARRAY<DOUBLE>, F3 ARRAY<BOOLEAN>, F4 ARRAY<STRING>, F5 ARRAY<DECIMAL(20, 10)>) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT K, EXPLODE(F0), EXPLODE(F1), EXPLODE(F2), EXPLODE(F3), EXPLODE(F4), EXPLODE(F5) FROM TEST;
INSERT INTO `TEST` (K, F0, F1, F2, F3, F4, F5) VALUES ('0', ARRAY[1, 2], ARRAY[2, 3], ARRAY[3.1, 4.1], ARRAY[true, false], ARRAY['foo', 'bar'], ARRAY[123.456, 456.123]);
ASSERT VALUES `OUTPUT` (K, KSQL_COL_0, KSQL_COL_1, KSQL_COL_2, KSQL_COL_3, KSQL_COL_4, KSQL_COL_5) VALUES ('0', 1, 2, 3.1, true, 'foo', 123.4560000000);
ASSERT VALUES `OUTPUT` (K, KSQL_COL_0, KSQL_COL_1, KSQL_COL_2, KSQL_COL_3, KSQL_COL_4, KSQL_COL_5) VALUES ('0', 2, 3, 4.1, false, 'bar', 456.1230000000);

--@test: explode - explode array of struct
CREATE STREAM TEST (ID STRING KEY, MY_ARR ARRAY<STRUCT<F1 BIGINT>>) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT ID, EXPLODE(MY_ARR) VAL FROM TEST;
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('0', ARRAY[STRUCT(F1:=1), STRUCT(F1:=2)]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('1', ARRAY[STRUCT(F1:=3)]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('2', ARRAY[]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('3', NULL);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('0', STRUCT(F1:=1));
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('0', STRUCT(F1:=2));
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('1', STRUCT(F1:=3));

--@test: explode - explode array of struct with dereference
CREATE STREAM TEST (ID STRING KEY, MY_ARR ARRAY<STRUCT<F1 BIGINT>>) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT ID, EXPLODE(MY_ARR)->F1 AS VAL FROM TEST;
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('0', ARRAY[STRUCT(F1:=1), STRUCT(F1:=2)]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('1', ARRAY[STRUCT(F1:=3)]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('2', ARRAY[]);
INSERT INTO `TEST` (ID, MY_ARR) VALUES ('3', NULL);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('0', 1);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('0', 2);
ASSERT VALUES `OUTPUT` (ID, VAL) VALUES ('1', 3);
