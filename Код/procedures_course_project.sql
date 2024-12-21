-- ��������� ��� ���������� �������
CREATE OR REPLACE PROCEDURE AddCustomer (
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    INSERT INTO Customers (first_name, last_name, user_password, phone, email)
    VALUES (p_first_name, p_last_name,  p_phone, p_email);
END;

-- ��������� ��� ���������� ���������� � �������
CREATE OR REPLACE PROCEDURE UpdateCustomer (
    p_customer_id IN NUMBER,
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    UPDATE Customers
    SET first_name = p_first_name,
        last_name = p_last_name,
        phone = p_phone,
        email = p_email
    WHERE customer_id = p_customer_id;
END;

-- ��������� ��� �������� �������
CREATE OR REPLACE PROCEDURE DeleteCustomer (
    p_customer_id IN NUMBER
) AS
BEGIN
    DELETE FROM Customers
    WHERE customer_id = p_customer_id;
END;


-- ��������� ��� ���������� �����
CREATE OR REPLACE PROCEDURE AddMenuItem (
    p_name IN VARCHAR2,
    p_description IN VARCHAR2,
    p_price IN NUMBER,
    p_category IN VARCHAR2
) AS
BEGIN
    INSERT INTO MenuItems (name, description, price, category)
    VALUES (p_name, p_description, p_price, p_category);
END;

-- ��������� ��� ���������� ���������� � �����
CREATE OR REPLACE PROCEDURE UpdateMenuItem (
    p_item_id IN NUMBER,
    p_name IN VARCHAR2,
    p_description IN VARCHAR2,
    p_price IN NUMBER,
    p_category IN VARCHAR2
) AS
BEGIN
    UPDATE MenuItems
    SET name = p_name,
        description = p_description,
        price = p_price,
        category = p_category
    WHERE item_id = p_item_id;
END;

-- ��������� ��� �������� �����
CREATE OR REPLACE PROCEDURE DeleteMenuItem (
    p_item_id IN NUMBER
) AS
BEGIN
    DELETE FROM MenuItems
    WHERE item_id = p_item_id;
END;


-- ��������� ��� �������� ������ ������
CREATE OR REPLACE PROCEDURE CreateOrder (
    p_customer_id IN NUMBER,
    p_total_amount IN NUMBER
) AS
BEGIN
    INSERT INTO Orders (customer_id, total_amount)
    VALUES (p_customer_id, p_total_amount);
END;

-- ��������� ��� ���������� ������� � �����
CREATE OR REPLACE PROCEDURE AddOrderItem (
    p_order_id IN NUMBER,
    p_item_id IN NUMBER,
    p_quantity IN NUMBER
) AS
BEGIN
    INSERT INTO OrderItems (order_id, item_id, quantity)
    VALUES (p_order_id, p_item_id, p_quantity);
END;

-- ��������� ��� �������� ������
CREATE OR REPLACE PROCEDURE DeleteOrder (
    p_order_id IN NUMBER
) AS
BEGIN
    DELETE FROM Orders
    WHERE order_id = p_order_id;
END;

--������������
-- ��������� ��� �������� ������������
CREATE OR REPLACE PROCEDURE ReserveTable (
    p_customer_id IN NUMBER,
    p_table_id IN NUMBER,
    p_reservation_date IN TIMESTAMP,
    p_number_of_guests IN NUMBER
) AS
BEGIN
    -- �������� ����������� �����
    IF EXISTS (SELECT 1 FROM Tables WHERE table_id = p_table_id AND status = 'Available') THEN
        -- ������� ������ � Reservations
        INSERT INTO Reservations (customer_id, table_id, reservation_date, number_of_guests)
        VALUES (p_customer_id, p_table_id, p_reservation_date, p_number_of_guests);
        
        -- ���������� ������� �����
        UPDATE Tables
        SET status = 'Reserved'
        WHERE table_id = p_table_id;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Table is not available for reservation.');
    END IF;
END;


-- ��������� ��� ������ ������������
CREATE OR REPLACE PROCEDURE CancelReservation (
    p_reservation_id IN NUMBER
) AS
BEGIN
    DECLARE
        v_table_id NUMBER;
    BEGIN
        -- ��������� �������������� �����
        SELECT table_id INTO v_table_id
        FROM Reservations
        WHERE reservation_id = p_reservation_id;

        -- �������� ������������
        DELETE FROM Reservations
        WHERE reservation_id = p_reservation_id;

        -- ���������� ������� �����
        UPDATE Tables
        SET status = 'Available'
        WHERE table_id = v_table_id;
    END;
END;

-- �������� ���������� � ������ ����� ID
CREATE OR REPLACE PROCEDURE GetOrderDetails(
    p_order_id NUMBER
) AS
BEGIN
    FOR r IN (
        SELECT oi.order_item_id, mi.name, oi.quantity, mi.price
        FROM OrderItems oi
        JOIN MenuItems mi ON oi.item_id = mi.item_id
        WHERE oi.order_id = p_order_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Item: ' || r.name || ', Quantity: ' || r.quantity || ', Price: ' || r.price);
    END LOOP;
END GetOrderDetails;