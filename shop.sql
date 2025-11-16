PRAGMA foreign_keys = ON;


CREATE TABLE IF NOT EXISTS Customers (
  username       TEXT PRIMARY KEY,
  password_hash  TEXT NOT NULL,
  full_name      TEXT NOT NULL,
  email          TEXT NOT NULL UNIQUE,
  phone          TEXT,
  address        TEXT,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Sellers (
  username       TEXT PRIMARY KEY,
  password_hash  TEXT NOT NULL,
  display_name   TEXT NOT NULL,
  email          TEXT NOT NULL UNIQUE,
  phone          TEXT,
  address        TEXT,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS Products (
  product_id       INTEGER PRIMARY KEY,
  seller_username  TEXT NOT NULL,
  name             TEXT NOT NULL,
  rating           INTEGER,
  price            INTEGER NOT NULL,
  quantity         INTEGER NOT NULL,
  description      TEXT,
  created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (seller_username) REFERENCES Sellers(username) ON DELETE CASCADE,

  CHECK (price >= 0),
  CHECK (quantity   >= 0),
  CHECK (rating IS NULL OR rating BETWEEN 1 AND 5),

  UNIQUE (seller_username, name)
);

CREATE TABLE IF NOT EXISTS Reviews (
  product_id         INTEGER NOT NULL,
  customer_username  TEXT    NOT NULL,
  rating             INTEGER NOT NULL,
  review             TEXT,
  created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (product_id, customer_username),
  FOREIGN KEY (product_id)        REFERENCES Products(product_id)   ON DELETE CASCADE,
  FOREIGN KEY (customer_username) REFERENCES Customers(username)    ON DELETE CASCADE,

  CHECK (rating BETWEEN 1 AND 5)
);


CREATE TABLE IF NOT EXISTS CartItems (
  product_id         INTEGER NOT NULL,
  customer_username  TEXT    NOT NULL,
  quantity           INTEGER NOT NULL,

  PRIMARY KEY (product_id, customer_username),
  FOREIGN KEY (product_id)        REFERENCES Products(product_id)   ON DELETE CASCADE,
  FOREIGN KEY (customer_username) REFERENCES Customers(username)    ON DELETE CASCADE,

  CHECK (quantity >= 0)
);


CREATE TABLE IF NOT EXISTS Orders (
  product_id         INTEGER   NOT NULL,
  customer_username  TEXT      NOT NULL,
  quantity           INTEGER   NOT NULL,
  created_at         DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (product_id, customer_username, created_at),
  FOREIGN KEY (product_id)        REFERENCES Products(product_id)   ON DELETE RESTRICT,
  FOREIGN KEY (customer_username) REFERENCES Customers(username)    ON DELETE RESTRICT,

  CHECK (quantity >= 0)
);

CREATE INDEX IF NOT EXISTS idx_products_seller
  ON Products(seller_username);

CREATE INDEX IF NOT EXISTS idx_reviews_product
  ON Reviews(product_id);

CREATE INDEX IF NOT EXISTS idx_reviews_customer
  ON Reviews(customer_username);

CREATE INDEX IF NOT EXISTS idx_cartitems_customer
  ON CartItems(customer_username);

CREATE INDEX IF NOT EXISTS idx_orders_customer_time
  ON Orders(customer_username, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_orders_product_time
  ON Orders(product_id, created_at DESC);
