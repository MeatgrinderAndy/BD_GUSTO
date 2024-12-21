
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'reset_daily_buy',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN Clear_Day; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval  => 'FREQ=DAILY; BYHOUR=0; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );

    DBMS_SCHEDULER.create_job (
        job_name        => 'reset_monthly_buy',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN Clear_Month; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval  => 'FREQ=MONTHLY; BYMONTHDAY=1; BYHOUR=0; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );

    DBMS_SCHEDULER.create_job (
        job_name        => 'reset_yearly_buy',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN Clear_Year; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval  => 'FREQ=YEARLY; BYMONTH=1; BYMONTHDAY=1; BYHOUR=0; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
    
    DBMS_SCHEDULER.create_job (
       job_name        => 'clear_orders_sched',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN Clear_Orders; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval  => 'FREQ=DAILY; BYHOUR=5; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
    
    DBMS_SCHEDULER.create_job (
       job_name        => 'clear_old_reservs',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN Clear_Old_Reservation; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval  => 'FREQ=DAILY; BYHOUR=5; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
END;


--////////////////
--Сброс статистики
--////////////////

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'reset_daily_buy',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN Clear_Day; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval  => 'FREQ=DAILY; BYHOUR=0; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
END; 

create or replace PROCEDURE Clear_Day(
    p_item_id number
) as
    item_name VARCHAR2(50);
    buy_number number;
begin
    select name into item_name from MenuItems where item_id = p_item_id;
    select daily_buy into buy_number from MenuItems where item_id = p_item_id;
    
    dbms_output.put_line('За день блюдо ' || item_name || ' было продано ' || buy_number || ' раз.');
    update MenuItems
    set daily_buy = 0 where item_id = p_item_id;
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        ROLLBACK;
        RAISE;
end;

create or replace PROCEDURE Clear_Month(
    p_item_id number
) as
    item_name VARCHAR2(50);
    buy_number number;
begin
    select name into item_name from MenuItems where item_id = p_item_id;
    select monthly_buy into buy_number from MenuItems where item_id = p_item_id;
    
    dbms_output.put_line('За месяц блюдо ' || item_name || ' было продано ' || buy_number || ' раз.');
    update MenuItems
    set monthly_buy = 0 where item_id = p_item_id;
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        ROLLBACK;
        RAISE;
end;

create or replace PROCEDURE Clear_Year(
    p_item_id number
) as
    item_name VARCHAR2(50);
    buy_number number;
begin
    select name into item_name from MenuItems where item_id = p_item_id;
    select yearly_buy into buy_number from MenuItems where item_id = p_item_id;
    
    dbms_output.put_line('За год блюдо ' || item_name || ' было продано ' || buy_number || ' раз.');
    update MenuItems
    set yearly_buy = 0 where item_id = p_item_id;
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        ROLLBACK;
        RAISE;
end;

create or replace PROCEDURE Clear_Total(
    p_item_id number
) as
    item_name VARCHAR2(50);
    buy_number number;
begin
    select name into item_name from MenuItems where item_id = p_item_id;
    select total_buy into buy_number from MenuItems where item_id = p_item_id;
    
    dbms_output.put_line('За все время блюдо ' || item_name || ' было продано ' || buy_number || ' раз.');
    update MenuItems
    set total_buy = 0 where item_id = p_item_id;
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        ROLLBACK;
        RAISE;
end;

create or replace PROCEDURE Clear_Orders as
begin
    DELETE FROM OrderItems;
    DELETE FROM Orders;
    Commit;
end;

create or replace PROCEDURE Clear_Old_Reservation as
begin
    DELETE FROM Reservations where reservation_date < SYSTIMESTAMP - INTERVAL '24' HOUR;
    Commit;
end;

