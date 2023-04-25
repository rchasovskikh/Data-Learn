--Create and fill dimension tables

drop table if exists customer_dim;

CREATE TABLE customer_dim
(
 customer_id   varchar(8) NOT NULL,
 customer_name varchar(22) NOT NULL,
 segment       varchar(11) NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( customer_id )
);

insert into customer_dim
select distinct 
 customer_id,
 customer_name,
 segment
FROM public.orders;

drop table if exists order_date_dim;

CREATE TABLE order_date_dim
(
 order_date             date NOT NULL,
 day_name               text NOT NULL,
 day_of_week            int NOT NULL,
 day_of_month           int NOT NULL,
 day_of_year            int NOT NULL,
 month                  int NOT NULL,
 month_name             text NOT NULL,
 month_name_abbreviated text NOT NULL,
 year_value             int NOT NULL,
 first_day_of_week      date NOT NULL,
 last_day_of_week       date NOT NULL,
 CONSTRAINT PK_2 PRIMARY KEY ( order_date )
);

insert into order_date_dim
select *
from date_dim dd;

drop table if exists ship_date_dim;

CREATE TABLE ship_date_dim
(
 ship_date              date NOT NULL,
 day_name               text NOT NULL,
 day_of_week            int NOT NULL,
 day_of_month           int NOT NULL,
 day_of_year            int NOT NULL,
 month                  int NOT NULL,
 month_name             text NOT NULL,
 month_name_abbreviated text NOT NULL,
 year_value             int NOT NULL,
 first_day_of_week      date NOT NULL,
 last_day_of_week       date NOT NULL,
 CONSTRAINT PK_3 PRIMARY KEY ( ship_date )
);

insert into ship_date_dim
select *
from date_dim dd;

drop table if exists product_dim;

CREATE TABLE product_dim
(
 product_id   varchar(15) NOT NULL,
 category     varchar(15) NOT NULL,
 subcategory  varchar(15) NOT NULL,
 product_name varchar(127) NOT NULL,
 CONSTRAINT PK_4 PRIMARY KEY ( product_id )
);

insert into product_dim 
select distinct
o.product_id,
o.category,
o.subcategory,
o.product_name
from public.orders o
on conflict (product_id) do nothing;

drop table if exists city_dim;

CREATE TABLE city_dim
(
 city    varchar(17) NOT NULL,
 country varchar(13) NOT NULL,
 state   varchar(20) NOT NULL,
 region  varchar(7) NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( city )
);

insert into city_dim
select distinct 
city,
country,
state,
region
from public.orders
on conflict (city) do nothing;


--Create and fill facts table

drop table if exists superstore_fact

CREATE TABLE superstore_fact
(
 row_id      int4 NOT NULL,
 order_id    varchar(14) NOT NULL,
 order_date  date NOT NULL,
 ship_date   date NOT NULL,
 postal_code int4,
 customer_id varchar(8) NOT NULL,
 city        varchar(17) NOT NULL,
 product_id  varchar(15) NOT NULL,
 sales       numeric(9, 4) NOT NULL,
 quantity    int4 NOT NULL,
 discount    numeric(4, 2) NOT NULL,
 profit      numeric(21, 16) NOT NULL,
 CONSTRAINT PK_6 PRIMARY KEY ( row_id ),
 CONSTRAINT FK_1 FOREIGN KEY ( product_id ) REFERENCES product_dim ( product_id ),
 CONSTRAINT FK_2 FOREIGN KEY ( order_date ) REFERENCES order_date_dim ( order_date ),
 CONSTRAINT FK_3 FOREIGN KEY ( ship_date ) REFERENCES ship_date_dim ( ship_date ),
 CONSTRAINT FK_4 FOREIGN KEY ( customer_id ) REFERENCES customer_dim ( customer_id ),
 CONSTRAINT FK_5 FOREIGN KEY ( city ) REFERENCES city_dim ( city )
);

CREATE INDEX FK_2 ON superstore_fact
(
 product_id
);

CREATE INDEX FK_3 ON superstore_fact
(
 order_date
);

CREATE INDEX FK_4 ON superstore_fact
(
 ship_date
);

CREATE INDEX FK_5 ON superstore_fact
(
 customer_id
);

CREATE INDEX FK_6 ON superstore_fact
(
 city
);

insert into superstore_fact 
select
 o.row_id,
 o.order_id,
 o.order_date,
 o.ship_date,
 o.postal_code,
 o.customer_id,
 o.city,
 o.product_id,
 o.sales,
 o.quantity,
 o.discount,
 o.profit 
 from public.orders o;