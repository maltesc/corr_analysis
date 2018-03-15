-- Correlation Analysis create database file

DROP TABLE IF EXISTS model_draft.corr_mv_lines_results;
CREATE TABLE model_draft.corr_mv_lines_results (
	name TEXT,
	bus0 TEXT,
	bus1 TEXT,
	s_nom FLOAT,
	s double precision[],
	v_nom FLOAT,
	mv_grid INT,
	result_id INT NOT NULL,
	geom geometry(LineString,4326),
	PRIMARY KEY(name, result_id, mv_grid));
ALTER TABLE model_draft.corr_mv_lines_results
	ADD COLUMN x FLOAT;
ALTER TABLE model_draft.corr_mv_lines_results
	ADD COLUMN r FLOAT;
ALTER TABLE model_draft.corr_mv_lines_results
	ADD COLUMN length FLOAT;


DROP TABLE IF EXISTS model_draft.corr_mv_bus_results;
CREATE TABLE model_draft.corr_mv_bus_results(
	name TEXT,
	control TEXT,
	type TEXT,
	v_nom double precision,
	v double precision[],
	mv_grid INT,
	result_id INT NOT NULL,	
	geom geometry(Point,4326),
	PRIMARY KEY (name, result_id, mv_grid));
ALTER TABLE model_draft.corr_mv_bus_results
	ADD COLUMN v_ang double precision[];	  
ALTER TABLE model_draft.corr_mv_bus_results
	ADD COLUMN p double precision[];
ALTER TABLE model_draft.corr_mv_bus_results
	ADD COLUMN q double precision[];

-- Etrago Result tables
CREATE TABLE IF NOT EXISTS model_draft.corr_hv_lines_results 
	AS (SELECT * FROM model_draft.ego_grid_pf_hv_result_line
		WHERE 1=2);

CREATE TABLE IF NOT EXISTS model_draft.corr_hv_lines_t_results 
	AS (SELECT * FROM model_draft.ego_grid_pf_hv_result_line_t
		WHERE 1=2);	

CREATE TABLE IF NOT EXISTS model_draft.corr_hv_bus_results 
	AS (SELECT * FROM model_draft.ego_grid_pf_hv_result_bus
		WHERE 1=2);

CREATE TABLE IF NOT EXISTS model_draft.corr_hv_bus_t_results 
	AS (SELECT * FROM model_draft.ego_grid_pf_hv_result_bus_t
		WHERE 1=2);

