CREATE OR REPLACE FUNCTION add_activity(in_title varchar(200), in_description varchar(200), in_owner_id bigint) RETURNS void AS $$
BEGIN
	
	INSERT INTO activity (id, title, description, owner_id)
	VALUES (nextval('id_generator'), in_title, in_description, in_owner_id);
	IF owner_id IS NULL THEN
    owner_id = 'Default Owner'
    END IF; 
    

END
$$ LANGUAGE SQL;