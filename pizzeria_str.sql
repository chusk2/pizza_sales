

CREATE TABLE pizzas (
  pizza_id smallint PRIMARY KEY,
  pizza_name text,
  pizza_category text
);

CREATE TABLE ingredients (
  ingredient_id smallint PRIMARY KEY,
  ingredient_name text
);

CREATE TABLE pizza_ingredients (
  pizza_id smallint,
  pizza_ingredient_id smallint,
  foreign key (pizza_id) references pizzas (pizza_id),
  foreign key (pizza_ingredient_id) references ingredients (ingredient_id)
);

CREATE TABLE pizza_prices (
  pizza_id smallint,
  pizza_size char(3),
  unit_price float,
  -- make a composite primary key
  -- combining pizza_id and size
  constraint pizza_prices_pk primary key (pizza_id, pizza_size)
);

CREATE TABLE orders (
  order_id integer,
  order_timestamp timestamp,
  pizza_id smallint,
  pizza_size char(3),
  quantity integer,
  FOREIGN KEY (pizza_id) references pizzas (pizza_id),
  FOREIGN KEY (pizza_id, pizza_size) references pizza_prices (pizza_id, pizza_size)
);


