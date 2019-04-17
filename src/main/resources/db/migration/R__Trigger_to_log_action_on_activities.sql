drop trigger if exists trigger_action_log on activity;
drop trigger if exists trigger_registration_man on registration;

CREATE OR REPLACE FUNCTION action_log() RETURNS TRIGGER AS $$
	
BEGIN
	
	INSERT INTO action_log(id, action_name, entity_name, entity_id, author, action_date)
	VALUES(nextval('id_generator'), lower(TG_OP), TG_RELNAME, OLD.id, current_user, now());
	RETURN NULL;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_action_log
	AFTER DELETE ON activity
	FOR EACH ROW EXECUTE PROCEDURE action_log();

---------------------------------------------------------------------------------------------
	
CREATE OR REPLACE FUNCTION registration_man() RETURNS TRIGGER AS $$

	
BEGIN
    IF (TG_OP = 'INSERT') THEN
	INSERT INTO action_log(id, action_name, entity_name, entity_id, author, action_date)
	VALUES(nextval('id_generator'), lower(TG_OP), TG_RELNAME, NEW.id, current_user, now());
	RETURN NULL;
	ELSIF (TG_OP = 'DELETE') THEN
	INSERT INTO action_log(id, action_name, entity_name, entity_id, author, action_date)
	VALUES(nextval('id_generator'), lower(TG_OP), TG_RELNAME, OLD.id, current_user, now());
	RETURN NULL;
	END IF;
	

END;
$$ LANGUAGE plpgsql;
	
CREATE TRIGGER trigger_registration_man
	AFTER DELETE OR INSERT ON registration
	FOR EACH ROW EXECUTE PROCEDURE registration_man();
        
