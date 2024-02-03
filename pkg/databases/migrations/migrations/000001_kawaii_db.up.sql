BEGIN;

--set timezone
SET TIME ZONE 'Asia/Bangkok';

--install uuid extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--users_id -> U00001
--products_id -> U00001
--orders_id -> U00001
--Create sequence
CREATE SEQUENCE users_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE products_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE orders_id_seq START WITH 1 INCREMENT BY 1;

--Auto Update
CREATE OR REPLACE FUNCTION set_updated_at_column()
RETURN TRIGGER AS $$
BEGIN   
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

--Created enum
CREATE TYPE "order_status" AS ENUM (
    'wating',
    'shipping'
    'completed'
    'canceled'
)

CREATE TABLE "role" (
  "id" SERIAL INT PRIMARY KEY,
  "title" VARCHAR NOT NULL UNIQUE
);

CREATE TABLE "orders" (
  "id" VARCHAR(7) PRIMARY KEY DEFAULT CONCAT('O', LPAD(NEXTVAL('orders_id_seq')::TEXT, 6, '0')),
  "user_id" VARCHAR NOT NULL,
  "contact" VARCHAR NOT NULL,
  "address" VARCHAR NOT NULL,
  "transfer_slip" jsonb,
  "status" order_status NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "product_orders" (
  "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
  "orders_id" VARCHAR NOT NULL,
  "qty" INT NOT NULL DEFAULT 1,
  "product" jsonb
);

CREATE TABLE "users" (
  "id" VARCHAR(7) PRIMARY KEY DEFAULT CONCAT('U', LPAD(NEXTVAL('users_id_seq')::TEXT, 6, '0')),
  "username" VARCHAR UNIQUE NOT NULL,
  "password" VARCHAR NOT NULL
  "email" VARCHAR UNIQUE NOT NULL,
  "role_id" INT NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "oauth" (
  "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
  "user_id" VARCHAR NOT NULL,
  "access_token" VARCHAR NOT NULL,
  "refresh_token" VARCHAR NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "images" (
  "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
  "product_id" VARCHAR NOT NULL,
  "filename" VARCHAR NOT NULL,
  "url" VARCHAR NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "products" (
  "id" VARCHAR(7) PRIMARY KEY DEFAULT CONCAT('P', LPAD(NEXTVAL('products_id_seq')::TEXT, 6, '0')),
  "title" VARCHAR NOT NULL,
  "description" VARCHAR NOT NULL DEFAULT '',
  "price" FLOAT NOT NULL DEFAULT 0,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE "products_catagories" (
  "id" uuid NOT NULL UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
  "product_id" VARCHAR NOT NULL,
  "catagories_id" INT NOT NULL
);

CREATE TABLE "catagories" (
  "id" SERIAL PRIMARY KEY,
  "title" VARCHAR UNIQUE NOT NULL
);

ALTER TABLE "orders" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "product_orders" ADD FOREIGN KEY ("orders_id") REFERENCES "orders" ("id");
ALTER TABLE "users" ADD FOREIGN KEY ("role_id") REFERENCES "role" ("id");
ALTER TABLE "oauth" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "images" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");
ALTER TABLE "products_catagories" ADD FOREIGN KEY ("product_id") REFERENCES "products" ("id");
ALTER TABLE "products_catagories" ADD FOREIGN KEY ("catagories_id") REFERENCES "catagories" ("id");

CREATE TRIGGER set_updated_at_timestamp_users_table BEFORE UPDATE ON "users" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();
CREATE TRIGGER set_updated_at_timestamp_oauth_table BEFORE UPDATE ON "oauth" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();
CREATE TRIGGER set_updated_at_timestamp_products_table BEFORE UPDATE ON "products" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();
CREATE TRIGGER set_updated_at_timestamp_images_table BEFORE UPDATE ON "images" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();
CREATE TRIGGER set_updated_at_timestamp_orders_table BEFORE UPDATE ON "orders" FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

COMMIT;