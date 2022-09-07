--@test: max-group-by - max integer group by
CREATE STREAM TEST (ID BIGINT KEY, VALUE integer) WITH (kafka_topic='test_topic',value_format='AVRO');
CREATE TABLE S2 as SELECT ID, max(value) as value FROM test group by id;
INSERT INTO `TEST` (ID, value) VALUES (1, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, -2147483647);
INSERT INTO `TEST` (ID, value) VALUES (0, 5);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (100, 100);
INSERT INTO `TEST` (ID, value) VALUES (100, 6);
INSERT INTO `TEST` (ID, value) VALUES (100, 300);
INSERT INTO `TEST` (ID, value) VALUES (0, 2000);
INSERT INTO `TEST` (ID, value) VALUES (0, 100);
ASSERT VALUES `S2` (ID, VALUE) VALUES (1, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, -2147483647);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 5);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 5);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 100);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 100);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 300);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 2000);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 2000);

--@test: max-group-by - max long group by
CREATE STREAM TEST (ID BIGINT KEY, VALUE bigint) WITH (kafka_topic='test_topic', value_format='AVRO');
CREATE TABLE S2 as SELECT ID, max(value) as value FROM test group by id;
INSERT INTO `TEST` (ID, value) VALUES (1, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, -1000000);
INSERT INTO `TEST` (ID, value) VALUES (0, 5);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (100, 100);
INSERT INTO `TEST` (ID, value) VALUES (100, 6);
INSERT INTO `TEST` (ID, value) VALUES (100, 300);
INSERT INTO `TEST` (ID, value) VALUES (0, 9223372036854775807);
INSERT INTO `TEST` (ID, value) VALUES (0, 100);
ASSERT VALUES `S2` (ID, VALUE) VALUES (1, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, -1000000);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 5);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 5);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 100);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 100);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 300);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 9223372036854775807);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 9223372036854775807);

--@test: max-group-by - max double group by
CREATE STREAM TEST (ID BIGINT KEY, VALUE double) WITH (kafka_topic='test_topic', value_format='AVRO');
CREATE TABLE S2 as SELECT ID, max(value) as value FROM test group by id;
INSERT INTO `TEST` (ID, value) VALUES (1, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, -1000000.123);
INSERT INTO `TEST` (ID, value) VALUES (0, 0.0);
INSERT INTO `TEST` (ID, value) VALUES (0, 5.1);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (100, 100.1);
INSERT INTO `TEST` (ID, value) VALUES (100, 6.4);
INSERT INTO `TEST` (ID, value) VALUES (100, 300.8);
INSERT INTO `TEST` (ID, value) VALUES (0, 2000.99);
INSERT INTO `TEST` (ID, value) VALUES (0, 100.11);
ASSERT VALUES `S2` (ID, VALUE) VALUES (1, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, -1000000.123);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 0.0);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 5.1);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 5.1);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 100.1);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 100.1);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 300.8);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 2000.99);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 2000.99);

--@test: max-group-by - max decimal group by
CREATE STREAM TEST (ID BIGINT KEY, VALUE decimal(4, 2)) WITH (kafka_topic='test_topic', value_format='AVRO');
CREATE TABLE S2 as SELECT ID, max(value) as value FROM test group by id;
INSERT INTO `TEST` (ID, value) VALUES (1, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, -10.12);
INSERT INTO `TEST` (ID, value) VALUES (0, 00.00);
INSERT INTO `TEST` (ID, value) VALUES (0, 05.10);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (100, 10.10);
INSERT INTO `TEST` (ID, value) VALUES (100, 06.40);
INSERT INTO `TEST` (ID, value) VALUES (100, 30.80);
INSERT INTO `TEST` (ID, value) VALUES (0, 20.99);
INSERT INTO `TEST` (ID, value) VALUES (0, 10.11);
ASSERT VALUES `S2` (ID, VALUE) VALUES (1, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, -10.12);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 00.00);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 05.10);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 05.10);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 10.10);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 10.10);
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 30.80);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 20.99);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 20.99);

--@test: max-group-by - max date group by valid after 7.2.0
CREATE STREAM TEST (ID BIGINT KEY, VALUE DATE) WITH (kafka_topic='test_topic', value_format='AVRO');
CREATE TABLE S2 as SELECT ID, max(value) as value FROM test group by id;
INSERT INTO `TEST` (ID, value) VALUES (1, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, '1969-09-23');
INSERT INTO `TEST` (ID, value) VALUES (0, '1970-01-06');
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (100, '1970-04-11');
INSERT INTO `TEST` (ID, value) VALUES (100, '1970-01-07');
INSERT INTO `TEST` (ID, value) VALUES (100, '1970-04-21');
INSERT INTO `TEST` (ID, value) VALUES (0, '1972-09-27');
INSERT INTO `TEST` (ID, value) VALUES (0, '1970-04-11');
ASSERT VALUES `S2` (ID, VALUE) VALUES (1, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '1969-09-23');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '1970-01-06');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '1970-01-06');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, '1970-04-11');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, '1970-04-11');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, '1970-04-21');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '1972-09-27');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '1972-09-27');

--@test: max-group-by - max timestamp group by valid after 7.2.0
CREATE STREAM TEST (ID BIGINT KEY, VALUE TIMESTAMP) WITH (kafka_topic='test_topic', value_format='AVRO');
CREATE TABLE S2 as SELECT ID, max(value) as value FROM test group by id;
INSERT INTO `TEST` (ID, value) VALUES (1, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, '1969-12-31T23:59:59.999');
INSERT INTO `TEST` (ID, value) VALUES (0, '1970-01-01T00:00:00.050');
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (100, '1970-01-01T00:00:00.150');
INSERT INTO `TEST` (ID, value) VALUES (100, '1970-01-01T00:00:00.006');
INSERT INTO `TEST` (ID, value) VALUES (100, '1970-01-01T00:00:01.000');
INSERT INTO `TEST` (ID, value) VALUES (0, '1970-01-01T00:00:01.010');
INSERT INTO `TEST` (ID, value) VALUES (0, '1970-01-01T00:00:00.100');
ASSERT VALUES `S2` (ID, VALUE) VALUES (1, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '1969-12-31T23:59:59.999');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '1970-01-01T00:00:00.050');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '1970-01-01T00:00:00.050');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, '1970-01-01T00:00:00.150');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, '1970-01-01T00:00:00.150');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, '1970-01-01T00:00:01.000');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '1970-01-01T00:00:01.010');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '1970-01-01T00:00:01.010');

--@test: max-group-by - max time group by valid after 7.2.0
CREATE STREAM TEST (ID BIGINT KEY, VALUE TIME) WITH (kafka_topic='test_topic', value_format='AVRO');
CREATE TABLE S2 as SELECT ID, max(value) as value FROM test group by id;
INSERT INTO `TEST` (ID, value) VALUES (1, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, '00:00');
INSERT INTO `TEST` (ID, value) VALUES (0, '00:00');
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (100, '00:00');
INSERT INTO `TEST` (ID, value) VALUES (100, '00:00');
INSERT INTO `TEST` (ID, value) VALUES (100, '00:00');
INSERT INTO `TEST` (ID, value) VALUES (0, '00:00:01');
INSERT INTO `TEST` (ID, value) VALUES (0, '00:00');
ASSERT VALUES `S2` (ID, VALUE) VALUES (1, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '00:00');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '00:00');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '00:00');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, '00:00');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, '00:00');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, '00:00');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '00:00:01');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, '00:00:01');

--@test: max-group-by - max string group by
CREATE STREAM TEST (ID BIGINT KEY, VALUE STRING) WITH (kafka_topic='test_topic',value_format='AVRO');
CREATE TABLE S2 as SELECT ID, max(value) as value FROM test group by id;
INSERT INTO `TEST` (ID, value) VALUES (1, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, 'B');
INSERT INTO `TEST` (ID, value) VALUES (0, 'A');
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (100, 'E');
INSERT INTO `TEST` (ID, value) VALUES (100, 'C');
INSERT INTO `TEST` (ID, value) VALUES (100, 'G');
INSERT INTO `TEST` (ID, value) VALUES (0, 'F');
INSERT INTO `TEST` (ID, value) VALUES (0, 'D');
ASSERT VALUES `S2` (ID, VALUE) VALUES (1, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 'B');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 'B');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 'B');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 'E');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 'E');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 'G');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 'F');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 'F');

--@test: max-group-by - max bytes group by
CREATE STREAM TEST (ID BIGINT KEY, VALUE BYTES) WITH (kafka_topic='test_topic',value_format='AVRO');
CREATE TABLE S2 as SELECT ID, max(value) as value FROM test group by id;
INSERT INTO `TEST` (ID, value) VALUES (1, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (0, 'Qg==');
INSERT INTO `TEST` (ID, value) VALUES (0, 'QQ==');
INSERT INTO `TEST` (ID, value) VALUES (0, NULL);
INSERT INTO `TEST` (ID, value) VALUES (100, 'RQ==');
INSERT INTO `TEST` (ID, value) VALUES (100, 'Qw==');
INSERT INTO `TEST` (ID, value) VALUES (100, 'Rw==');
INSERT INTO `TEST` (ID, value) VALUES (0, 'Rg==');
INSERT INTO `TEST` (ID, value) VALUES (0, 'RA==');
ASSERT VALUES `S2` (ID, VALUE) VALUES (1, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, NULL);
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 'Qg==');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 'Qg==');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 'Qg==');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 'RQ==');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 'RQ==');
ASSERT VALUES `S2` (ID, VALUE) VALUES (100, 'Rw==');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 'Rg==');
ASSERT VALUES `S2` (ID, VALUE) VALUES (0, 'Rg==');
