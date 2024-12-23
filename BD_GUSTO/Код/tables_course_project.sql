--�������
CREATE TABLE Customers_Table (
    customer_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    phone VARCHAR2(15) NOT NULL,
    order_amount NUMBER default 0,
    orders_price NUMBER default 0,
    vip NUMBER(1) DEFAULT 0 CHECK (vip IN (0, 1))
) TABLESPACE RESTAURANT_DATA;

--���������
CREATE TABLE Category_Table(
    category_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    category_name VARCHAR2(100) NOT NULL UNIQUE,
    category_description VARCHAR2(255)
) TABLESPACE RESTAURANT_DATA;

--�����
CREATE TABLE MenuItems_Table (
    item_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    description VARCHAR2(255),
    price NUMBER(10, 2) NOT NULL,
    category_id NUMBER,
    daily_buy NUMBER DEFAULT 0 CHECK (daily_buy >= 0),
    monthly_buy NUMBER DEFAULT 0 CHECK (monthly_buy >= 0),
    yearly_buy NUMBER DEFAULT 0 CHECK (yearly_buy >= 0),
    total_buy NUMBER DEFAULT 0 CHECK (total_buy >= 0),
    FOREIGN KEY (category_id) REFERENCES Category_Table(category_id) 
) TABLESPACE RESTAURANT_DATA;


--������
CREATE TABLE Orders_Table (
    order_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    customer_id NUMBER,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price NUMBER DEFAULT 0,
    item_quantity NUMBER DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Customers_Table(customer_id)
) TABLESPACE USER_DATA;

-- ������� ������
CREATE TABLE OrderItems_Table (
    order_item_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    order_id NUMBER,
    item_id NUMBER,
    quantity NUMBER NOT NULL,
    pos_price NUMBER NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders_Table(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems_Table(item_id)
) TABLESPACE USER_DATA;

--���������
CREATE TABLE Positions_Table (
    position_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    position_name VARCHAR2(100) NOT NULL
) TABLESPACE RESTAURANT_DATA;

-- ����������
CREATE TABLE Employees_Table (
    employee_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    position_id NUMBER,
    salary NUMBER(10, 2) NOT NULL,
    FOREIGN KEY (position_id) REFERENCES Positions_Table(position_id)
) TABLESPACE RESTAURANT_DATA;

--�����
CREATE TABLE Tables_Table (
    table_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    capacity NUMBER NOT NULL,
    waiter NUMBER,
    status VARCHAR2(20) DEFAULT 'Available' check (status in ('Available', 'Taken')),
    FOREIGN KEY (waiter) REFERENCES Employees_Table(employee_id)
) TABLESPACE RESTAURANT_DATA;

-- �������� ������� Reservations (������������)
CREATE TABLE Reservations_Table (
    reservation_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    customer_id NUMBER,
    table_id NUMBER,
    reservation_date TIMESTAMP NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers_Table(customer_id),
    FOREIGN KEY (table_id) REFERENCES Tables_Table(table_id) 
) TABLESPACE USER_DATA;

--������
CREATE TABLE Admins_Table (
    admin_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL
) TABLESPACE RESTAURANT_DATA;


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