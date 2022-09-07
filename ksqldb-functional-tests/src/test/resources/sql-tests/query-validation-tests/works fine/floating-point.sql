--@test: floating-point - filter by DOUBLE
CREATE STREAM INPUT (K DOUBLE KEY, ID INT) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT * FROM INPUT WHERE K > 0.1;
INSERT INTO `INPUT` (K, ID) VALUES (0.0, 0);
INSERT INTO `INPUT` (K, ID) VALUES (0.099, 1);
INSERT INTO `INPUT` (K, ID) VALUES (0.1, 2);
INSERT INTO `INPUT` (K, ID) VALUES (0.10001, 3);
INSERT INTO `INPUT` (K, ID) VALUES (0.2, 4);
INSERT INTO `INPUT` (ID) VALUES (5);
ASSERT VALUES `OUTPUT` (K, ID) VALUES (0.10001, 3);
ASSERT VALUES `OUTPUT` (K, ID) VALUES (0.2, 4);

--@test: floating-point - with exponent
CREATE STREAM INPUT (K DOUBLE KEY, ID INT) WITH (kafka_topic='test_topic', value_format='JSON');
CREATE STREAM OUTPUT AS SELECT * FROM INPUT WHERE K > 1e-1;
INSERT INTO `INPUT` (K, ID) VALUES (0.0, 0);
INSERT INTO `INPUT` (K, ID) VALUES (0.099, 1);
INSERT INTO `INPUT` (K, ID) VALUES (0.1, 2);
INSERT INTO `INPUT` (K, ID) VALUES (0.10001, 3);
INSERT INTO `INPUT` (K, ID) VALUES (0.2, 4);
INSERT INTO `INPUT` (ID) VALUES (5);
ASSERT VALUES `OUTPUT` (K, ID) VALUES (0.10001, 3);
ASSERT VALUES `OUTPUT` (K, ID) VALUES (0.2, 4);
