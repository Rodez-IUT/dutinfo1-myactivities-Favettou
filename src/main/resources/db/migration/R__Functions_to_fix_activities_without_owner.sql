CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$
DECLARE
    defaultOwner "user"%rowtype;
    defaultOwnerUsername varchar(500) := 'Default Owner';
BEGIN
    SELECT *
    INTO defaultOwner 
    FROM "user"
    WHERE username = DefaultOwnerUsername;
    IF NOT FOUND THEN
        INSERT INTO "user" (id, username)
        VALUES (nextval('id_generator'), defaultOwnerUsername);
        SELECT *
        INTO defaultOwner
        FROM "user"
        Where username = defaultOwnerUsername;
    END IF;
RETURN defaultOwner;
END
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION fix_activities_without_owner() RETURNS SETOF activity AS $$
    BEGIN
        UPDATE activity
        SET owner_id = (SELECT id FROM "user" WHERE username = 'Default Owner')
        WHERE owner_id IS NULL;
        RETURN QUERY SELECT * FROM activity WHERE owner_id = (SELECT id FROM "user" WHERE username = 'Default Owner');
     
        RETURN;
    END
    $$ LANGUAGE plpgsql;
    
    
    
    
    
    