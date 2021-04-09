create table auth.users (
  user_name varchar(50) not null primary key,
  email    varchar(100) not null,
  password varchar(150) not null
);
