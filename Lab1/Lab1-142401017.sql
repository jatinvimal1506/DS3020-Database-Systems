-- Q1
CREATE DATABASE librarydb;

-- Q2
CREATE TABLE Book(
    bookID integer,
    title varchar,
    genre varchar,
    publishedYear integer,
    PRIMARY KEY(bookID),
    CHECK (publishedYear > 1947)
);

CREATE TABLE Author(
    authorID integer,
    bookID integer,
    name varchar,
    age integer,
    CHECK (age > 0),
    PRIMARY KEY(authorID),
    FOREIGN KEY(bookID) REFERENCES Book(bookID)
);

-- Q3
INSERT INTO Book VALUES(1, '1984', 'Dystopian', 1949);
INSERT INTO Author VALUES(1, 1, 'George Orwell', 46);

-- Q4
INSERT INTO Book VALUES
(2, 'The Hobbit', 'Fantasy', 1967),
(3, 'To Kill a Mockingbird', 'Fiction', 1960),
(4, 'The Alchemist', 'Philosophy', 1988),
(5, 'Harry Potter and the Sorcerer''s Stone', 'Fantasy', 1997);

INSERT INTO Author VALUES
(2, 2, 'J.R.R. Tolkien', 81),
(3, 3, 'Harper Lee', 89),
(4, 4, 'Paulo Coelho', 76),
(5, 5, 'J.K. Rowling', 58);

-- Q5
ALTER TABLE Book ADD rating INTEGER DEFAULT 3;

-- Q6
UPDATE Book SET rating = 5 WHERE bookID = 1;
UPDATE Book SET rating = 5 WHERE bookID = 3;
UPDATE Book SET rating = 5 WHERE bookID = 5;
UPDATE Book SET rating = 4 WHERE bookID = 2;
UPDATE Book SET rating = 4 WHERE bookID = 4;

-- Q7
SELECT name, age FROM Author;

-- Q8
SELECT name FROM AUTHOR WHERE age > 60;

-- Q9-i
SELECT title FROM Book WHERE publishedYear > 1990;

-- Q9-ii
UPDATE Author SET age = age + 1 WHERE authorID IN (SELECT DISTINCT authorID FROM Author JOIN Book USING (bookID) WHERE genre = 'Fantasy');

-- Q9-iii
\COPY Author(authorID,bookID,name,age) FROM '/home/142401017/Downloads/author_insert.csv' DELIMITER ',' CSV HEADER;

DROP TABLE Author;
DROP TABLE Book;
DROP DATABASE librarydb;