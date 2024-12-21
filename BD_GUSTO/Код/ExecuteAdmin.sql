Begin
    admin_action.AddCustomer (
    '������',
    '����������',
    '+375293333322');

    admin_action.AddCustomer (
    '����',
    '������',
    '+375295556565');
    
    admin_action.AddCustomer(
    '�����',
    '�������',
    '+375336509040'
    );
    
end;

begin 
    admin_action.ADDCustomer( '���������', '�������', '+880055535345');
end;

select * from customers;

begin 
    admin_action.UpdateCustomer(5, '������', '�������', '+880055535345');
end;


begin
    admin_action.deletecustomer(1);
    admin_action.deletecustomer(2);
    admin_action.deletecustomer(3);
end;

begin
    admin_action.updatecustomer(4, '������', '�������', '+12342123312');
end;

select * from customers;

Begin
    admin_action.addcategory(
        '������� �����',
        '��� �������'
    );
    admin_action.addcategory(
        '�������� �����',
        '��� ��������'
    );
    admin_action.addcategory(
        '�������',
        '��������'
    );
    admin_action.addcategory(
        '��������',
        '���������� ��������� �������������'
    );
end;

select * from Category;

Begin
    admin_action.addmenuitem(
        '�������',
        '������������ ������� ����� ���������� ����� �� �����, ���������� � ��������, �� ������ ������� �� ���������� ����.',
        20,
        1
    );
    
    admin_action.addmenuitem(
        '��������� �����',
        '�� ���� ��� ������.',
        10,
        1
    );
    
    admin_action.addmenuitem(
        '����',
        '����� ������ 21 ������',
        15,
        3
    );
    
    admin_action.addmenuitem(
        '�������',
        '����� ������ 2 ������',
        6,
        4
    );
end;

select * from MenuItems;

begin
    admin_action.addposition('���');
    admin_action.addposition('�����');
    admin_action.addposition('�����');
    admin_action.addposition('��������');
    admin_action.addposition('�������');
end;

select * from Positions;

begin
    admin_action.addemployee(
        '������',
        '�������',
        1,
        10000
    );
    admin_action.addemployee(
        '������',
        '�����',
        2,
        5000
    );
    admin_action.addemployee(
        '������',
        '������',
        3,
        100
    );
    admin_action.addemployee(
        '����',
        '������',
        4,
        2000
    );
    admin_action.addemployee(
        '����',
        '������',
        5,
        100
    );
end;

select * from Employees;

begin
    admin_action.addtable(4);
    admin_action.addtable(2);
    admin_action.addtable(4);
    admin_action.addtable(2);
    admin_action.addtable(6);
    admin_action.addtable(8);
end;


begin
    admin_action.assignwaitertotable(5, 4);
    admin_action.assignwaitertotable(4, 5);
end;

select * from tables;

begin
    admin_action.clearwaiterfromtable(5);
end;

begin
    admin_action.VIPCustomersPrice();
    DBMS_OUTPUT.put_line('');
    admin_action.VIPCustomersOrderItems();
end;

begin
    admin_action.dailybuystatistics();
        DBMS_OUTPUT.put_line('');
    admin_action.monthlybuystatistics();
        DBMS_OUTPUT.put_line('');
    admin_action.yearlybuystatistics();
        DBMS_OUTPUT.put_line('');
    admin_action.totalbuystatistics();
end;


begin
    FOR i IN 1..100000 LOOP
        INSERT INTO Customers_Table (first_name, last_name, phone) VALUES ('���', '�������', 375331000000 + i);
        IF MOD(i, 1000) = 0 THEN COMMIT; END IF;
    END LOOP;
    COMMIT; 
end;


select first_name from Customers where last_name = '������' or vip = '1'; 

select first_name, last_name from Customers where customer_id = '85000'; 

begin
    FOR i IN 1..100000 LOOP
        INSERT INTO Admins_Table (first_name, last_name) VALUES ('Admin', 'Adminov');
        IF MOD(i, 1000) = 0 THEN COMMIT; END IF;
    END LOOP;
    COMMIT; 
end;

begin
    sys_admin_action.ExportAdminsJSON();
end;

begin
    admin_action.ImportAdminsJSON();
end;


select count(*) from Admins;
select * from Admins;
Delete from Admins where ADMIN_ID < 200003