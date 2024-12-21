select * from user_tables;
select * from user_triggers;
select * from user_objects;


DROP TABLE OrderItems_Table CASCADE CONSTRAINTS;
DROP TABLE Reservations_Table CASCADE CONSTRAINTS;
DROP TABLE Orders_Table CASCADE CONSTRAINTS;
DROP TABLE MenuItems_Table CASCADE CONSTRAINTS;
DROP TABLE Employees_Table CASCADE CONSTRAINTS;
DROP TABLE Positions_Table CASCADE CONSTRAINTS;
DROP TABLE Tables_Table CASCADE CONSTRAINTS;
DROP TABLE Category_Table CASCADE CONSTRAINTS;
DROP TABLE Admins_Table CASCADE CONSTRAINTS;
DROP TABLE Customers_Table CASCADE CONSTRAINTS;

DROP PUBLIC SYNONYM Customers;
DROP PUBLIC SYNONYM Admins;
DROP PUBLIC SYNONYM Category;
DROP PUBLIC SYNONYM MenuItems;
DROP PUBLIC SYNONYM Orders;
DROP PUBLIC SYNONYM OrderItems;
DROP PUBLIC SYNONYM Positions;
DROP PUBLIC SYNONYM Employees;
DROP PUBLIC SYNONYM Tables;
DROP PUBLIC SYNONYM Reservations;

drop procedure CLEAR_DAY;
drop procedure CLEAR_MONTH;
drop procedure CLEAR_YEAR;
drop procedure CLEAR_TOTAL;
drop procedure CLEAR_ORDERS;
drop procedure CLEAR_OLD_RESERVATION;

drop public synonym user_action;
drop public synonym admin_action;

drop package admin_package;
drop package user_package;

drop user ANDREW_KANTAROVICH cascade;
drop user IVAN_IVANOV cascade;


