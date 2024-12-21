create or replace PACKAGE sys_admin_package AS
    PROCEDURE AddAdmin (
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2
    );
    PROCEDURE DeleteAdmin (
        p_admin_id IN NUMBER
    );
    PROCEDURE UpdateAdmin (
        p_admin_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2
    );
    PROCEDURE ExportAdminsJSON;
    PROCEDURE ImportAdminsJSON;
end;

create or replace PACKAGE body sys_admin_package as
    PROCEDURE AddAdmin (
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2
) IS
    v_UserCount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_UserCount
    FROM Admins
    WHERE first_name = p_first_name and last_name = p_last_name; 
    IF v_UserCount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Уже существует админ ' || p_first_name || ' ' || p_last_name);
    ELSE
       INSERT INTO Admins (first_name, last_name)
        VALUES (p_first_name, p_last_name);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Администратор ' || p_first_name || ' ' || p_last_name || ' успешно зарегистрирован');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при регистрации администратора: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END AddAdmin;

PROCEDURE DeleteAdmin (
    p_admin_id IN NUMBER
) IS
BEGIN
    DELETE FROM Admins
    WHERE admin_id = p_admin_id;
    DBMS_OUTPUT.PUT_LINE('Админ удален' );
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при удалении администратора: ' || sqlerrm );
        ROLLBACK;
        RAISE;
END;

PROCEDURE UpdateAdmin (
    p_admin_id IN NUMBER,
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2
) IS    
    v_UserCount NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_UserCount
    FROM Admins
    WHERE first_name = p_first_name and last_name = p_last_name; 
    IF v_UserCount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Уже существует админ ' || p_first_name || ' ' || p_last_name);
    ELSE
    UPDATE Admins
    SET first_name = p_first_name,
        last_name = p_last_name
    WHERE admin_id = p_admin_id;
        DBMS_OUTPUT.PUT_LINE('Админ изменен' );
    COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при обновлении администратора: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;

--////////////////////
--Импорт/Экспорт JSON
--////////////////////
PROCEDURE ExportAdminsJSON AS 
    l_file UTL_FILE.FILE_TYPE; 
    l_json_data CLOB; 
    v_ErrorMessage VARCHAR2(4000); 
BEGIN 
    l_file := UTL_FILE.FOPEN('JSON_DIR', 'customers.json', 'w', 32767); 
    FOR rec IN (SELECT admin_id, first_name, last_name FROM Admins) LOOP 
        l_json_data := '{"admin_id": ' || rec.admin_id || ', "first_name": "' || rec.first_name || '", "last_name": "' || rec.last_name || '"}'; 
        UTL_FILE.PUT_LINE(l_file, l_json_data); 
    END LOOP; 
    UTL_FILE.FCLOSE(l_file); 
    DBMS_OUTPUT.PUT_LINE('Экспорт таблицы завершен успешно.'); 
    COMMIT;
EXCEPTION 
    WHEN OTHERS THEN 
       v_ErrorMessage := SQLERRM; 
       DBMS_OUTPUT.PUT_LINE('Ошибка при экспорте' || sqlerrm);
       IF UTL_FILE.IS_OPEN(l_file) THEN UTL_FILE.FCLOSE(l_file); 
        END IF; 
        ROLLBACK;
        RAISE;
END; 

PROCEDURE ImportAdminsJSON AS 
    l_file UTL_FILE.FILE_TYPE; 
    l_json_data CLOB; 
    l_admin_id NUMBER;
    l_fname VARCHAR2(50); 
    l_lname VARCHAR2(50); 
    v_ErrorMessage VARCHAR2(4000); 
BEGIN 
    l_file := UTL_FILE.FOPEN('JSON_DIR', 'customers.json', 'r', 32767); 
 
    LOOP 
        BEGIN 
            UTL_FILE.GET_LINE(l_file, l_json_data); 
            SELECT JSON_VALUE(l_json_data, '$.admin_id'), JSON_VALUE(l_json_data, '$.first_name'), JSON_VALUE(l_json_data, '$.last_name')
            INTO l_admin_id, l_fname, l_lname 
            FROM DUAL; 
 
            MERGE INTO Admins r 
            USING (SELECT l_admin_id AS admin_id, l_fname AS first_name, l_lname AS last_name FROM DUAL) src 
            ON (r.admin_id = src.admin_id) 
            WHEN MATCHED THEN 
                UPDATE SET r.first_name = src.first_name,r.last_name = src.last_name  
            WHEN NOT MATCHED THEN 
                INSERT (r.admin_id, r.first_name, r.last_name) VALUES (src.admin_id, src.first_name, src.last_name); 
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN 
                EXIT; 
            WHEN OTHERS THEN 
                v_ErrorMessage := SQLERRM; 
                DBMS_OUTPUT.put_line('Ошибка при импорте Admins: ' || v_ErrorMessage || ' Данные: ' || l_json_data); 
 
                CONTINUE; 
        END; 
    END LOOP; 
    
    UTL_FILE.FCLOSE(l_file); 
 
    DBMS_OUTPUT.PUT_LINE('Импорт таблицы Admins завершен успешно.'); 
    
EXCEPTION 
    WHEN OTHERS THEN 
        v_ErrorMessage := SQLERRM; 
        DBMS_OUTPUT.put_line('Ошибка при импорте Admins: ' || v_ErrorMessage); 
        IF UTL_FILE.IS_OPEN(l_file) THEN 
            UTL_FILE.FCLOSE(l_file); 
        END IF; 
END;

end sys_admin_package;

drop package sys_admin_package;