create database Supplier;
use Supplier;
create table SUPPLIERS(sid int(5) primary key, sname varchar(20), city varchar(20));
create table PARTS(pid int(5) primary key, pname varchar(20), color varchar(10));
create table CATALOG(sid int(5), pid int(5),  foreign key(sid) references SUPPLIERS(sid), foreign key(pid) references PARTS(pid), cost float(6), primary key(sid, pid));
show tables;

select * from suppliers;

-- i. Find the pnames of parts for which there is some supplier. 

SELECT DISTINCT P.pname
    FROM PARTS P, CATALOG C
    WHERE P.pid = C.pid;
    
-- ii. Find the snames of suppliers who supply every part. 

SELECT S.sname
 FROM SUPPLIERS S
 WHERE NOT EXISTS(SELECT P.pid FROM PARTS P
not in
 (SELECT C.pid FROM CATALOG C
 WHERE C.sid = S.sid));    
            
-- iii. Find the snames of suppliers who supply every red part.            

SELECT S.sname
 FROM SUPPLIERS S
 WHERE NOT EXISTS ((SELECT P.pid 
 FROM PARTS P
 WHERE P.color = 'Red')
not in
(SELECT C.pid
 FROM CATALOG C, PARTS P 
 WHERE C.sid = S.sid AND
 C.pid = P.pid AND P.color = 'Red'));
            
-- iv. Find the pnames of parts supplied by acme widget Suppliers and by no one else
            
SELECT P.pname
FROM PARTS P, CATALOG C, SUPPLIERS S
WHERE P.pid = C.pid AND C.sid = S.sid
AND S.sname = 'acme widget'
AND NOT EXISTS ( SELECT *
		FROM CATALOG C1, SUPPLIERS S1
		WHERE P.pid = C1.pid AND C1.sid = S1.sid AND
		S1.sname <> 'acme widget' );
        
-- v. Find the sids of suppliers who charge more for some part than the average cost of that part (averaged over  all the suppliers who supply that part). 
        
SELECT DISTINCT C.sid 
FROM CATALOG C
WHERE C.cost > ( SELECT AVG (C1.cost)
				FROM CATALOG C1
				WHERE C1.pid = C.pid );
                               
-- vi. For each part, find the sname of the supplier who charges the most for that part. 
                               
SELECT P.pid, S.sname
FROM PARTS P, SUPPLIERS S, CATALOG C
WHERE C.pid = P.pid
AND C.sid = S.sid
AND C.cost = (SELECT MAX(C1.cost)
		FROM CATALOG C1
		WHERE C1.pid = P.pid);
        
-- vii. Find the sids of suppliers who supply only red parts. 
        
SELECT s.sid, S.sname
FROM Parts P, SUPPLIERS S, CATALOG C
WHERE C.pid = P.pid
AND C.sid = S.sid
AND C.cost = (SELECT MAX(C1.cost)
		FROM CATALOG C1
		WHERE C1.pid = P.pid);
