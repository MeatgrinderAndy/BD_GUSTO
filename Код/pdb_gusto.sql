//Создание
create PLUGGABLE DATABASE GUSTO_PDB
    admin user admin_user identified by gust0admin88
    file_name_convert = ( '/opt/oracle/oradata/ORCLCDB/pdbseed/', '/opt/oracle/oradata/ORCLCDB/GUSTO_PDB/');

alter pluggable database GUSTO_PDB open;

select pdb_name, status from dba_pdbs;

