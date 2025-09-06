DECLARE
    v_owners SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('CMS_NOTIFICATION','GO_CONNECT','CMS_GLOBAL','CMS_AUDIT','CMS_CARD','CMS_CARD_MGMT','CMS_SUPPORT','CMS_USER_ADMIN','CMS_PROGRAM_CFG');  -- Source schemas
    v_target_user VARCHAR2(100) := 'BLAZE';  -- Target user to receive access
BEGIN
    FOR i IN 1 .. v_owners.COUNT LOOP

        -- Grant EXECUTE on functions
        FOR obj IN (
            SELECT object_name
            FROM all_objects
            WHERE owner = v_owners(i)
              AND object_type = 'FUNCTION'
        ) LOOP
            EXECUTE IMMEDIATE 'GRANT EXECUTE ON ' || v_owners(i) || '.' || obj.object_name || ' TO ' || v_target_user;
        END LOOP;

        -- Grant SELECT on sequences
        FOR seq IN (
            SELECT sequence_name
            FROM all_sequences
            WHERE sequence_owner = v_owners(i)
        ) LOOP
            EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_owners(i) || '.' || seq.sequence_name || ' TO ' || v_target_user;
        END LOOP;

        -- Grant SELECT on tables
        FOR tbl IN (
            SELECT table_name
            FROM all_tables
            WHERE owner = v_owners(i)
        ) LOOP
            EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ' || v_owners(i) || '.' || tbl.table_name || ' TO ' || v_target_user;
        END LOOP;

        -- Optional: Grant EXECUTE on procedures
        FOR proc IN (
            SELECT object_name
            FROM all_objects
            WHERE owner = v_owners(i)
              AND object_type = 'PROCEDURE'
        ) LOOP
            EXECUTE IMMEDIATE 'GRANT EXECUTE ON ' || v_owners(i) || '.' || proc.object_name || ' TO ' || v_target_user;
        END LOOP;

        -- Optional: Grant EXECUTE on packages
        FOR pkg IN (
            SELECT object_name
            FROM all_objects
            WHERE owner = v_owners(i)
              AND object_type = 'PACKAGE'
        ) LOOP
            EXECUTE IMMEDIATE 'GRANT EXECUTE ON ' || v_owners(i) || '.' || pkg.object_name || ' TO ' || v_target_user;
        END LOOP;

        -- Optional: Grant SELECT on views
        FOR vw IN (
            SELECT object_name
            FROM all_objects
            WHERE owner = v_owners(i)
              AND object_type = 'VIEW'
        ) LOOP
            EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_owners(i) || '.' || vw.object_name || ' TO ' || v_target_user;
        END LOOP;

    END LOOP;
END;
/   
   