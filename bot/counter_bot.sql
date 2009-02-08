CREATE TABLE users (
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(255),
  mail VARCHAR(65)
);

CREATE TABLE challenges (
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(255),
  level INTEGER,
  score INTEGER,
  uid INTEGER
);

CREATE TABLE user_challenges (
  user_id INTEGER NOT NULL,
  challenge_id INTEGER NOT NULL
);

INSERT into challenges values (NULL, 'challenge 01', '1', '1', 1001);
INSERT into challenges values (NULL, 'challenge 02', '1', '1', 1002);
INSERT into challenges values (NULL, 'challenge 03', '1', '1', 1003);
INSERT into challenges values (NULL, 'challenge 04', '1', '1', 1004);
INSERT into challenges values (NULL, 'challenge 05', '1', '1', 1005);
INSERT into challenges values (NULL, 'challenge 06', '1', '1', 1006);
INSERT into challenges values (NULL, 'challenge 07', '1', '1', 1007);
INSERT into challenges values (NULL, 'challenge 08', '1', '1', 1008);
INSERT into challenges values (NULL, 'challenge 09', '1', '1', 1009);
INSERT into challenges values (NULL, 'challenge 10', '1', '1', 1010);
INSERT into challenges values (NULL, 'challenge 11', '1', '1', 1011);
