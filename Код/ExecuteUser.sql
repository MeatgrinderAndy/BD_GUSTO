--����������� ������
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
        1, --������ ��������� �����
        1, --id ������
        2, --id �����
        100  --���������� ����
    );
end;

--���������� ������� � ������
begin
    user_action.additemtoorder
    (
        1, --������ ��������� �����
        1, --id ������
        2, --id �����
        5  --���������� ����
    );
    user_action.additemtoorder
    (
        2, --������ ��������� �����
        2, --id ������
        4, --id �����
        2  --���������� ����
    );
    user_action.additemtoorder
    (
        3, --������ ��������� �����
        3, --id ������
        3, --id �����
        100  --���������� ����
    );
    user_action.additemtoorder
    (
        85000, --������ ��������� �����
        4, --id ������
        3, --id �����
        100  --���������� ����
    );
end;

--������ ���������� �������
begin
    user_action.cancelorder(1, 1);
    user_action.cancelorder(2, 2);
    user_action.cancelorder(3, 3);   
    user_action.cancelorder(100, 1000);
end;

    
--������ vip
begin
    user_action.additemtoorder(
        5,
        21,
        1,
        50
    );
end;

--������ vip
begin
    user_action.cancelorder(5, 21);
end;

--������������ �������
begin
    user_action.createreservation(1, 4, TO_TIMESTAMP('25-12-2024 14:30', 'DD-MM-YYYY HH24:MI'));
    user_action.createreservation(2, 6, TO_TIMESTAMP('21-12-2024 17:30', 'DD-MM-YYYY HH24:MI'));
end;

--������ �����
begin
    user_action.deletereservation(2, 4);
end;

select * from Tables;
select * from Reservations;

--������� ������������ �������� �������
begin
    user_action.createreservation(2, 4, TO_TIMESTAMP('25-12-2024 14:30', 'DD-MM-YYYY HH24:MI'));
end;

