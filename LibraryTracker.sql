CREATE DATABASE LibraryTracker;
USE LibraryTracker; 

-- Books table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(100),
    genre VARCHAR(50),
    published_year INT
);

-- Members table
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);

-- Borrow Records table
CREATE TABLE Borrow_Records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

-- Insert Books
INSERT INTO Books (title, author, genre, published_year) VALUES
('Harry Potter', 'J.K. Rowling', 'Fantasy', 1997),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937),
('1984', 'George Orwell', 'Dystopian', 1949),
('Clean Code', 'Robert C. Martin', 'Programming', 2008),
('Database System Concepts', 'Silberschatz', 'Education', 2010);

-- Insert Members
INSERT INTO Members (name, email, phone) VALUES
('Shreya', 'shreya@example.com', '9876543210'),
('Amit', 'amit@example.com', '9123456789'),
('Priya', 'priya@example.com', '9988776655');

-- Insert Borrow Records
INSERT INTO Borrow_Records (book_id, member_id, borrow_date, return_date) VALUES
(1, 1, '2026-05-01', '2026-05-15'),
(2, 2, '2026-05-10', NULL),
(3, 3, '2026-05-12', '2026-05-20'),
(4, 1, '2026-05-18', NULL);

SELECT Books.title, Books.author
FROM Books
JOIN Borrow_Records ON Books.book_id = Borrow_Records.book_id
JOIN Members ON Borrow_Records.member_id = Members.member_id
WHERE Members.name = 'Shreya';

SELECT Members.name, Books.title, Borrow_Records.borrow_date
FROM Borrow_Records
JOIN Books ON Borrow_Records.book_id = Books.book_id
JOIN Members ON Borrow_Records.member_id = Members.member_id
WHERE Borrow_Records.return_date IS NULL
  AND Borrow_Records.borrow_date < CURDATE() - INTERVAL 30 DAY;
  
  SELECT Members.name, COUNT(Borrow_Records.book_id) AS total_borrowed
FROM Members
LEFT JOIN Borrow_Records ON Members.member_id = Borrow_Records.member_id
GROUP BY Members.name;

SELECT Books.title, COUNT(Borrow_Records.book_id) AS borrow_count
FROM Books
JOIN Borrow_Records ON Books.book_id = Borrow_Records.book_id
GROUP BY Books.title
ORDER BY borrow_count DESC
LIMIT 1;

  DELETE FROM Borrow_Records
WHERE record_id = 1 AND return_date < '2020-01-01';

CREATE VIEW Current_Borrowed AS
SELECT Members.name, Books.title, Borrow_Records.borrow_date
FROM Borrow_Records
JOIN Books ON Borrow_Records.book_id = Books.book_id
JOIN Members ON Borrow_Records.member_id = Members.member_id
WHERE Borrow_Records.return_date IS NULL;

SELECT * FROM Current_Borrowed;

DELIMITER //
CREATE PROCEDURE ReturnBook(IN record INT, IN returnDate DATE)
BEGIN
    UPDATE Borrow_Records
    SET return_date = returnDate
    WHERE record_id = record;
END //
DELIMITER ;
