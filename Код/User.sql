create or replace package user_package as
    PROCEDURE AddOrder(
        p_customer_id NUMBER
    );
    procedure CancelOrder(
        p_customer_id NUMBER,
        p_order_id NUMBER
    );
    PROCEDURE AddItemToOrder (
        p_customer_id NUMBER,
        p_order_id NUMBER,
        p_order_item NUMBER,
        p_quantity NUMBER
    );
    PROCEDURE DeleteItemFromOrder(
        p_customer_id NUMBER,
        p_order_item_id NUMBER
    );
    PROCEDURE CreateReservation (
        p_customer_id IN NUMBER,
        p_table_id IN NUMBER,
        p_reservation_time IN TIMESTAMP
    );
    PROCEDURE DeleteReservation (
        p_customer_id IN NUMBER,
        p_table_id IN NUMBER
    );
    
end;


create or replace PACKAGE BODY user_package as

--//////////////////
--Работа с заказами
--//////////////////
PROCEDURE AddOrder 
(
    p_customer_id NUMBER
) AS
BEGIN
    INSERT INTO Orders (customer_id) VALUES (p_customer_id);
    DBMS_OUTPUT.PUT_LINE('Заказ успешно добавлен для клиента с ID: ' || p_customer_id);
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Клиент не найден.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при добавлении заказа: '  || SQLERRM);
        ROLLBACK;
        RAISE;
END AddOrder;

procedure CancelOrder
(
    p_customer_id NUMBER,
    p_order_id NUMBER
) AS
    cursor c_order_items is
    select * from OrderItems where order_id = p_order_id;
    v_amount NUMBER;
    v_price NUMBER;
    v_item_id NUMBER;
    v_quantity NUMBER;
    v_OrderCount NUMBER;
begin
     SELECT COUNT(*)
        INTO v_OrderCount
        FROM Orders
        WHERE customer_id = p_customer_id and order_id = p_order_id; 
        IF v_OrderCount > 0 THEN 
        FOR order_item IN c_order_items LOOP
        v_item_id := order_item.item_id;
        v_quantity := order_item.quantity;
        UPDATE MenuItems
        SET daily_buy = daily_buy - v_quantity,
            monthly_buy = monthly_buy - v_quantity,
            yearly_buy = yearly_buy - v_quantity,
            total_buy = total_buy - v_quantity
        WHERE item_id = v_item_id;

        END LOOP;
    select item_quantity, total_price into v_amount, v_price from Orders where order_id = p_order_id and customer_id = p_customer_id;  
    delete OrderItems where order_id = p_order_id;
    delete Orders where order_id = p_order_id;
    update Customers set order_amount = order_amount - v_amount, orders_price = orders_price - v_price where customer_id = p_customer_id;  
    commit;
    else
        dbms_output.put_line('Заказ не найден');
    END IF;
EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Неправильный ввод данных. Данные не найдены.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при отмене заказа: '  || SQLERRM);
        ROLLBACK;
        RAISE;
end;

PROCEDURE AddItemToOrder (
    p_customer_id NUMBER,
    p_order_id NUMBER,
    p_order_item NUMBER,
    p_quantity NUMBER
) as
    v_item_price NUMBER;
Begin
    select price into v_item_price from MenuItems where item_id = p_order_item;
    INSERT into OrderItems(order_id, item_id, quantity, pos_price) values(p_order_id, p_order_item, p_quantity, v_item_price * p_quantity);
    UPDATE MenuItems set daily_buy = daily_buy + p_quantity, 
                         monthly_buy = monthly_buy + p_quantity, 
                         yearly_buy = yearly_buy + p_quantity, 
                         total_buy = total_buy + p_quantity
                         where item_id = p_order_item;
    update Orders set total_price = total_price + v_item_price * p_quantity, item_quantity = item_quantity + p_quantity where order_id = p_order_id and customer_id = p_customer_id; 
    update Customers set order_amount = order_amount + p_quantity, orders_price = orders_price + v_item_price * p_quantity where customer_id = p_customer_id;  
    commit;
exception
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Дублирующее значение при вставке.');
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Данные не найдены.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Ошибка при импорте Admins: ' || SQLERRM); 
        ROLLBACK;
        RAISE;
end AddItemToOrder;

PROCEDURE DeleteItemFromOrder(
    p_customer_id NUMBER,
    p_order_item_id NUMBER
) as
    v_item_price NUMBER;
    v_quantity NUMBER;
    v_row OrderItems%ROWTYPE;
begin
    select * into v_row from OrderItems where order_item_id = p_order_item_id; 
    UPDATE MenuItems set daily_buy = daily_buy - v_row.quantity, 
                         monthly_buy = monthly_buy - v_row.quantity, 
                         yearly_buy = yearly_buy - v_row.quantity, 
                         total_buy = total_buy - v_row.quantity
                         where item_id = v_row.item_id;
    update Customers set order_amount = order_amount - v_row.quantity, orders_price = orders_price - v_row.pos_price where customer_id = p_customer_id;  
    commit;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Данные не найдены.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при добавлении блюда в заказ: '  || SQLERRM);
        ROLLBACK;
        RAISE;
end;



--///////////////////
--Бронирование стола
--///////////////////

PROCEDURE CreateReservation (
    p_customer_id IN NUMBER,
    p_table_id IN NUMBER,
    p_reservation_time IN TIMESTAMP
) IS
    v_status VARCHAR2(20);
BEGIN
    -- Проверяем статус стола
    SELECT status 
    INTO v_status 
    FROM Tables_Table 
    WHERE table_id = p_table_id;

    IF v_status = 'Taken' THEN
        DBMS_OUTPUT.PUT_LINE('Бронирование невозможно, стол с ID ' || p_table_id || ' уже занят.');
    ELSE
        -- Создаем бронирование
        INSERT INTO Reservations (customer_id, table_id, reservation_date)
        VALUES (p_customer_id, p_table_id, p_reservation_time);
        
        -- Обновляем статус стола
        UPDATE Tables
        SET status = 'Taken'
        WHERE table_id = p_table_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Бронирование успешно создано для клиента с ID ' || p_customer_id || ' на стол с ID ' || p_table_id);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Стол не найден с ID: ' || p_table_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при создании бронирования: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END CreateReservation;

PROCEDURE DeleteReservation (
    p_customer_id IN NUMBER,
    p_table_id IN NUMBER
) IS
    v_status VARCHAR2(20);
    v_ReservCount NUMBER;
BEGIN
    SELECT status 
    INTO v_status 
    FROM Tables_Table 
    WHERE table_id = p_table_id;
    IF v_status = 'Taken' then
        SELECT COUNT(*)
        INTO v_ReservCount
        FROM Reservations
        WHERE customer_id = p_customer_id and table_id = p_table_id; 
        IF v_ReservCount > 0 THEN 
            UPDATE Tables SET status = 'Available' WHERE table_id = p_table_id;
            DELETE Reservations WHERE customer_id = p_customer_id and table_id = p_table_id; 
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Cтол ' || p_table_id || ' забронирован другим пользователем.');
        end if;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Cтол ' || p_table_id || ' не забронирован');
    end if;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Бронь стола ' || p_table_id || ' не найдена');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при отмене бронирования: ' || SQLERRM);
        ROLLBACK;
        RAISE;
end;
end user_package;



drop package user_package;
