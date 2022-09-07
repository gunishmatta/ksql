--@test: time - DELIMITED in/out
CREATE STREAM TEST (ID STRING KEY, time TIME) WITH (kafka_topic='test', value_format='DELIMITED');
CREATE STREAM TEST2 AS SELECT * FROM TEST;
INSERT INTO `TEST` (TIME) VALUES ('00:01');
ASSERT VALUES `TEST2` (TIME) VALUES ('00:01');

--@test: time - AVRO in/out
CREATE STREAM TEST (ID STRING KEY, time TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT * FROM TEST;
INSERT INTO `TEST` (TIME) VALUES ('00:01');
ASSERT VALUES `TEST2` (TIME) VALUES ('00:01');

--@test: time - JSON in/out
CREATE STREAM TEST (ID STRING KEY, time TIME) WITH (kafka_topic='test', value_format='JSON');
CREATE STREAM TEST2 AS SELECT * FROM TEST;
INSERT INTO `TEST` (time) VALUES ('00:01');
ASSERT VALUES `TEST2` (TIME) VALUES ('00:01');

--@test: time - PROTOBUF in/out
CREATE STREAM TEST (ID STRING KEY, time TIME) WITH (kafka_topic='test', value_format='PROTOBUF');
CREATE STREAM TEST2 AS SELECT * FROM TEST;
INSERT INTO `TEST` (time) VALUES ('00:01');
ASSERT VALUES `TEST2` (TIME) VALUES ('00:01');

--@test: time - casting - time to string
CREATE STREAM TEST (ID STRING KEY, TIME TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, CAST(TIME AS STRING) AS RESULT FROM TEST;
INSERT INTO `TEST` (TIME) VALUES ('00:00:05');
INSERT INTO `TEST` (TIME) VALUES (NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES ('00:00:05');
ASSERT VALUES `TEST2` (RESULT) VALUES (NULL);

--@test: time - casting - string to time
CREATE STREAM TEST (ID STRING KEY, TIME STRING) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, CAST(TIME AS TIME) AS RESULT FROM TEST;
INSERT INTO `TEST` (TIME) VALUES ('foo');
INSERT INTO `TEST` (TIME) VALUES ('00:00:00.010');
INSERT INTO `TEST` (TIME) VALUES ('00:00:01');
INSERT INTO `TEST` (TIME) VALUES ('00:01');
INSERT INTO `TEST` (TIME) VALUES (NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES ('00:00:00.010');
ASSERT VALUES `TEST2` (RESULT) VALUES ('00:00:01');
ASSERT VALUES `TEST2` (RESULT) VALUES ('00:01');
ASSERT VALUES `TEST2` (RESULT) VALUES (NULL);

--@test: time - casting - timestamp to time
CREATE STREAM TEST (ID STRING KEY, TIME TIMESTAMP) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, CAST(TIME AS TIME) AS RESULT FROM TEST;
INSERT INTO `TEST` (TIME) VALUES ('1970-01-01T00:00:05.000');
INSERT INTO `TEST` (TIME) VALUES ('1969-12-31T23:59:58.000');
INSERT INTO `TEST` (TIME) VALUES ('1970-01-02T00:00:00.100');
INSERT INTO `TEST` (TIME) VALUES (NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES ('00:00:05');
ASSERT VALUES `TEST2` (RESULT) VALUES ('23:59:58');
ASSERT VALUES `TEST2` (RESULT) VALUES ('00:00:00.100');
ASSERT VALUES `TEST2` (RESULT) VALUES (NULL);

--@test: time - time in complex types
CREATE STREAM TEST (ID STRING KEY, S STRUCT<TIME TIME>, A ARRAY<TIME>, M MAP<STRING, TIME>) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, S -> TIME AS S, A[1] AS A, M['TIME'] AS M FROM TEST;
INSERT INTO `TEST` (S, A, M) VALUES (STRUCT(TIME:='00:01'), ARRAY['00:01', '00:01'], MAP('TIME':='00:01'));
ASSERT VALUES `TEST2` (S, A, M) VALUES ('00:01', '00:01', '00:01');

--@test: time - equal - time time
CREATE STREAM TEST (ID STRING KEY, a TIME, b TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a = b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('00:01', '00:01');
INSERT INTO `TEST` (A, B) VALUES ('00:00', '00:00:00.001');
INSERT INTO `TEST` (A, B) VALUES (NULL, '00:00');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: time - not equal - time time
CREATE STREAM TEST (ID STRING KEY, a TIME, b TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a <> b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('00:01', '00:01');
INSERT INTO `TEST` (A, B) VALUES ('00:00', '00:00:00.001');
INSERT INTO `TEST` (A, B) VALUES (NULL, '00:00');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: time - is distinct - time time
CREATE STREAM TEST (ID STRING KEY, a TIME, b TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a IS DISTINCT FROM b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('00:01', '00:01');
INSERT INTO `TEST` (A, B) VALUES ('00:00', '00:00:00.001');
INSERT INTO `TEST` (A, B) VALUES (NULL, '00:00');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: time - less than - time time
CREATE STREAM TEST (ID STRING KEY, a TIME, b TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a < b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('00:01', '00:01');
INSERT INTO `TEST` (A, B) VALUES ('00:00', '00:00:00.001');
INSERT INTO `TEST` (A, B) VALUES (NULL, '00:00');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: time - LEQ - time time
CREATE STREAM TEST (ID STRING KEY, a TIME, b TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a <= b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('00:00:00.001', '00:00');
INSERT INTO `TEST` (A, B) VALUES ('00:00', '00:00:00.001');
INSERT INTO `TEST` (A, B) VALUES ('00:00:00.001', '00:00:00.001');
INSERT INTO `TEST` (A, B) VALUES (NULL, '00:00');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: time - GEQ - time time
CREATE STREAM TEST (ID STRING KEY, a TIME, b TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a >= b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('00:00:00.001', '00:00');
INSERT INTO `TEST` (A, B) VALUES ('00:00', '00:00:00.001');
INSERT INTO `TEST` (A, B) VALUES ('00:00:00.001', '00:00:00.001');
INSERT INTO `TEST` (A, B) VALUES (NULL, '00:00');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: time - greater than - time time
CREATE STREAM TEST (ID STRING KEY, a TIME, b TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a > b) AS RESULT FROM TEST;
INSERT INTO `TEST` (A, B) VALUES ('00:00:00.001', '00:00');
INSERT INTO `TEST` (A, B) VALUES ('00:00', '00:00:00.001');
INSERT INTO `TEST` (A, B) VALUES ('00:00:00.001', '00:00:00.001');
INSERT INTO `TEST` (A, B) VALUES (NULL, '00:00');
INSERT INTO `TEST` (A, B) VALUES (NULL, NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: time - greater than - time string
CREATE STREAM TEST (ID STRING KEY, a time) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT ID, (a > '00:00:00.010') AS RESULT FROM TEST;
INSERT INTO `TEST` (A) VALUES ('00:00');
INSERT INTO `TEST` (A) VALUES ('00:00:01');
INSERT INTO `TEST` (A) VALUES ('00:00:00.005');
INSERT INTO `TEST` (A) VALUES (NULL);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (true);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);
ASSERT VALUES `TEST2` (RESULT) VALUES (false);

--@test: time - filter
CREATE STREAM TEST (ID STRING KEY, TIME TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT * FROM TEST WHERE TIME='00:00:00.010';
INSERT INTO `TEST` (TIME) VALUES ('00:00');
INSERT INTO `TEST` (TIME) VALUES ('00:00:00.010');
INSERT INTO `TEST` (TIME) VALUES (NULL);
ASSERT VALUES `TEST2` (TIME) VALUES ('00:00:00.010');

--@test: time - between
CREATE STREAM TEST (ID STRING KEY, TIME TIME) WITH (kafka_topic='test', value_format='AVRO');
CREATE STREAM TEST2 AS SELECT * FROM TEST WHERE TIME BETWEEN '00:00:00.005' AND '00:00:00.010';
INSERT INTO `TEST` (TIME) VALUES ('00:00:00.011');
INSERT INTO `TEST` (TIME) VALUES ('00:00:00.007');
INSERT INTO `TEST` (TIME) VALUES ('00:00');
INSERT INTO `TEST` (TIME) VALUES (NULL);
ASSERT VALUES `TEST2` (TIME) VALUES ('00:00:00.007');
