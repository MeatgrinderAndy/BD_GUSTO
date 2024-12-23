drop role gusto_user_role;

create role gusto_user_role;
GRANT CREATE SESSION TO gusto_user_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ORDERS TO gusto_user_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ORDERITEMS TO gusto_user_role;
GRANT SELECT, UPDATE ON CUSTOMERS TO gusto_user_role;
GRANT SELECT, UPDATE ON MENUITEMS TO gusto_user_role;
GRANT SELECT on TABLES to gusto_user_role;
GRANT SELECT on RESERVATIONS to gusto_user_role;


GRANT EXECUTE ON ANDREW_KANTAROVICH.user_package TO gusto_user_role;

CREATE PROFILE PF_USER LIMIT
    SESSIONS_PER_USER 5                 
    IDLE_TIME 30                         
    PASSWORD_LIFE_TIME 180                
    PASSWORD_REUSE_TIME 30               
    PASSWORD_REUSE_MAX 5                 
    FAILED_LOGIN_ATTEMPTS 3;
    
CREATE USER IVAN_IVANOV identified by 12345 profile PF_USER;
GRANT gusto_user_role to IVAN_IVANOV;
ALTER USER IVAN_IVANOV DEFAULT TABLESPACE USER_DATA;
ALTER USER IVAN_IVANOV QUOTA UNLIMITED ON RESTAURANT_DATA;
ALTER USER IVAN_IVANOV QUOTA UNLIMITED ON USER_DATA;





create role gusto_admin_role;
GRANT EXECUTE ON UTL_FILE TO gusto_admin_role;
GRANT DBA TO gusto_admin_role;
grant execute on admin_package to gusto_admin_role;
CREATE PROFILE PF_ADMIN LIMIT
    SESSIONS_PER_USER 10                 
    IDLE_TIME 60                         
    PASSWORD_LIFE_TIME 180                
    PASSWORD_REUSE_TIME 30               
    PASSWORD_REUSE_MAX 5                 
    FAILED_LOGIN_ATTEMPTS 3;
    
Create user ANDREW_KANTAROVICH identified by 12345 profile PF_ADMIN;
grant gusto_admin_role to ANDREW_KANTAROVICH;
ALTER USER ANDREW_KANTAROVICH QUOTA UNLIMITED ON SYSTEM;
ALTER USER ANDREW_KANTAROVICH DEFAULT TABLESPACE RESTAURANT_DATA;
ALTER USER ANDREW_KANTAROVICH QUOTA UNLIMITED ON RESTAURANT_DATA;
ALTER USER ANDREW_KANTAROVICH QUOTA UNLIMITED ON USER_DATA;


ALTER USER sys QUOTA UNLIMITED ON ANDREW_KANTAROVICH.RESTAURANT_DATA;
ALTER USER SYS QUOTA UNLIMITED ON ANDREW_KANTAROVICH.USER_DATA;




