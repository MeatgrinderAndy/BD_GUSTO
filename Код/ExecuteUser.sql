--Регистрация заказа
begin
    user_action.AddOrder(1);
    user_action.AddOrder(2);
    user_action.AddOrder(3);
    user_action.AddOrder(85000);
end;


select * from Customers;
select * from Orders;
select * from Menuitems;
select * from Orderitems;

begin
    user_action.additemtoorder
    (
        1, --Клиент сделавший заказ
        1, --id заказа
        2, --id блюда
        100  --количество блюд
    );
end;

--Добавление позиции к заказу
begin
    user_action.additemtoorder
    (
        1, --Клиент сделавший заказ
        1, --id заказа
        2, --id блюда
        5  --количество блюд
    );
    user_action.additemtoorder
    (
        2, --Клиент сделавший заказ
        2, --id заказа
        4, --id блюда
        2  --количество блюд
    );
    user_action.additemtoorder
    (
        3, --Клиент сделавший заказ
        3, --id заказа
        3, --id блюда
        100  --количество блюд
    );
    user_action.additemtoorder
    (
        85000, --Клиент сделавший заказ
        4, --id заказа
        3, --id блюда
        100  --количество блюд
    );
end;

--Отмена клиентских заказов
begin
    user_action.cancelorder(1, 1);
    user_action.cancelorder(2, 2);
    user_action.cancelorder(3, 3);   
    user_action.cancelorder(100, 1000);
end;

    
--Выдача vip
begin
    user_action.additemtoorder(
        5,
        21,
        1,
        50
    );
end;

--Отмена vip
begin
    user_action.cancelorder(5, 21);
end;

--Бронирование столика
begin
    user_action.createreservation(1, 4, TO_TIMESTAMP('25-12-2024 14:30', 'DD-MM-YYYY HH24:MI'));
    user_action.createreservation(2, 6, TO_TIMESTAMP('21-12-2024 17:30', 'DD-MM-YYYY HH24:MI'));
end;

--Отмена брони
begin
    user_action.deletereservation(2, 4);
end;

select * from Tables;
select * from Reservations;

--Попытка бронирования занятого столика
begin
    user_action.createreservation(2, 4, TO_TIMESTAMP('25-12-2024 14:30', 'DD-MM-YYYY HH24:MI'));
end;

