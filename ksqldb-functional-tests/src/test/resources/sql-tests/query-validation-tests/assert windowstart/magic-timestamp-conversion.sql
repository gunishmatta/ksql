--@test: magic-timestamp-conversion - comparison predicate on BIGINT ROWTIME in WHERE
CREATE STREAM TEST (K STRING KEY, source int) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT K, source AS THING FROM TEST WHERE ROWTIME > 1514764800001;
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('1', 1, 1514764800001);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('2', 2, 1546300808000);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('3', 3, 1514764800002);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('4', 4, 1514764800000);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('2', 2, 1546300808000);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('3', 3, 1514764800002);

--@test: magic-timestamp-conversion - comparison predicate on STRING ROWTIME in WHERE
CREATE STREAM TEST (K STRING KEY, source int) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT K, source AS THING FROM TEST WHERE ROWTIME>'2018-01-01T00:00:00.001';
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('1', 1, 1514764800001);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('2', 2, 1546300808000);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('3', 3, 1514764800002);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('4', 4, 1514764800000);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('2', 2, 1546300808000);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('3', 3, 1514764800002);

--@test: magic-timestamp-conversion - comparison predicate on BIGINT window bounds in WHERE
CREATE STREAM INPUT (K STRING KEY, source INT) WITH (kafka_topic='test_topic', value_format='JSON', WINDOW_TYPE='Session');
CREATE STREAM OUTPUT AS SELECT K, source FROM INPUT WHERE 1581323504001 <= WINDOWSTART AND WINDOWEND <= 1581323505001;
INSERT INTO `INPUT` (K, source, WINDOWSTART, WINDOWEND) VALUES ('a', 1, 1581323504000, 1581323505001);
INSERT INTO `INPUT` (K, source, WINDOWSTART, WINDOWEND) VALUES ('a', 2, 1581323504001, 1581323505001);
INSERT INTO `INPUT` (K, source, WINDOWSTART, WINDOWEND) VALUES ('a', 3, 1581323504001, 1581323505002);
ASSERT VALUES `OUTPUT` (K, SOURCE, WINDOWSTART, WINDOWEND) VALUES ('a', 2, 1581323504001, 1581323505001);

--@test: magic-timestamp-conversion - comparison predicate on STRING window bounds in WHERE
CREATE STREAM INPUT (K STRING KEY, source INT) WITH (kafka_topic='test_topic', value_format='JSON', WINDOW_TYPE='Session');
CREATE STREAM OUTPUT AS SELECT K, source FROM INPUT WHERE '2020-02-10T08:31:44.001+0000' <= WINDOWSTART AND WINDOWEND <= '2020-02-10T08:31:45.001+0000';
INSERT INTO `INPUT` (K, source, WINDOWSTART, WINDOWEND) VALUES ('a', 1, 1581323504000, 1581323505001);
INSERT INTO `INPUT` (K, source, WINDOWSTART, WINDOWEND) VALUES ('a', 2, 1581323504001, 1581323505001);
INSERT INTO `INPUT` (K, source, WINDOWSTART, WINDOWEND) VALUES ('a', 3, 1581323504001, 1581323505002);
ASSERT VALUES `OUTPUT` (K, SOURCE, WINDOWSTART, WINDOWEND) VALUES ('a', 2, 1581323504001, 1581323505001);

--@test: magic-timestamp-conversion - between predicate on BIGINT ROWTIME in WHERE
CREATE STREAM TEST (K STRING KEY, source int) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT K, source AS THING FROM TEST WHERE ROWTIME BETWEEN 1514764800001 AND 1514764801000;
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('1', 1, 1514764799999);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('2', 2, 1514764800001);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('3', 3, 1514764801000);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('4', 4, 1514764801001);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('2', 2, 1514764800001);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('3', 3, 1514764801000);

--@test: magic-timestamp-conversion - between predicate on STRING ROWTIME in WHERE
CREATE STREAM TEST (K STRING KEY, source int) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT K, source AS THING FROM TEST WHERE ROWTIME BETWEEN '2018-01-01T00:00:00.001' AND '2018-01-01T00:00:01';
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('1', 1, 1514764799999);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('2', 2, 1514764800001);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('3', 3, 1514764801000);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('4', 4, 1514764801001);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('2', 2, 1514764800001);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('3', 3, 1514764801000);

--@test: magic-timestamp-conversion - between predicate on STRING WINDOWSTART in WHERE
CREATE STREAM INPUT (K STRING KEY, source INT) WITH (kafka_topic='test_topic', value_format='JSON', WINDOW_TYPE='Tumbling', WINDOW_SIZE='1 SECOND');
CREATE STREAM OUTPUT AS SELECT K, source FROM INPUT WHERE WINDOWSTART BETWEEN '2020-02-10T08:31:44.001+0000' AND '2020-02-10T08:31:44.011+0000';
INSERT INTO `INPUT` (K, source, WINDOWSTART, WINDOWEND) VALUES ('a', 1, 1581323504000, 1581323505000);
INSERT INTO `INPUT` (K, source, WINDOWSTART, WINDOWEND) VALUES ('a', 2, 1581323504001, 1581323505001);
INSERT INTO `INPUT` (K, source, WINDOWSTART, WINDOWEND) VALUES ('a', 3, 1581323504011, 1581323505011);
INSERT INTO `INPUT` (K, source, WINDOWSTART, WINDOWEND) VALUES ('a', 4, 1581323504012, 1581323505012);
ASSERT VALUES `OUTPUT` (K, SOURCE, WINDOWSTART, WINDOWEND) VALUES ('a', 2, 1581323504001, 1581323505001);
ASSERT VALUES `OUTPUT` (K, SOURCE, WINDOWSTART, WINDOWEND) VALUES ('a', 3, 1581323504011, 1581323505011);

--@test: magic-timestamp-conversion - comparison predicate with STRING ROWTIME containing TZ in WHERE
CREATE STREAM TEST (K STRING KEY, source int) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT K, source AS THING FROM TEST WHERE ROWTIME > '2019-01-01T00:00:00+0445';
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('0', NULL, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('1', 1, 1546300800000);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('2', 2, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('3', 3, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('4', 4, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('5', 5, 1600000000000);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('1', 1, 1546300800000);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('5', 5, 1600000000000);

--@test: magic-timestamp-conversion - nested comparison expression on STRING ROWTIME in WHERE
CREATE STREAM TEST (K STRING KEY, source int) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT K, source AS THING FROM TEST WHERE ROWTIME >= '2019-01-01T00:00:00' AND SOURCE=5;
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('0', NULL, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('1', 1, 1546300800000);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('2', 2, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('3', 3, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('4', 4, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('5', 5, 1600000000000);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('5', 5, 1600000000000);

--@test: magic-timestamp-conversion - partial STRING ROWTIME
CREATE STREAM TEST (K STRING KEY, source int) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT K, source AS THING FROM TEST WHERE ROWTIME >= '2018';
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('0', NULL, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('1', 1, 1546300800000);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('2', 2, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('3', 3, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('4', 4, 0);
INSERT INTO `TEST` (K, source, ROWTIME) VALUES ('5', 5, 1600000000000);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('1', 1, 1546300800000);
ASSERT VALUES `OUTPUT` (K, THING, ROWTIME) VALUES ('5', 5, 1600000000000);
