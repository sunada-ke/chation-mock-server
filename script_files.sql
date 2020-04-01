UPDATE file_metadata f
SET directory = f.directory || '/1.0'
WHERE file_name = 'index.js'
	AND directory LIKE '%widgets%'