DROP FUNCTION IF EXISTS  register_user_on_activity(bigint,bigint);

CREATE OR REPLACE FUNCTION register_user_on_activity(in_user_id bigint, in_activity_id bigint) 
RETURNS registration AS $$
DECLARE
	res_registration registration%rowtype;
BEGIN
	SELECT * 
	INTO res_registration
	FROM registration
	WHERE user_id = in_user_id AND activity_id = in_activity_id;
	
	IF FOUND THEN
		raise exception 'registration_already_exists';
	END IF;
	
	INSERT INTO registration(id, user_id, activity_id)
	VALUES (nextval('id_generator'), in_user_id, in_activity_id);
	
	SELECT *
	INTO res_registration
	FROM registration
	WHERE user_id = in_user_id AND activity_id = in_activity_id;
	return res_registration;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION unregister_user_on_activity(in_user_id bigint, in_activity_id bigint) 
RETURNS void AS $$
DECLARE
	res_registration registration%rowtype;
BEGIN
	SELECT * 
	INTO res_registration
	FROM registration
	WHERE user_id = in_user_id AND activity_id = in_activity_id;
	
	IF NOT FOUND THEN
		raise exception 'registration_not_found';
	END IF;
	
	DELETE FROM registration
	WHERE user_id = in_user_id AND activity_id = in_activity_id;

END;
$$ LANGUAGE plpgsql;

