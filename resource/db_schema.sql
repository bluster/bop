CREATE TABLE IF NOT EXISTS Seeds (
    id INT PRIMARY KEY AUTO_INCREMENT,
    url TEXT,
    revisit_period INT
);

CREATE TABLE IF NOT EXISTS Crawl (
    id INT PRIMARY KEY AUTO_INCREMENT,
    url TEXT,
    revisit_period INT,
    next_visit INT
);

DELIMITER //

CREATE PROCEDURE next_url (OUT url TEXT)
BEGIN
    SELECT @id := id, @revisitPrd := revisit_period, MIN(next_visit) FROM Crawl WHERE next_visit < UNIX_TIMESTAMP();
    IF (NOT @id IS NULL) THEN
        UPDATE Crawl SET next_visit = UNIX_TIMESTAMP() + @revisitPrd WHERE id = @id;
        SELECT @url := url FROM Crawl WHERE id = @id;
    END IF;
END;
//

CREATE FUNCTION add_url (url TEXT, revisitPrd INT) RETURNS INT
BEGIN
    INSERT INTO Crawl (url, revisit_period, next_visit) VALUES (url, revisitPrd, UNIX_TIMESTAMP());
    RETURN ROW_COUNT();
END;
//

CREATE FUNCTION add_seed (url TEXT, revisitPrd INT) RETURNS INT
BEGIN
    INSERT INTO Seeds (url, revisit_period) VALUES (url, revisitPrd);
    INSERT INTO Crawl (url, revisit_period, next_visit) VALUES (url, revisitPrd, UNIX_TIMESTAMP());
    RETURN ROW_COUNT();
END;
//

DELIMITER ;
