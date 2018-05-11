
CREATE OR REPLACE FUNCTION model_draft.corr_vis_result_id (v_result_id INT) RETURNS VOID
AS $$
DECLARE 
	v_s_rel DOUBLE PRECISION;
	v_snapshot INT;
	v_s_rel_max DOUBLE PRECISION; --Maximum relative loading
	v_rel_time_over DOUBLE PRECISION; --relative time of overload (50h/100h -> 0.5)
	
BEGIN 

	-- Table for all HV lines (not from results)
	DROP TABLE IF EXISTS model_draft.corr_vis_hv_lines;
	CREATE TABLE model_draft.corr_vis_hv_lines
		AS
	(SELECT 
		l.line_id,
		b.v_nom,
		l.s_nom,
		l.topo,
		l.cables,
		l.bus0,
		l.bus1,
		l.result_id,
		v_s_rel_max AS s_rel_max,
		v_rel_time_over AS rel_time_over,
		v_s_rel AS s_rel,
		v_snapshot AS snapshot
		FROM model_draft.ego_grid_pf_hv_result_line AS l
		INNER JOIN
		model_draft.ego_grid_pf_hv_result_bus AS b
			ON l.bus0=b.bus_id
		WHERE l.result_id = v_result_id AND b.result_id = v_result_id);

	ALTER TABLE model_draft.corr_vis_hv_lines ADD COLUMN vis_id serial not null primary key;
	--ALTER TABLE model_draft.corr_vis_hv_lines ADD COLUMN rel_time_over DOUBLE PRECISION;
	ALTER TABLE model_draft.corr_vis_hv_lines ADD COLUMN max_srel DOUBLE PRECISION;
	
	-- Table for all HV buses (not from results)	
	DROP TABLE IF EXISTS model_draft.corr_vis_hv_bus;
	CREATE TABLE model_draft.corr_vis_hv_bus
		AS
	(SELECT bus_id, 
		v_nom,
		geom 
		FROM model_draft.ego_grid_pf_hv_result_bus AS b
		WHERE b.result_id = v_result_id);
	ALTER TABLE model_draft.corr_vis_hv_bus ADD COLUMN vis_id serial not null primary key;

	-- Table for all MV lines (from eDisGo results)
	DROP TABLE IF EXISTS model_draft.corr_vis_mv_lines;
	CREATE TABLE model_draft.corr_vis_mv_lines
		AS
	(SELECT 	lr.name,
			lr.v_nom,
			lr.s_nom,
			lr.mv_grid,
			lr.geom,
			lr.result_id,
			v_s_rel_max AS s_rel_max,
			v_rel_time_over AS rel_time_over,
			v_s_rel as s_rel, 
			v_snapshot AS snapshot
			
	FROM model_draft.corr_mv_lines_results AS lr
	WHERE result_id = v_result_id);
	ALTER TABLE model_draft.corr_vis_mv_lines ADD COLUMN vis_id serial not null primary key;
	--ALTER TABLE model_draft.corr_vis_mv_lines ADD COLUMN rel_time_over DOUBLE PRECISION;
	ALTER TABLE model_draft.corr_vis_mv_lines ADD COLUMN max_srel DOUBLE PRECISION;
	
	-- Table for all MV buses (from eDisGo results)
	DROP TABLE IF EXISTS model_draft.corr_vis_mv_bus;
	CREATE TABLE model_draft.corr_vis_mv_bus
		AS
	(SELECT 	br.name,
			br.type,
			br.v_nom,
			br.mv_grid,
			br.geom,
			br.result_id
			
	FROM model_draft.corr_mv_bus_results AS br
	WHERE result_id = v_result_id);

	ALTER TABLE model_draft.corr_vis_mv_bus ADD COLUMN vis_id serial not null primary key;
	
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION model_draft.corr_update_srel (
		v_snapshot INT) RETURNS VOID
AS $$
DECLARE 
	
BEGIN 

	UPDATE model_draft.corr_vis_hv_lines AS l
		SET s_rel = (SELECT abs(lt.p0[v_snapshot])/l.s_nom 
			FROM model_draft.ego_grid_pf_hv_result_line_t AS lt
			WHERE lt.result_id = l.result_id AND
			lt.line_id = l.line_id),
		snapshot = v_snapshot;
		
	UPDATE model_draft.corr_vis_mv_lines AS l
		SET s_rel = (SELECT (lt.s[v_snapshot]/1000)/l.s_nom -- Factor is here not included, cause eDisGo doesn't have this options
				FROM model_draft.corr_mv_lines_results AS lt
				WHERE lt.result_id = l.result_id AND
				lt.mv_grid = l.mv_grid AND
				lt.name = l.name),
			snapshot = v_snapshot;

END;
$$ LANGUAGE plpgsql;





