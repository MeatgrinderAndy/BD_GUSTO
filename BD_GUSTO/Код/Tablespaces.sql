CREATE TABLESPACE RESTAURANT_DATA
DATAFILE '/opt/oracle/oradata/ORCLCDB/GUSTO_PDB/restaurant_data.dbf' 
SIZE 100M 
AUTOEXTEND ON 
NEXT 10M 
MAXSIZE UNLIMITED
LOGGING 
EXTENT MANAGEMENT LOCAL;

CREATE TABLESPACE USER_DATA
DATAFILE '/opt/oracle/oradata/ORCLCDB/GUSTO_PDB/user_data.dbf' 
SIZE 100M 
AUTOEXTEND ON 
NEXT 10M 
MAXSIZE UNLIMITED
LOGGING 
EXTENT MANAGEMENT LOCAL;