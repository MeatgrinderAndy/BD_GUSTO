
--Добавление админа
begin
    sys_admin_package.addadmin('ANDREW', 'KANTAROVICH');
end;

begin
    sys_admin_package.updateadmin(4, 'GUSTO', 'LINGUINI');
end;

begin
    sys_admin_package.deleteadmin(4);
end;

begin
    sys_admin_package.exportadminsjson();
end;

begin 
    sys_admin_package.importadminsjson();
end;

select * from admins;
delete from admins;

