CREATE TABLE restaurant (
  id integer PRIMARY KEY,
  name varchar(40),
  description varchar (100),
  rating decimal,
  telephone char(10),
  hours varchar(100)
);

CREATE TABLE address (
  id integer PRIMARY KEY,
  street_number varchar(20),
  street_name varchar(20),
  city varchar (20),
  state varchar (20),
  google_map_link varchar (50),
  restaurant_id integer REFERENCES restaurant(id) UNIQUE
);

  SELECT
  constraint_name, table_name, column_name
  FROM
  information_schema.key_column_usage
  WHERE
  table_name = 'restaurant';

  SELECT
  constraint_name, table_name, column_name
  FROM
  information_schema.key_column_usage
  WHERE
  table_name = 'address';

  CREATE TABLE category (
    id char(2) PRIMARY KEY,
    name varchar(20),
    description varchar(200)
  );

  SELECT
  constraint_name, table_name, column_name
  FROM
  information_schema.key_column_usage
  WHERE
  table_name = 'category';

CREATE TABLE dish (
    id integer PRIMARY KEY,
    name varchar(50),
    description varchar(200),
    hot_or_not boolean
  );

    SELECT
  constraint_name, table_name, column_name
  FROM
  information_schema.key_column_usage
  WHERE
  table_name = 'dish';

CREATE TABLE review (
  id integer PRIMARY KEY,
  rating decimal,
  comment varchar(200),
  date date,
  restaurant_id integer REFERENCES restaurant(id)
);

    SELECT
  constraint_name, table_name, column_name
  FROM
  information_schema.key_column_usage
  WHERE
  table_name = 'review';

CREATE TABLE categories_dishes(
  category_id char(2) REFERENCES category(id),
    dish_id integer references dish(id),
  price money
);

  SELECT
  constraint_name, table_name, column_name
  FROM
  information_schema.key_column_usage
  WHERE
  table_name = 'categories_dishes';


-- Insert values for restaurant

INSERT INTO restaurant VALUES (
  1,
  'Bytes of China',
  'Delectable Chinese Cuisine',
  3.9,
  '6175551212',
  'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm'
);

 -- Insert values for address
 
INSERT INTO address VALUES (
  1,
  '2020',
  'Busy Street',
  'Chinatown',
  'MA',
  'http://bit.ly/BytesOfChina',
  1
);


 -- Insert values for review
 
INSERT INTO review VALUES (
  1,
  5.0,
  'Would love to host another birthday party at Bytes of China!',
  '05-22-2020',
  1
);

  INSERT INTO review VALUES (
  2,
  4.5,
  'Other than a small mix-up, I would give it a 5.0!',
  '04-01-2020',
  1
);

  INSERT INTO review VALUES (
  3,
  3.9,
  'A reasonable place to eat for lunch, if you are in a rush!',
  '03-15-2020',
  1
);

 -- Insert values for category

INSERT INTO category VALUES (
  'C',
  'Chicken',
  null
);

  INSERT INTO category VALUES (
  'LS',
  'Luncheon Specials',
  'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice  between 11:00 am and 3:00 pm from Monday to Friday.'
);

  INSERT INTO category VALUES (
  'HS',
  'House Specials',
  null
);

 -- Insert values for dish
 
INSERT INTO dish VALUES (
  1,
  'Chicken with Broccoli',
  'Diced chicken stir-fried with succulent broccoli florets',
  false
);

  INSERT INTO dish VALUES (
  2,
  'Sweet and Sour Chicken',
  'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers',
  false
);

  INSERT INTO dish VALUES (
  3,
  'Chicken Wings',
  'Finger-licking mouth-watering entree to spice up any lunch or dinner',
  true
);

  INSERT INTO dish VALUES (
  4,
  'Beef with Garlic Sauce',
  'Sliced beef steak marinated in garlic sauce for that tangy flavor',
  true
);

  INSERT INTO dish VALUES (
  5,
  'Fresh Mushroom with Snow Peapods and Baby Corns',
  'Colorful entree perfect for vegetarians and mushroom lovers',
  false
);

  INSERT INTO dish VALUES (
  6,
  'Sesame Chicken',
  'Crispy chunks of chicken flavored with savory sesame sauce',
  false
);

  INSERT INTO dish VALUES (
  7,
  'Special Minced Chicken',
  'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.',
  false
);

  INSERT INTO dish VALUES (
  8,
  'Hunan Special Half & Half',
  'Shredded beef in Peking sauce and shredded chicken in garlic sauce',
  true
);

 -- Insert valus for cross-reference table, categories_dishes
 
INSERT INTO categories_dishes VALUES (
  'C',
  1,
  6.95
);

  INSERT INTO categories_dishes VALUES (
  'C',
  3,
  6.95
);

  INSERT INTO categories_dishes VALUES (
  'LS',
  1,
  8.95
);

  INSERT INTO categories_dishes VALUES (
  'LS',
  4,
  8.95
);

  INSERT INTO categories_dishes VALUES (
  'LS',
  5,
  8.95
);

  INSERT INTO categories_dishes VALUES (
  'HS',
  6,
  15.95
);

  INSERT INTO categories_dishes VALUES (
  'HS',
  7,
  16.95
);

  INSERT INTO categories_dishes VALUES (
  'HS',
  8,
  17.95
);

-- query to show the name, address and telephone details from 2 tables

SELECT restaurant.name AS name, address.street_number AS street_number, address.street_name AS street_name, restaurant.telephone AS telephone
FROM restaurant, address;

-- query to get the highest rating from reviews

SELECT MAX(rating) FROM review;

-- query to display a dish name, price and category, sorted by dish name

SELECT dish.name AS dish_name, categories_dishes.price AS price, category.name AS category
FROM dish, category, categories_dishes
WHERE category.id = categories_dishes.category_id AND dish.id = categories_dishes.dish_id
ORDER BY dish.name;

-- displaying all the spicy dishes

SELECT dish.name AS dish_name, category.name AS category, categories_dishes.price AS price
FROM dish, category, categories_dishes
WHERE dish.hot_or_not = 'true' AND category.id = categories_dishes.category_id AND dish.id = categories_dishes.dish_id;

-- selecting the dish id's and counting how many categories they are included in

SELECT dish.id AS dish_id,
  COUNT(dish_id) AS dish_count
FROM dish
JOIN categories_dishes
  ON dish.id = categories_dishes.dish_id
GROUP BY dish.id
ORDER BY dish_count DESC;

-- same as above, but showing the dish name not the id, also limiting results to dishes counted in more than 1

SELECT dish.id AS id, dish.name AS dish_name,
  COUNT(dish_id) AS dish_count
FROM dish
JOIN categories_dishes
  ON dish.id = categories_dishes.dish_id
GROUP BY dish.id,
dish.name
HAVING COUNT (dish.id) > 1
ORDER BY dish.id ASC;

-- final step, returning highest review for the restaurant

SELECT
restaurant.name AS name, review.rating AS best_rating, restaurant.description AS description
FROM restaurant
JOIN review
ON
review.restaurant_id = restaurant.id
WHERE
review.rating = (
SELECT MAX(rating) from review
)
GROUP BY
restaurant.name,
restaurant.description,
review.rating;
