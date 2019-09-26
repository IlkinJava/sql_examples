CREATE TABLE employees (
  id         SERIAL PRIMARY KEY,
  name       VARCHAR(255),
  department VARCHAR(255)
);

INSERT INTO employees (name, department)
VALUES ('Ilkin', 'Software Development');
INSERT INTO employees (name, department)
VALUES ('Sara', 'Marketing');
INSERT INTO employees (name, department)
VALUES ('Elnara', 'HR');
INSERT INTO employees (name, department)
VALUES ('Elshan', 'IT');


ALTER TABLE employees
  ADD COLUMN position VARCHAR(255);

UPDATE employees
SET position = 'Team Lead'
WHERE name = 'Ilkin';
UPDATE employees
SET position = 'Senior Marketing Manager'
WHERE name = 'Sara';
UPDATE employees
SET position = 'Head of HR'
WHERE name = 'Elnara';
UPDATE employees
SET position = 'Junior IT specialist'
WHERE name = 'Elshan';

ALTER TABLE employees
  ADD COLUMN salary DOUBLE PRECISION;

SELECT *
FROM employees;

SELECT name
FROM employees;

SELECT position
FROM employees
WHERE salary = 4000;

DELETE
FROM employees
WHERE name = 'Elshan';

INSERT INTO employees (name, department, position, salary)
VALUES (DEFAULT, 'Operation', 'Director of department', DEFAULT);

DELETE
FROM employees
WHERE name ISNULL;

SELECT *
FROM employees
WHERE salary BETWEEN 3500 AND 5000;

CREATE TABLE persons (
  id          SERIAL PRIMARY KEY,
  nationality VARCHAR(255)
);

DELETE
FROM persons;

TRUNCATE TABLE persons;

DROP TABLE persons;

SELECT *
FROM employees
WHERE id = 1
   OR id = 2;

SELECT *
FROM employees
WHERE id = 1
   OR name = 'Sara';

SELECT *
FROM employees
WHERE id = 1
  AND name = 'Ilkin';

SELECT *
FROM employees
WHERE salary = 4000
  AND (name = 'Ilkin' OR name = 'Sara');

SELECT id, name
FROM employees
ORDER BY id DESC;

INSERT INTO employees (name, department, position, salary)
VALUES ('Ilkin', 'Sales', 'Sales Manager', '1800');

SELECT DISTINCT name
FROM employees;

SELECT name, NOW()
FROM employees;


CREATE TABLE orders (
  id          SERIAL PRIMARY KEY,
  customer_id INTEGER REFERENCES customers (id),
  order_date  DATE
);

CREATE TABLE customers (
  id            SERIAL PRIMARY KEY,
  customer_name VARCHAR(255),
  contact_name  VARCHAR(255),
  country       VARCHAR(255)
);

SELECT o.order_date, c.customer_name, c.country
from orders o,
     customers c
WHERE o.customer_id = c.id;

SELECT o.order_date, c.customer_name, c.country
FROM orders o
       INNER JOIN customers c ON o.customer_id = c.id;

SELECT o.id, c.customer_name, c.country
FROM orders o
       LEFT JOIN customers c ON c.id = o.customer_id;

SELECT o.id, c.customer_name, c.country
FROM orders o
       RIGHT JOIN customers c ON c.id = o.customer_id;

SELECT o.id, c.customer_name, c.country
FROM orders o FULL
       JOIN customers c ON c.id = o.customer_id;

SELECT o.id, c.customer_name
FROM orders o
       CROSS JOIN customers c;

SELECT *
FROM orders
WHERE customer_id = ANY (SELECT id FROM customers);

SELECT *
FROM orders
WHERE id > ALL (SELECT id FROM customers);

SELECT o.id
FROM customers c,
     orders o
WHERE c.id = 2
  AND o.customer_id = c.id;

BEGIN;
UPDATE employees
SET name = 'John'
WHERE id = 1;
SAVEPOINT my_save;
UPDATE employees
SET name = 'John'
WHERE id = 2;
UPDATE employees
SET name = 'John'
WHERE id = 103;
ROLLBACK TO my_save;
COMMIT;


CREATE TABLE companies_profit (
  id             SERIAL PRIMARY KEY,
  name           VARCHAR(100),
  year           INT,
  money_turnover DECIMAL
);

CREATE TABLE countries (
  id     SERIAL PRIMARY KEY,
  name   VARCHAR(100),
  budget DECIMAL
);
SELECT COUNT(name)
FROM countries
WHERE budget < 150;

SELECT COUNT(DISTINCT name)
FROM countries
WHERE budget < 150;

-- AVG
SELECT AVG(budget)
FROM countries;

-- MIN
SELECT MIN(budget)
FROM countries;

-- MAX
SELECT MAX(budget)
FROM countries;

-- SUM
-- SUM ( [ALL | DISTINCT] expression )

SELECT SUM(budget)
FROM countries;

-- GROUP BY
SELECT name, SUM(money_turnover)
FROM companies_profit
GROUP BY name;

-- HAVING
SELECT name, SUM(money_turnover)
FROM companies_profit
GROUP BY name
HAVING SUM(money_turnover) > 300;

CREATE SEQUENCE next_id
  INCREMENT 5
  START 100;

CREATE TABLE users (
  id   INTEGER PRIMARY KEY DEFAULT nextval('next_id'),
  name VARCHAR(255)
);

INSERT INTO users (id, name)
VALUES (nextval('next_id'), 'Ilkin');

INSERT INTO users
VALUES (nextval('next_id'), 'Jony');

INSERT INTO users (name)
VALUES ('Ilkin');

INSERT INTO users (name)
VALUES ('Jony');

CREATE FUNCTION insert_countries(
  name   VARCHAR(255),
  budget DECIMAL)
  RETURNS VOID AS
$BODY$
BEGIN
  INSERT INTO countries (name, budget) values (name, budget);
END;
$BODY$
LANGUAGE 'plpgsql';


SELECT *
FROM insert_countries('Canada', 221);

CREATE FUNCTION insert_countries_2(
  name   VARCHAR(255),
  budget DECIMAL
)
  RETURNS VOID AS
$$
BEGIN
  IF (name = 'Canada')
  THEN
    INSERT INTO countries (name, budget) values (name, 110);
  ELSEIF (budget = 221)
    THEN
      INSERT INTO countries (name, budget) values ('USA', 221);
  END IF;
END;
$$
LANGUAGE plpgsql;

SELECT *
FROM insert_countries_2('Canada', 222);

SELECT *
FROM insert_countries_2('AAA', 221);

CREATE FUNCTION countries_checker()
  RETURNS TRIGGER AS
$countries_checker$
BEGIN
  IF new.name IS null
  THEN
    RAISE EXCEPTION 'Name can not be null';
  END IF;
  RETURN new;
END;
$countries_checker$
LANGUAGE plpgsql;

CREATE TRIGGER countries_check_trigger
  BEFORE INSERT OR UPDATE
  ON countries
  FOR EACH ROW EXECUTE PROCEDURE countries_checker();

SELECT *
FROM insert_countries('UK', 200);

CREATE VIEW my_view AS
  SELECT *
  FROM countries;

SELECT name
FROM my_view;