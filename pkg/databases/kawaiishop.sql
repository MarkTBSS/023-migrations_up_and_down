CREATE TABLE "role" (
  "id" int PRIMARY KEY,
  "title" varchar
);

CREATE TABLE "orders" (
  "id" varchar PRIMARY KEY,
  "user_id" varchar,
  "cantact" varchar,
  "address" varchar,
  "transfer_slip" jsonb,
  "status" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "product_orders" (
  "id" varchar PRIMARY KEY,
  "orders_id" varchar,
  "qty" int,
  "product" jsonb
);

CREATE TABLE "users" (
  "id" varchar PRIMARY KEY,
  "username" varchar UNIQUE,
  "password" varchar,
  "email" varchar UNIQUE,
  "role_id" int,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "oauth" (
  "id" varchar PRIMARY KEY,
  "user_id" varchar,
  "access_token" varchar,
  "refresh_token" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "images" (
  "id" varchar PRIMARY KEY,
  "product_id" varchar,
  "filename" varchar,
  "url" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "products" (
  "id" varchar PRIMARY KEY,
  "title" varchar,
  "description" varchar,
  "price" float,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "products_catagories" (
  "id" varchar PRIMARY KEY,
  "product_id" varchar,
  "catagories_id" varchar
);

CREATE TABLE "catagories" (
  "id" int PRIMARY KEY,
  "title" varchar UNIQUE
);

ALTER TABLE "orders" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "product_orders" ADD FOREIGN KEY ("orders_id") REFERENCES "orders" ("id");

ALTER TABLE "users" ADD FOREIGN KEY ("role_id") REFERENCES "role" ("id");

ALTER TABLE "oauth" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "images" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "products_catagories" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");

ALTER TABLE "products_catagories" ADD FOREIGN KEY ("catagories_id") REFERENCES "catagories" ("id");
