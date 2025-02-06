-- Functions:
CREATE OR REPLACE FUNCTION get_pokemon_name(
	pokemon_game_name VARCHAR
)
RETURNS VARCHAR
LANGUAGE plpgsql
AS 
$$
DECLARE
	pokemon_name VARCHAR;
BEGIN
	IF pokemon_game_name NOT LIKE '%(%)' THEN
		RETURN pokemon_game_name;
	END IF
	;
	
	pokemon_name := substring(pokemon_game_name FROM '\(([^()]+)\)');
		
	IF pokemon_name = 'M' OR pokemon_name = 'F' THEN
		pokemon_name := (regexp_replace(pokemon_game_name, '\(.\)', ''));
	END IF
	;
	
	RETURN pokemon_name;
	
END;
$$
;


-- Alter Tables

-- pokedex
ALTER TABLE pokedex 
DROP COLUMN IF EXISTS num
;

-- moves
ALTER TABLE moves 
DROP CONSTRAINT IF EXISTS pk_moves
;
ALTER TABLE moves 
ADD CONSTRAINT pk_moves PRIMARY KEY (num)
;

-- items
ALTER TABLE items 
DROP CONSTRAINT IF EXISTS pk_items
;
ALTER TABLE items 
ADD CONSTRAINT pk_items PRIMARY KEY (item_name)
;
ALTER TABLE items 
DROP COLUMN IF EXISTS num
;

-- competitive_pokemon
ALTER TABLE competitive_pokemon 
RENAME COLUMN pokemon_name TO game_name
;
ALTER TABLE competitive_pokemon
DROP COLUMN IF EXISTS pokemon_name
;
ALTER TABLE competitive_pokemon
ADD COLUMN pokemon_name VARCHAR
;
INSERT INTO competitive_pokemon(pokemon_name)
SELECT 
	get_pokemon_name(pokemon_name) AS "name"
FROM competitive_pokemon
;

--Test Queries
SELECT 
	*
	--get_pokemon_name(pokemon_name) AS "name"
FROM competitive_pokemon
--WHERE gen_introduced IS NULL
--WHERE pp ILIKE '%—%'
;

/*
SELECT 
	--get_pokemon_name(pokemon_name) AS "name"
FROM competitive_pokemon
;
*/



