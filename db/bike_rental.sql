DROP TABLE IF EXISTS leases;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS stock_items;

CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  contact_number VARCHAR(255),
  age INT2
);

CREATE TABLE stock_items (
  id SERIAL4 PRIMARY KEY,
  type VARCHAR(255),
  rental_cost NUMERIC(5,2)
);

CREATE TABLE leases (
  id SERIAL4 PRIMARY KEY,
  start_date DATE,
  end_date DATE,
  duration INT2,
  customer_id INT4 REFERENCES customers(id) ON DELETE CASCADE,
  stock_item_id INT4 REFERENCES stock_items(id) ON DELETE CASCADE,
  returned BOOLEAN
);
