CREATE DATABASE IF NOT EXISTS supplier1bm25cs148;
USE supplier1bm25cs148;
CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);
CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(30)
);
CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10, 2),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);
INSERT INTO Supplier (sid, sname, city) VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');
INSERT INTO Parts (pid, pname, color) VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');
INSERT INTO Catalog (sid, pid, cost) VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);
SELECT DISTINCT p.pname
FROM Parts AS p
JOIN Catalog AS c ON c.pid = p.pid;
SELECT s.sname
FROM Supplier AS s
JOIN Catalog AS c ON c.sid = s.sid
GROUP BY s.sid, s.sname
HAVING COUNT(DISTINCT c.pid) = (SELECT COUNT(*) FROM Parts);
SELECT s.sname
FROM Supplier AS s
WHERE NOT EXISTS (
    SELECT 1
    FROM Parts AS p
    WHERE p.color = 'Red'
      AND NOT EXISTS (
          SELECT 1
          FROM Catalog AS c
          WHERE c.sid = s.sid
            AND c.pid = p.pid
      )
);
SELECT p.pname
FROM Parts AS p
JOIN Catalog AS c ON c.pid = p.pid
JOIN Supplier AS s ON s.sid = c.sid
GROUP BY p.pid, p.pname
HAVING SUM(s.sname = 'Acme Widget') > 0
   AND COUNT(DISTINCT c.sid) = 1;
SELECT DISTINCT c.sid
FROM Catalog AS c
WHERE c.cost > (
    SELECT AVG(c1.cost)
    FROM Catalog AS c1
    WHERE c1.pid = c.pid
);
SELECT p.pname, s.sname
FROM Parts AS p
JOIN Catalog AS c ON c.pid = p.pid
JOIN Supplier AS s ON s.sid = c.sid
WHERE c.cost = (
    SELECT MAX(c1.cost)
    FROM Catalog AS c1
    WHERE c1.pid = p.pid
);
SELECT p.pname, s.sname, c.cost
FROM Catalog AS c
JOIN Parts AS p ON p.pid = c.pid
JOIN Supplier AS s ON s.sid = c.sid
WHERE c.cost = (SELECT MAX(cost) FROM Catalog);
SELECT s.sname
FROM Supplier AS s
WHERE NOT EXISTS (
    SELECT 1
    FROM Catalog AS c
    JOIN Parts AS p ON p.pid = c.pid
    WHERE c.sid = s.sid
      AND p.color = 'Red'
);
SELECT s.sname, SUM(c.cost) AS total_value
FROM Supplier AS s
JOIN Catalog AS c ON c.sid = s.sid
GROUP BY s.sid, s.sname;
SELECT s.sname
FROM Supplier AS s
JOIN Catalog AS c ON c.sid = s.sid
WHERE c.cost < 20
GROUP BY s.sid, s.sname
HAVING COUNT(DISTINCT c.pid) >= 2;
SELECT p.pname, s.sname, c.cost
FROM Parts AS p
JOIN Catalog AS c ON c.pid = p.pid
JOIN Supplier AS s ON s.sid = c.sid
WHERE c.cost = (
    SELECT MIN(c1.cost)
    FROM Catalog AS c1
    WHERE c1.pid = p.pid
);