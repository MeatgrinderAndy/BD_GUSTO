create or replace PACKAGE admin_package AS
    PROCEDURE AddCustomer (
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_phone IN VARCHAR2
    );
    PROCEDURE DeleteCustomer (
        p_customer_id IN NUMBER
    );
    PROCEDURE UpdateCustomer (
        p_customer_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_phone IN VARCHAR2
    );
    PROCEDURE AddMenuItem (
        p_name IN VARCHAR2,
        p_description IN VARCHAR2,
        p_price IN NUMBER,
        p_category IN NUMBER
    );

    PROCEDURE UpdateMenuItem (
        p_item_id IN NUMBER,
        p_name IN VARCHAR2,
        p_description IN VARCHAR2,
        p_price IN NUMBER,
        p_category IN VARCHAR2
    );
    PROCEDURE DeleteMenuItem (
        p_item_id IN NUMBER
    );
    PROCEDURE AddCategory(
        p_category_name VARCHAR2,
        p_category_description VARCHAR2
    );   
    PROCEDURE UpdateCategory(
        p_id NUMBER,
        p_category_name VARCHAR2,
        p_category_description VARCHAR2
    );  
    PROCEDURE DeleteCategory(
        p_id NUMBER
    );
    
    PROCEDURE AddPosition(
        p_position_name VARCHAR2
    );
    PROCEDURE UpdatePosition(
        p_position_id NUMBER,
        p_position_name VARCHAR2
    );
    PROCEDURE DeletePosition(
        p_position_id NUMBER
    );
    PROCEDURE AddEmployee(
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_position_id NUMBER,
        p_salary NUMBER
    );
    PROCEDURE UpdateEmployee(
        p_employee_id NUMBER,
        p_first_name VARCHAR2,
        p_last_name VARCHAR2,
        p_position_id NUMBER,
        p_salary NUMBER
    );
    PROCEDURE AddTable (
        p_capacity IN NUMBER
    );
    PROCEDURE UpdateTable (
        p_table_id IN NUMBER,
        p_capacity IN NUMBER
    );
    PROCEDURE DeleteTable (
        p_table_id IN NUMBER
    );
    PROCEDURE AssignWaiterToTable (
        p_table_id IN NUMBER,
        p_employee_id IN NUMBER
    );
    PROCEDURE DeleteEmployee(
        p_employee_id NUMBER
    );
    PROCEDURE ClearWaiterFromTable (
        p_table_id IN NUMBER
    );
    
    PROCEDURE VIPCustomersPrice;  
    PROCEDURE VIPCustomersOrderItems; 
    PROCEDURE DailyBuyStatistics;
    PROCEDURE MonthlyBuyStatistics;
    PROCEDURE YearlyBuyStatistics;
    PROCEDURE TotalBuyStatistics;

end admin_package;

CREATE OR REPLACE TRIGGER trg_update_vip
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    IF :NEW.orders_price >= 1000 OR :NEW.order_amount >= 100 THEN
        :NEW.vip := 1;
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_update_novip
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    IF :NEW.orders_price < 1000 AND :NEW.order_amount < 100 THEN
        :NEW.vip := 0;
    END IF;
END;

--////////////////
--АДМИНСКИЙ ПАКЕТ
--////////////////
create or replace PACKAGE BODY admin_package AS

--////////
-- Клиент
--////////
PROCEDURE AddCustomer (
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_phone IN VARCHAR2
) IS
    v_UserCount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_UserCount
    FROM Customers
    WHERE first_name = p_first_name and last_name = p_last_name and phone = p_phone; 
    IF v_UserCount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Уже зарегестрирован пользователь с этими данными ');
    ELSE
        INSERT INTO Customers (first_name, last_name, phone)
        VALUES (p_first_name, p_last_name, p_phone);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Пользователь ' || p_first_name || ' ' || p_last_name || ' успешно зарегистрирован');
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при регистрации пользователя: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END AddCustomer;

PROCEDURE DeleteCustomer (
    p_customer_id IN NUMBER
) IS
BEGIN
    DELETE FROM Customers
    WHERE customer_id = p_customer_id;
    COMMIT;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Клиент не найден.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении пользователя: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;

PROCEDURE UpdateCustomer (
    p_customer_id IN NUMBER,
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_phone IN VARCHAR2
) IS
    v_UserCount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_UserCount
    FROM Customers
    WHERE first_name = p_first_name and last_name = p_last_name and phone = p_phone; 
    IF v_UserCount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Уже зарегестрирован пользователь с этими данными ');
    ELSE
    UPDATE Customers
    SET first_name = p_first_name,
        last_name = p_last_name,
        phone = p_phone
    WHERE customer_id = p_customer_id;
    COMMIT;
    END IF;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Клиент не найден.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении пользователя: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;

--////////////
--Позиции меню
--////////////
PROCEDURE AddMenuItem (
    p_name IN VARCHAR2,
    p_description IN VARCHAR2,
    p_price IN NUMBER,
    p_category IN NUMBER
) AS
    v_ItemsCount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_ItemsCount
    FROM MenuItems
    WHERE name = p_name and description = p_description and category_id = p_category; 
    IF v_ItemsCount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Уже есть точно такое же блюдо');
    ELSE
    INSERT INTO MenuItems (name, description, price, category_id)
    VALUES (p_name, p_description, p_price, p_category);
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при добавлении позиции меню: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;

PROCEDURE UpdateMenuItem (
    p_item_id IN NUMBER,
    p_name IN VARCHAR2,
    p_description IN VARCHAR2,
    p_price IN NUMBER,
    p_category IN VARCHAR2
) AS
    v_ItemsCount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_ItemsCount
    FROM MenuItems
    WHERE name = p_name and description = p_description and category_id = p_category; 
    IF v_ItemsCount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Уже есть точно такое же блюдо');
    ELSE
    UPDATE MenuItems
    SET name = p_name,
        description = p_description,
        price = p_price,
        category_id = p_category
    WHERE item_id = p_item_id;
    commit;
    end if;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Позиция меню не найдена.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении пользователя: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;

PROCEDURE DeleteMenuItem (
    p_item_id IN NUMBER
) AS
BEGIN
    DELETE FROM MenuItems
    WHERE item_id = p_item_id;
    COMMIT;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Позиция меню не найдена.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении позиции меню: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;



--//////////////
--Категории блюд
--//////////////
PROCEDURE AddCategory(
    p_category_name VARCHAR2,
    p_category_description VARCHAR2
) as
begin
    SELECT COUNT(*)
    INTO v_CategoryCount
    FROM Category
    WHERE category_name = p_category_name and category_description = p_category_description; 
    IF v_CategoryCount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Такая категория уже существует');
    ELSE
    INSERT INTO Category (category_name, category_description)
    VALUES (p_category_name, p_category_description);  
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении позиции меню: ' || SQLERRM);
        ROLLBACK;
        RAISE;
        END;
        
PROCEDURE UpdateCategory(
    p_id NUMBER,
    p_category_name VARCHAR2,
    p_category_description VARCHAR2
) AS
    v_CategoryCount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_CategoryCount
    FROM Category
    WHERE category_name = p_category_name and category_description = p_description; 
    IF v_CategoryCount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Такая категория уже существует');
        RAISE;
    ELSE
    UPDATE Category
    SET category_name = p_category_name,
        category_description = p_category_description
    WHERE category_id = p_id;
    COMMIT;
    END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Категория меню не найдена.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении позиции меню: ' || SQLERRM);
        ROLLBACK;
        RAISE;
    END;
    
PROCEDURE DeleteCategory(
    p_id NUMBER
) AS
BEGIN
    DELETE FROM Category
    WHERE category_id = p_id;
    COMMIT;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Позиция меню не найдена.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении позиции меню: ' || SQLERRM);
        ROLLBACK;
        RAISE;
    END;
    

--/////////
--Должность
--/////////
PROCEDURE AddPosition(
    p_position_name VARCHAR2
) AS
BEGIN
    INSERT INTO Positions (position_name)
    VALUES (p_position_name);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при добавлении должности: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END AddPosition;

PROCEDURE UpdatePosition(
    p_position_id NUMBER,
    p_position_name VARCHAR2
) AS
BEGIN
    UPDATE Positions
    SET position_name = p_position_name
    WHERE position_id = p_position_id;
    COMMIT;
EXCEPTION
WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Должность не найдена.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении должности: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END UpdatePosition;

PROCEDURE DeletePosition(
    p_position_id NUMBER
) AS
BEGIN
    DELETE FROM Positions
    WHERE position_id = p_position_id;
    COMMIT;
EXCEPTION
WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Должность не найдена.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении должности: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END DeletePosition;

--//////////
--Работники 
--//////////
PROCEDURE AddEmployee(
    p_first_name VARCHAR2,
    p_last_name VARCHAR2,
    p_position_id NUMBER,
    p_salary NUMBER
) AS
BEGIN
    INSERT INTO Employees (first_name, last_name, position_id, salary)
    VALUES (p_first_name, p_last_name, p_position_id, p_salary);
    commit;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при добавлении сотрудника: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END AddEmployee;

PROCEDURE UpdateEmployee(
    p_employee_id NUMBER,
    p_first_name VARCHAR2,
    p_last_name VARCHAR2,
    p_position_id NUMBER,
    p_salary NUMBER
) AS
BEGIN
    UPDATE Employees
    SET first_name = p_first_name,
        last_name = p_last_name,
        position_id = p_position_id,
        salary = p_salary
    WHERE employee_id = p_employee_id;
    COMMIT;
EXCEPTION
WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Сотрудник не найден.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении сотрудника: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END UpdateEmployee;

PROCEDURE DeleteEmployee(
    p_employee_id NUMBER
) AS
BEGIN
    DELETE FROM Employees
    WHERE employee_id = p_employee_id;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Сотрудник не найден.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении сотрудника: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END DeleteEmployee;


--///////
--Столы
--///////
PROCEDURE AddTable (
    p_capacity IN NUMBER
) IS
BEGIN
    INSERT INTO Tables ( capacity)
    VALUES ( p_capacity);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Стол успешно добавлен');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка в добавлении стола: ' || SQLERRM);
        ROLLBACK;
END AddTable;

PROCEDURE UpdateTable (
    p_table_id IN NUMBER,
    p_capacity IN NUMBER
    ) IS
BEGIN
    UPDATE Tables
    SET
        capacity = p_capacity
    WHERE table_id = p_table_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Стол не найден с ID: ' || p_table_id);
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Стол успешно обновлён: ' || p_table_id);
    END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Cтол не найден.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении стола: ' || SQLERRM);
        ROLLBACK;
END UpdateTable;

PROCEDURE DeleteTable (
    p_table_id IN NUMBER
) IS
BEGIN
    DELETE FROM Tables
    WHERE table_id = p_table_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Стол не найден с ID: ' || p_table_id);
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Стол успешно удалён: ' || p_table_id);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Стол не найден.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении стола: ' || SQLERRM);
        ROLLBACK;
END DeleteTable;

--////////////////////////////
--Официант к столу
--////////////////////////////
PROCEDURE AssignWaiterToTable (
    p_table_id IN NUMBER,
    p_employee_id IN NUMBER
) IS
    v_position_name VARCHAR2(100);
BEGIN
    SELECT position_name 
    INTO v_position_name 
    FROM Employees 
    JOIN Positions ON Employees.position_id = Positions.position_id
    WHERE employee_id = p_employee_id;

    IF v_position_name = 'Официант' THEN
        UPDATE Tables
        SET waiter = p_employee_id
        WHERE table_id = p_table_id;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Стол не найден с ID: ' || p_table_id);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Официант успешно назначен на стол с ID: ' || p_table_id);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Работник с ID ' || p_employee_id || ' не является официантом.');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Работник не найден с ID: ' || p_employee_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при назначении официанта: ' || SQLERRM);
        ROLLBACK;
END AssignWaiterToTable;

PROCEDURE ClearWaiterFromTable (
    p_table_id IN NUMBER
) IS
BEGIN
    UPDATE Tables
    SET waiter = NULL
    WHERE table_id = p_table_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Стол не найден с ID: ' || p_table_id);
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Официант успешно снят со стола с ID: ' || p_table_id);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        ROLLBACK;
END ClearWaiterFromTable;



--//////////////////
--Вывод вип клиентов
--//////////////////
PROCEDURE VIPCustomersPrice AS
BEGIN
    FOR rec IN (
        SELECT first_name, last_name, phone, orders_price
        FROM Customers_Table
        WHERE vip = 1
        ORDER BY orders_price desc
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Имя: ' || rec.first_name || 
                             ', Фамилия: ' || rec.last_name || 
                             ', Номер Телефона: ' || rec.phone || 
                             ', Общая стоимость заказов: ' || rec.orders_price);
    END LOOP;
END;

PROCEDURE VIPCustomersOrderItems AS
BEGIN
    FOR rec IN (
        SELECT first_name, last_name, phone, order_amount
        FROM Customers_Table
        WHERE vip = 1
        ORDER BY order_amount desc
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Имя: ' || rec.first_name || 
                             ', Фамилия: ' || rec.last_name || 
                             ', Номер Телефона: ' || rec.phone || 
                             ', Количество заказанных блюд: ' || rec.order_amount);
    END LOOP;
END;

--/////////////////////
--Вывод статистики блюд
--/////////////////////
PROCEDURE DailyBuyStatistics AS
BEGIN
    FOR rec IN (
        SELECT item_id, name, daily_buy
        FROM MenuItems_Table
        ORDER BY daily_buy DESC
        FETCH FIRST 10 ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID блюда: ' || rec.item_id || 
                             ', Название блюда: ' || rec.name ||  
                             ', Заказано за день: ' || rec.daily_buy);
    END LOOP;
END;


PROCEDURE MonthlyBuyStatistics AS
BEGIN
    FOR rec IN (
        SELECT item_id, name, monthly_buy
        FROM MenuItems_Table
        ORDER BY monthly_buy DESC
        FETCH FIRST 10 ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID блюда: ' || rec.item_id || 
                             ', Название блюда: ' || rec.name || 
                             ', Заказано за месяц: ' || rec.monthly_buy);
    END LOOP;
END;


PROCEDURE YearlyBuyStatistics AS
BEGIN
    FOR rec IN (
        SELECT item_id, name, yearly_buy
        FROM MenuItems_Table
        ORDER BY yearly_buy DESC
        FETCH FIRST 10 ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID блюда: ' || rec.item_id || 
                             ', Название блюда: ' || rec.name || 
                             ', Заказано за год: ' || rec.yearly_buy);
    END LOOP;
END;


PROCEDURE TotalBuyStatistics AS
BEGIN
    FOR rec IN (
        SELECT item_id, name, total_buy
        FROM MenuItems_Table
        ORDER BY total_buy DESC
        FETCH FIRST 10 ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID блюда: ' || rec.item_id || 
                             ', Название блюда: ' || rec.name || 
                             ', Заказано за все время: ' || rec.total_buy);
    END LOOP;
END;

END admin_package;



drop package admin_package;
drop trigger trg_update_vip;

