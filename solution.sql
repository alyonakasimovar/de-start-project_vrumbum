-- Этап 1. Создание и заполнение БД

CREATE SCHEMA IF NOT EXISTS raw_data;

CREATE TABLE IF NOT EXISTS raw_data.sales (
    /* В ненормализованной таблице содержится 1000 записей, поэтому выбираем тип smallint (диапазон допустимых значений от -32 768 до +32 767).*/
    id SMALLINT PRIMARY KEY,
    /* auto содержит произвольный текст с разными символами, поэтому выбираем тип text.*/
    auto TEXT,
    /* gasoline_consumption содержит числовые дробные значения, поэтому выбираем тип numeric.*/
    gasoline_consumption NUMERIC,
    /* price содержит числовые дробные значения с произвольной точностью, поэтому выбираем тип numeric без указания точности.*/
    price NUMERIC,
    /* date содержит дату без времени, поэтому выбираем тип date.*/
    date DATE,
    /* person_name содержит произвольный текст с разными символами, поэтому выбираем тип text.*/
    person_name TEXT,
    /* phone содержит произвольный текст с разными символами, поэтому выбираем тип text.*/
    phone TEXT,
    /* discount содержит числовые целые значения, поэтому выбираем тип integer.*/
    discount INTEGER,
    /* brand_origin содержит произвольный текст с разными символами, поэтому выбираем тип text.*/
    brand_origin TEXT
);

/* Команда для psql:
\copy raw_data.sales(id, auto, gasoline_consumption, price, date, person_name, phone, discount, brand_origin) FROM '/Users/cars.csv' CSV HEADER NULL 'null';*/

CREATE SCHEMA IF NOT EXISTS car_shop;

CREATE TABLE IF NOT EXISTS car_shop.colors (
    /* color_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
    color_id SERIAL PRIMARY KEY,
    /* name содержит произвольный текст с разными символами, поэтому выбираем тип text.
     Ограничения: не может содержать пустые значения и должен содержать уникальные значения.*/
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS car_shop.origin_country (
    /* origin_country_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
    origin_country_id SERIAL PRIMARY KEY,
    /* name содержит произвольный текст с разными символами, поэтому выбираем тип text.
    Ограничения: не может содержать пустые значения и должен содержать уникальные значения.*/
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS car_shop.brands (
    /* brand_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
    brand_id SERIAL PRIMARY KEY,
    /* name содержит произвольный текст с разными символами, поэтому выбираем тип text.
    Ограничения: не может содержать пустые значения и должен содержать уникальные значения.*/
    name TEXT NOT NULL UNIQUE,
    /* origin_country_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
    Ограничения: по умолчанию - пустое.*/
    origin_country_id INTEGER DEFAULT NULL REFERENCES car_shop.origin_country (origin_country_id)
);

CREATE TABLE IF NOT EXISTS car_shop.models (
    /* model_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
    model_id SERIAL PRIMARY KEY,
    /* brand_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
    Ограничения: не может содержать пустые значения.*/
    brand_id INTEGER NOT NULL REFERENCES car_shop.brands (brand_id),
    /* name содержит произвольный текст с разными символами, поэтому выбираем тип text.
    Ограничения: не может содержать пустые значения.*/
    name TEXT NOT NULL,
    /* gasoline_consumption содержит числовые дробные значения с заданной точностью.
    Число не может быть трехзначным, допустим 1 знак после запятой, поэтому выбираем тип numeric с заданной точностью (3,1).
    Ограничения: не может трехзначным и должен содержать только положительные значения (больше 0), по умолчанию - пустое.*/
    gasoline_consumption NUMERIC(3, 1) DEFAULT NULL CHECK (gasoline_consumption > 0 AND gasoline_consumption < 100)
);

CREATE TABLE IF NOT EXISTS car_shop.auto (
    /* auto_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
    auto_id SERIAL PRIMARY KEY,
    /* model_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
    Ограничения: не может содержать пустые значения.*/
    model_id INTEGER NOT NULL REFERENCES car_shop.models (model_id),
    /* color_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
    Ограничения: не может содержать пустые значения.*/
    color_id INTEGER NOT NULL REFERENCES car_shop.colors (color_id)
);

CREATE TABLE IF NOT EXISTS car_shop.persons (
    /* person_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
    person_id SERIAL PRIMARY KEY,
    /* name содержит произвольный текст с разными символами, поэтому выбираем тип text.
    Ограничения: не может содержать пустые значения.*/
    name TEXT NOT NULL,
    /* phone содержит произвольный текст с разными символами, поэтому выбираем тип text.
    Ограничения: не может содержать пустые значения и должен содержать уникальные значения.*/
    phone TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS car_shop.sales (
    /* sale_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
    sale_id SERIAL PRIMARY KEY,
    /* auto_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
    Ограничения: не может содержать пустые значения.*/
    auto_id INTEGER NOT NULL REFERENCES car_shop.auto (auto_id),
    /* price содержит числовые дробные значения с заданной точностью.
    Максимальное значение - семизначное, допустимо 2 знака после запятой (денежный формат), поэтому выбираем тип numeric с заданной точностью (9,2).
    Ограничения: не может содержать пустые значения и должен содержать только положительные значения (больше 0).*/
    price NUMERIC(9,2) NOT NULL CHECK (price > 0),
    /* date содержит дату без времени, поэтому выбираем тип date.*/
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    /* person_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
    Ограничения: не может содержать пустые значения.*/
    person_id INTEGER NOT NULL REFERENCES car_shop.persons (person_id),
    /* discount содержит целые числа, поэтому выбираем тип integer.*/
    /* Ограничения: не может содержать пустые значения и должен содержать положительные значения до 100, по умолчанию 0.*/
    discount INTEGER NOT NULL DEFAULT 0 CHECK (discount >= 0 AND discount < 100)
);

/* Заполнить таблицу origin_country.*/
INSERT INTO car_shop.origin_country (name)
SELECT DISTINCT brand_origin
FROM raw_data.sales
WHERE brand_origin IS NOT NULL;

/* Заполнить таблицу colors.*/
INSERT INTO car_shop.colors (name)
SELECT DISTINCT SPLIT_PART(auto, ', ', 2)
FROM raw_data.sales;

/* Заполнить таблицу brands.*/
INSERT INTO car_shop.brands (name, origin_country_id)
SELECT DISTINCT
    SPLIT_PART(auto, ' ', 1) AS brand_name,
    oc.origin_country_id
FROM raw_data.sales s
LEFT JOIN car_shop.origin_country oc ON s.brand_origin = oc.name;

/* Заполнить таблицу models.*/
INSERT INTO car_shop.models (brand_id, name, gasoline_consumption)
SELECT DISTINCT
    b.brand_id,
    SUBSTRING(s.auto, STRPOS(s.auto, ' ')+1, STRPOS(s.auto, ',') - (STRPOS(s.auto, ' ')+1)),
    s.gasoline_consumption 
FROM raw_data.sales s
LEFT JOIN car_shop.brands b ON (SPLIT_PART(s.auto, ' ', 1) = b.name;

--truncate table car_shop.models cascade;

/* Заполнить таблицу auto.*/
INSERT INTO car_shop.auto (model_id, color_id)
SELECT DISTINCT m.model_id, c.color_id
FROM raw_data.sales s
JOIN car_shop.colors c ON SPLIT_PART(s.auto, ', ', 2) = c.name
JOIN car_shop.brands b ON SPLIT_PART(s.auto, ' ', 1) = b.name
JOIN car_shop.models m ON SPLIT_PART(s.auto, ',', 1) = CONCAT_WS(' ', b.name, m.name);

/* Заполнить таблицу persons.*/
INSERT INTO car_shop.persons (name, phone)
SELECT DISTINCT person_name, phone
FROM raw_data.sales;

/* Заполнить таблицу sales.*/
INSERT INTO car_shop.sales (auto_id, price, date, person_id, discount)
SELECT
    a.auto_id,
    s.price,
    s.date,
    p.person_id,
    s.discount
FROM raw_data.sales s
JOIN car_shop.brands b ON SPLIT_PART(s.auto, ' ', 1) = b.name
JOIN car_shop.models m ON SPLIT_PART(s.auto, ',', 1) = CONCAT_WS(' ', b.name, m.name)
JOIN car_shop.colors c ON SPLIT_PART(s.auto, ', ', 2) = c.name
JOIN car_shop.auto a ON s.auto = CONCAT(b.name, ' ', m.name, ', ', c.name) AND a.model_id = m.model_id AND a.color_id = c.color_id
JOIN car_shop.persons p ON s.phone = p.phone;

-- Этап 2. Создание выборок

/* Задание 1. Вывести процент моделей машин, у которых не заполнено gasoline_consumption.*/
SELECT
    COUNT(*) * 100 / (SELECT COUNT(*) FROM car_shop.models) AS nulls_percentage_gasoline_consumption
FROM car_shop.models
WHERE gasoline_consumption IS NULL;

/*Задание 2. Получить выборку брендов и среднюю цену его автомобилей в разбивке по всем годам с учётом скидки.*/
SELECT
    b.name AS brand_name,
    EXTRACT(YEAR FROM s.date) AS year,
    AVG(s.price)::NUMERIC(9, 2) AS avg
FROM car_shop.sales s
JOIN car_shop.auto a USING (auto_id)
JOIN car_shop.models m USING (model_id)
JOIN car_shop.brands b USING (brand_id)
GROUP BY b.name, EXTRACT(YEAR FROM s.date)
ORDER BY b.name, year;

/*Задание 3. Получить среднюю цену всех автомобилей с разбивкой по месяцам в 2022 году с учётом скидки.*/
SELECT
    EXTRACT(MONTH FROM s.date) AS month,
    EXTRACT(YEAR FROM s.date) AS year,
    AVG(s.price)::NUMERIC(9, 2) AS avg
FROM car_shop.sales s
GROUP BY EXTRACT(MONTH FROM s.date), EXTRACT(YEAR FROM s.date)
HAVING EXTRACT(YEAR FROM s.date) = 2022
ORDER BY month, year;

/*Задание 4. Получить список клиентов и купленные ими автомобили.*/
SELECT 
    p.name AS person,
    STRING_AGG(DISTINCT(b.name || ' '|| m.name), ', ')
FROM car_shop.sales s
JOIN car_shop.persons p USING(person_id)
JOIN car_shop.auto a USING (auto_id)
JOIN car_shop.models m USING (model_id)
JOIN car_shop.brands b USING (brand_id)
GROUP BY p.name
ORDER BY p.name;

/*Задание 5. Получить выборку самой большой и самой маленькой цены продажи автомобиля с разбивкой по стране без учёта скидки.*/
SELECT
    oc.name AS brand_origin,
    MAX(s.price * 100 / (100 - s.discount))::NUMERIC(9, 2) AS price_max,
    MIN(s.price * 100 / (100 - s.discount))::NUMERIC(9, 2) AS price_min
FROM car_shop.sales s
JOIN car_shop.persons p USING(person_id)
JOIN car_shop.auto a USING (auto_id)
JOIN car_shop.models m USING (model_id)
JOIN car_shop.brands b USING (brand_id)
JOIN car_shop.origin_country oc USING (origin_country_id)
GROUP BY oc.name;

/*Задание 6. Получить количество клиентов/пользователей из США (номер телефона начинается на +1).*/
SELECT
    COUNT(*) AS persons_from_usa_count
FROM car_shop.persons
WHERE phone LIKE '+1%';