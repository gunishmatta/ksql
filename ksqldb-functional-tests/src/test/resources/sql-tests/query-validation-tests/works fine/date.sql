--@test: date - DELIMITED in/out
CREATE STREAM TEST (ID STRING KEY, date DATE) WITH (kafka_topic='test', value_format='DELIMITED');
CREATE STREAM TEST2 AS SELECT * FROM TEST;
INSERT INTO `TEST` (DATE) VALUES ('1970-01-11');
INSERT INTO `TEST` (DATE) VALUES ('1969-12-22');
ASSERT VALUES `TEST2` (DATE) VALUES ('1970-01-11');
ASSERT VALUES `TEST2` (DATE) VALUES ('1969-12-22');

--@test: date - AVRO in/out
CREATE STREAM TEST (ID STRING KEY, date DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT * FROM TEST;
INSERT INTO `TEST` (DATE) VALUES ('1970-01-11');
INSERT INTO `TEST` (DATE) VALUES ('1969-12-22');
ASSERT VALUES `TEST2` (DATE) VALUES ('1970-01-11');
ASSERT VALUES `TEST2` (DATE) VALUES ('1969-12-22');

--@test: date - JSON in/out
CREATE STREAM TEST (ID STRING KEY, date DATE) WITH (kafka_topic='test', value_format='JSON');
CREATE STREAM TEST2 AS SELECT * FROM TEST;
INSERT INTO `TEST` (date) VALUES ('1970-01-11');
INSERT INTO `TEST` (date) VALUES ('1969-12-22');
ASSERT VALUES `TEST2` (DATE) VALUES ('1970-01-11');
ASSERT VALUES `TEST2` (DATE) VALUES ('1969-12-22');

--@test: date - PROTOBUF in/out
CREATE STREAM TEST (ID STRING KEY, date DATE) WITH (kafka_topic='test', value_format='PROTOBUF');
CREATE STREAM TEST2 AS SELECT * FROM TEST;
INSERT INTO `TEST` (date) VALUES ('1970-01-11');
INSERT INTO `TEST` (date) VALUES ('1969-12-22');
ASSERT VALUES `TEST2` (DATE) VALUES ('1970-01-11');
ASSERT VALUES `TEST2` (DATE) VALUES ('1969-12-22');

--@test: date - PROTOBUF_NOSR in/out
CREATE STREAM TEST (ID STRING KEY, date DATE) WITH (kafka_topic='test', value_format='PROTOBUF_NOSR');
CREATE STREAM TEST2 AS SELECT * FROM TEST;
INSERT INTO `TEST` (date) VALUES ('1970-01-11');
INSERT INTO `TEST` (date) VALUES ('1969-12-22');
ASSERT VALUES `TEST2` (DATE) VALUES ('1970-01-11');
ASSERT VALUES `TEST2` (DATE) VALUES ('1969-12-22');

--@test: date - casting - date to string
CREATE STREAM TEST (ID STRING KEY, date DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, CAST(date AS STRING) AS RESULT FROM TEST;
INSERT INTO `TEST` (date) VALUES ('1970-01-11');
INSERT INTO `TEST` (date) VALUES ('1969-12-31');
INSERT INTO `TEST` (date) VALUES (NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES ('1970-01-11');
ASSERT VALUES `TEST2` (RESULT) VALUES ('1969-12-31');
ASSERT VALUES `TEST2` (RESULT) VALUES (NULL);

--@test: date - casting - string to date
CREATE STREAM TEST (ID STRING KEY, DATE STRING) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, CAST(DATE AS DATE) AS RESULT FROM TEST;
INSERT INTO `TEST` (DATE) VALUES ('foo');
INSERT INTO `TEST` (DATE) VALUES ('1970-01-10');
INSERT INTO `TEST` (DATE) VALUES ('1970-01');
INSERT INTO `TEST` (DATE) VALUES ('1969-12-31');
INSERT INTO `TEST` (DATE) VALUES (NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES ('1970-01-10');
ASSERT VALUES `TEST2` (RESULT) VALUES ('1970-01-01');
ASSERT VALUES `TEST2` (RESULT) VALUES ('1969-12-31');
ASSERT VALUES `TEST2` (RESULT) VALUES (NULL);

--@test: date - casting - timestamp to date
CREATE STREAM TEST (ID STRING KEY, TS TIMESTAMP) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, CAST(TS AS DATE) AS RESULT FROM TEST;
INSERT INTO `TEST` (TS) VALUES ('1970-01-01T00:00:05.000');
INSERT INTO `TEST` (TS) VALUES ('1969-12-31T23:59:58.000');
INSERT INTO `TEST` (TS) VALUES ('1970-01-02T00:00:00.100');
INSERT INTO `TEST` (TS) VALUES (NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES ('1970-01-01');
ASSERT VALUES `TEST2` (RESULT) VALUES ('1969-12-31');
ASSERT VALUES `TEST2` (RESULT) VALUES ('1970-01-02');
ASSERT VALUES `TEST2` (RESULT) VALUES (NULL);

--@test: date - date in complex types
CREATE STREAM TEST (ID STRING KEY, S STRUCT<DATE DATE>, A ARRAY<DATE>, M MAP<STRING, DATE>) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, S -> DATE AS S, A[1] AS A, M['DATE'] AS M FROM TEST;
INSERT INTO `TEST` (S, A, M) VALUES (STRUCT(DATE:='1970-01-02'), ARRAY['1970-01-06', '1970-01-11'], MAP('DATE':='1970-01-05'));
ASSERT VALUES `TEST2` (S, A, M) VALUES ('1970-01-02', '1970-01-06', '1970-01-05');

--@test: date - equal - date date
CREATE STREAM TEST (ID STRING KEY, a DATE, b DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a = b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-04-11');
INSERT INTO `TEST` (A, B) VALUES (NULL, '1970-04-11');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: date - not equal - date date
CREATE STREAM TEST (ID STRING KEY, a DATE, b DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a <> b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-13');
INSERT INTO `TEST` (A, B) VALUES (NULL, '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: date - is distinct - DATE DATE
CREATE STREAM TEST (ID STRING KEY, a DATE, b DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a IS DISTINCT FROM b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-13');
INSERT INTO `TEST` (A, B) VALUES (NULL, '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: date - less than - DATE DATE
CREATE STREAM TEST (ID STRING KEY, a DATE, b DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a < b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-13');
INSERT INTO `TEST` (A, B) VALUES (NULL, '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: date - LEQ - DATE DATE
CREATE STREAM TEST (ID STRING KEY, a DATE, b DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a <= b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-04');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-13');
INSERT INTO `TEST` (A, B) VALUES (NULL, '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: date - GEQ - DATE DATE
CREATE STREAM TEST (ID STRING KEY, a DATE, b DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a >= b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-04');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-13');
INSERT INTO `TEST` (A, B) VALUES (NULL, '1970-01-11');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: date - greater than - DATE TIMESTAMP
CREATE STREAM TEST (ID STRING KEY, a DATE, b TIMESTAMP) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a > b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-01T00:00:00.300');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-11T00:00:00.000');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-11T00:00:00.005');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', '1970-01-10T23:59:59.999');
INSERT INTO `TEST` (A, B) VALUES (NULL, '1970-01-01T00:00:00.010');
INSERT INTO `TEST` (A, B) VALUES ('1970-01-11', NULL);
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: date - greater than - DATE STRING
CREATE STREAM TEST (ID STRING KEY, a DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a > '1970-01-11') AS RESULT FROM TEST;
INSERT INTO `TEST` (A) VALUES ('1970-01-11');
INSERT INTO `TEST` (A) VALUES ('1970-01-12');
INSERT INTO `TEST` (A) VALUES ('1970-01-10');
INSERT INTO `TEST` (A) VALUES (NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: date - filter
CREATE STREAM TEST (ID STRING KEY, a DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT * FROM TEST WHERE a='1970-01-11';
INSERT INTO `TEST` (A) VALUES ('1970-01-11');
INSERT INTO `TEST` (A) VALUES ('1970-01-12');
INSERT INTO `TEST` (A) VALUES (NULL);
ASSERT VALUES `TEST2` (A) VALUES ('1970-01-11');

--@test: date - between
CREATE STREAM TEST (ID STRING KEY, a DATE) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT * FROM TEST WHERE a BETWEEN '1970-01-04' AND '1970-01-10';
INSERT INTO `TEST` (A) VALUES ('1970-01-02');
INSERT INTO `TEST` (A) VALUES ('1970-01-07');
INSERT INTO `TEST` (A) VALUES ('1970-01-13');
INSERT INTO `TEST` (A) VALUES (NULL);
ASSERT VALUES `TEST2` (A) VALUES ('1970-01-07');
