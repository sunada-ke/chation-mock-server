CREATE OR REPLACE FUNCTION lvm_migration_widgetUrl_replace ()
RETURNS integer AS $NUM$
DECLARE
	NUM integer:=0;
	LEN integer;
	FILE_DOMAIN text:='/index.js';
	BASE_URL text:='/1.0/index.js';
BEGIN
	LEN = (select max(json_array_length(pl.layout)) from page_layouts as pl);
	WHILE NUM < LEN LOOP
		UPDATE page_layouts AS pl SET layout = jsonb_set((pl.layout)::jsonb,('{'||NUM||',widgetUrl}')::text[],to_json(REPLACE(pl.layout->NUM->>'widgetUrl',FILE_DOMAIN,BASE_URL))::jsonb,false) WHERE json_array_length(pl.layout) > NUM AND pl.layout->NUM->>'type' <> 'WCContainer' AND pl.layout->NUM->>'type' <> 'WCContent' AND pl.layout->NUM->>'type' <> 'WCBlankBoard';
		NUM = NUM + 1;
    END LOOP;
    RETURN NUM;
END
$NUM$ LANGUAGE plpgsql;

--call defined stored procedure
SELECT lvm_migration_widgetUrl_replace();


--add column
ALTER TABLE public.page_layouts
    ADD COLUMN widgets_load_sort json DEFAULT '[]';