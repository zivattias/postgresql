create table customers (
	id serial primary key,
	passport_num int unique not null,
	fullname varchar(128) not null,
	address varchar(128) not null
);

create table accounts (
	id serial primary key,
	account_num int unique not null,
	max_limit int not null check (max_limit > 0),
	balance int not null
);

create table customers_accounts (
	id serial primary key,
	account_id int references accounts (id),
	customer_id int references customers (id),
	unique (customer_id, account_id)
);

create table transactions (
	id serial primary key,
	trans_type varchar(8) check (trans_type in ('deposit', 'withdraw', 'transfer')),
	ts timestamp not null default now(),
	initiator_id int references customers (id)
);

create table transactions_accounts (
	id serial primary key,
	account_role varchar(9) check (account_role in ('sender', 'receiver', 'self')),
	transaction_id int references transactions (id),
	account_id int references accounts (id)
);