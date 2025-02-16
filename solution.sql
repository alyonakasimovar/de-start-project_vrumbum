-- Этап 1. Создание и заполнение БД

create schema if not exists raw_data;

create table if not exists raw_data.sales (
	/* В ненормализованной таблице содержится 1000 записей, поэтому выбираем тип smallint (диапазон допустимых значений от -32 768 до +32 767).*/
	id smallint primary key,
	/* auto содержит произвольный текст с разными символами, поэтому выбираем тип text.*/
	auto text,
	/* gasoline_consumption содержит числовые дробные значения, поэтому выбираем тип numeric.*/
	gasoline_consumption numeric,
	/* price содержит числовые дробные значения с произвольной точностью, поэтому выбираем тип numeric без указания точности.*/
	price numeric,
	/* date содержит дату без времени, поэтому выбираем тип date.*/
	date date,
	/* person_name содержит произвольный текст с разными символами, поэтому выбираем тип text.*/
	person_name text,
	/* phone содержит произвольный текст с разными символами, поэтому выбираем тип text.*/
	phone text,
	/* discount содержит числовые целые значения, поэтому выбираем тип integer.*/
	discount integer,
	/* brand_origin содержит произвольный текст с разными символами, поэтому выбираем тип text.*/
	brand_origin text);
	
/* Команда для psql:
\copy raw_data.sales(id, auto, gasoline_consumption, price, date, person_name, phone, discount, brand_origin) FROM '/Users/cars.csv' CSV HEADER NULL 'null';*/

create schema if not exists car_shop;

create table if not exists car_shop.colors (
	/* color_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
	color_id serial primary key,
	/* name содержит произвольный текст с разными символами, поэтому выбираем тип text.
	 Ограничения: не может содержать пустые значения и должен содержать уникальные значения.*/
	name text not null unique);

create table if not exists car_shop.origin_country (
	/* origin_country_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
	origin_country_id serial primary key,
	/* name содержит произвольный текст с разными символами, поэтому выбираем тип text.
	Ограничения: не может содержать пустые значения и должен содержать уникальные значения.*/
	name text not null unique);

create table if not exists car_shop.brands (
	/* brand_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
	brand_id serial primary key,
	/* name содержит произвольный текст с разными символами, поэтому выбираем тип text.
	Ограничения: не может содержать пустые значения и должен содержать уникальные значения.*/
	name text not null unique,
	/* origin_country_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
	Ограничения: по умолчанию - пустое.*/
	origin_country_id integer default null references car_shop.origin_country (origin_country_id));

create table if not exists car_shop.models (
	/* model_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
	model_id serial primary key,
	/* brand_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
	Ограничения: не может содержать пустые значения.*/
	brand_id integer not null references car_shop.brands (brand_id),
	/* name содержит произвольный текст с разными символами, поэтому выбираем тип text.
	Ограничения: не может содержать пустые значения.*/
	name text not null,
	/* gasoline_consumption содержит числовые дробные значения с заданной точностью.
	Число не может быть трехзначным, допустим 1 знак после запятой, поэтому выбираем тип numeric с заданной точностью (3,1).
	Ограничения: не может трехзначным и должен содержать только положительные значения (больше 0), по умолчанию - пустое.*/
	gasoline_consumption numeric(3, 1) default null check (gasoline_consumption > 0 and gasoline_consumption < 100));

create table if not exists car_shop.auto (
	/* auto_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
	auto_id serial primary key,
	/* model_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
	Ограничения: не может содержать пустые значения.*/
	model_id integer not null references car_shop.models (model_id),
	/* color_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
	Ограничения: не может содержать пустые значения.*/
	color_id integer not null references car_shop.colors (color_id));
	
create table if not exists car_shop.persons (
	/* person_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
	person_id serial primary key,
	/* name содержит произвольный текст с разными символами, поэтому выбираем тип text.
	Ограничения: не может содержать пустые значения.*/
	name text not null,
	/* phone содержит произвольный текст с разными символами, поэтому выбираем тип text.
	Ограничения: не может содержать пустые значения и должен содержать уникальные значения.*/
	phone text not null unique);
	
create table if not exists car_shop.sales (
	/* sale_id содержит уникальный идентификатор с автоинкрементом, поэтому выбираем тип serial.*/
	sale_id serial primary key,
	/* auto_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
	Ограничения: не может содержать пустые значения.*/
	auto_id integer not null references car_shop.auto (auto_id),
	/* price содержит содержит числовые дробные значения с заданной точностью.
	Максимальное значение - семизначное, допустимо 2 знака после запятой (денежный формат), поэтому выбираем тип numeric с заданной точностью (9,2).
	Ограничения: не может содержать пустые значения и должен содержать только положительные значения (больше 0).*/
	price numeric(9,2) not null check (price > 0),
	/* date содержит дату без времени, поэтому выбираем тип date.*/
	date date not null default current_date,
	/* person_id содержит ссылку на другую таблицу (внешний ключ), уникальный идентификатор которого - целое число, поэтому выбираем тип integer.
	Ограничения: не может содержать пустые значения.*/
	person_id integer not null references car_shop.persons (person_id),
	/* discount содержит целые числа, поэтому выбираем тип integer.*/
	/* Ограничения: не может содержать пустые значения и должен содержать положительные значения до 100, по умолчанию 0.*/
	discount integer not null default 0 check (discount >= 0 and discount < 100));

/* Заполнить таблицу origin_country.*/
INSERT INTO car_shop.origin_country (name)
SELECT DISTINCT brand_origin
FROM raw_data.sales
where brand_origin is not null;

/* Заполнить таблицу colors.*/
INSERT INTO car_shop.colors (name)
SELECT DISTINCT SPLIT_PART(auto, ', ', 2)
FROM raw_data.sales;

/* Заполнить таблицу brands.*/
INSERT INTO car_shop.brands (name, origin_country_id)
SELECT distinct
	SPLIT_PART(auto, ' ', 1) AS brand_name,
    oc.origin_country_id
FROM raw_data.sales s
LEFT JOIN car_shop.origin_country oc ON s.brand_origin = oc.name;

/* Заполнить таблицу models.*/
INSERT INTO car_shop.models (brand_id, name, gasoline_consumption)
SELECT distinct
	b.brand_id,
	SUBSTRING(s.auto, STRPOS(s.auto, ' ')+1, STRPOS(s.auto, ',') - (STRPOS(s.auto, ' ')+1)),
	s.gasoline_consumption 
FROM raw_data.sales s
left join car_shop.brands b on (SPLIT_PART(s.auto, ' ', 1) = b.name);

--truncate table car_shop.models cascade;

/* Заполнить таблицу auto.*/
INSERT INTO car_shop.auto (model_id, color_id)
select distinct m.model_id, c.color_id
FROM raw_data.sales s
join car_shop.colors c on SPLIT_PART(s.auto, ', ', 2) = c.name
join car_shop.brands b on SPLIT_PART(s.auto, ' ', 1) = b.name
join car_shop.models m on SPLIT_PART(s.auto, ',', 1) = CONCAT_WS(' ', b.name, m.name);

/* Заполнить таблицу persons.*/
INSERT INTO car_shop.persons (name, phone)
SELECT distinct person_name, phone
FROM raw_data.sales;

/* Заполнить таблицу sales.*/
INSERT INTO car_shop.sales (auto_id, price, date, person_id, discount)
select
	a.auto_id,
	s.price,
	s.date,
	p.person_id,
	s.discount
FROM raw_data.sales s
join car_shop.brands b on SPLIT_PART(s.auto, ' ', 1) = b.name
join car_shop.models m on SPLIT_PART(s.auto, ',', 1) = CONCAT_WS(' ', b.name, m.name)
join car_shop.colors c on SPLIT_PART(s.auto, ', ', 2) = c.name
join car_shop.auto a on s.auto = CONCAT(b.name, ' ', m.name, ', ', c.name) and a.model_id = m.model_id and a.color_id = c.color_id
join car_shop.persons p on s.phone = p.phone;

-- Этап 2. Создание выборок

/* Задание 1. Вывести процент моделей машин, у которых не заполнено gasoline_consumption.*/
SELECT
    COUNT(*) * 100 / (SELECT COUNT(*) FROM car_shop.models) AS nulls_percentage_gasoline_consumption
FROM car_shop.models
WHERE gasoline_consumption IS NULL;

/*Задание 2. Получить выборку брендов и среднюю цену его автомобилей в разбивке по всем годам с учётом скидки.*/
select
	b.name as brand_name,
	extract(YEAR from s.date) as year,
	avg(s.price)::numeric(9, 2) as avg
from car_shop.sales s
join car_shop.auto a using (auto_id)
join car_shop.models m using (model_id)
join car_shop.brands b using (brand_id)
group by b.name, extract(YEAR from s.date)
order by b.name, year;

/*Задание 3. Получить среднюю цену всех автомобилей с разбивкой по месяцам в 2022 году с учётом скидки.*/
select
	extract(month from s.date) as month,
	extract(YEAR from s.date) as year,
	avg(s.price)::numeric(9, 2) as avg
from car_shop.sales s
group by extract(month from s.date), extract(YEAR from s.date)
having extract(YEAR from s.date) = 2022
order by month, year;

/*Задание 4. Получить список клиентов и купленные ими автомобили.*/
select 
	p.name as person,
	string_agg(distinct(b.name || ' '|| m.name), ', ')
from car_shop.sales s
join car_shop.persons p using(person_id)
join car_shop.auto a using (auto_id)
join car_shop.models m using (model_id)
join car_shop.brands b using (brand_id)
group by p.name
order by p.name;

/*Задание 5. Получить выборку самой большой и самой маленькой цены продажи автомобиля с разбивкой по стране без учёта скидки.*/
select
	oc.name as brand_origin,
	max(s.price * 100 / (100 - s.discount))::numeric(9, 2) as price_max,
	min(s.price * 100 / (100 - s.discount))::numeric(9, 2) as price_min
from car_shop.sales s
join car_shop.persons p using(person_id)
join car_shop.auto a using (auto_id)
join car_shop.models m using (model_id)
join car_shop.brands b using (brand_id)
join car_shop.origin_country oc using (origin_country_id)
group by oc.name;

/*Задание 6. Получить  количество клиентов/пользователей из США (номер телефона начинается на +1).*/
select
	count(*) as persons_from_usa_count
from car_shop.persons
where phone like '+1%';