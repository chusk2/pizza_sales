-- Insert values into table: pizzas , from pizzas.csv file

copy pizzas from '/home/debian/data/pgdata/pizzeria/pizzas.csv' with csv header ;

-- Insert values into table: ingredients , from ingredients.csv file

copy ingredients from '/home/debian/data/pgdata/pizzeria/ingredients.csv' with csv header ;

-- Insert values into table: pizza_ingredients , from pizza_ingredients.csv file

copy pizza_ingredients from '/home/debian/data/pgdata/pizzeria/pizza_ingredients.csv' with csv header ;

-- Insert values into table: pizza_prices , from pizza_prices.csv file

copy pizza_prices from '/home/debian/data/pgdata/pizzeria/pizza_prices.csv' with csv header ;

-- Insert values into table: orders , from orders.csv file

copy orders from '/home/debian/data/pgdata/pizzeria/orders.csv' with csv header ;

