-- Quick DB queries

-- Generators
SELECT * FROM model_draft.ego_grid_pf_hv_result_generator
	WHERE 	result_id = 9 AND
		bus = 23971 AND
		source = 12
		

SELECT * FROM model_draft.ego_grid_pf_hv_generator AS gens 
	INNER JOIN  model_draft.ego_grid_pf_hv_result_generator AS res_gens
	ON gens.generator_id = res_gens.generator_id
	WHERE res_gens.result_id = 9 AND
		gens.bus = 23971

	-- All single (not aggregated) Generators

SELECT *FROM model_draft.ego_supply_pf_generator_single

	where
	aggr_id = 920 and
	bus = 23971
	(aggr_id = 920 OR aggr_id = 924)
	
LIMIT 100
	WHERE aggr_id = 31355

16597    solar  1134088

SELECT DISTINCT source 
	FROM model_draft.ego_supply_pf_generator_single WHERE NOT w_id IS NULL 
LIMIT 100 WHERE source = 9

SELECT DISTINCT w_id FROM model_draft.ego_supply_pf_generator_single -- An aggregated wind gen is generator_id = 2855
	WHERE aggr_id = 2855
	AND scn_name = 'NEP 2035'
		


-- Sources
SELECT * FROM model_draft.ego_grid_pf_hv_source

-- Metadata on result
SELECT * FROM model_draft.ego_grid_pf_hv_result_meta
	WHERE result_id = 9 --9 is NEP 2035

-- Storage

	-- All Gens (for Storage)
SELECT * FROM model_draft.ego_supply_conv_powerplant
	WHERE fuel = 'pumped_storage'
SELECT * FROM model_draft.ego_supply_conv_powerplant_2035
	WHERE fuel = 'pumped_storage'

	-- All storage devices (DP)
SELECT * FROM model_draft.ego_supply_pf_storage_single

	-- Result storages
SELECT * FROM model_draft.ego_grid_pf_hv_result_storage
	WHERE 	NOT p_nom_opt = 0
		bus = 57

SELECT * FROM model_draft.ego_grid_pf_hv_result_storage_t
	WHERE 	NOT p = '{0,0}'
		storage_id = 200001


-- Specs Grid assignment

SELECT subst_id FROM model_draft.ego_grid_hvmv_substation
	WHERE otg_id = 27334

SELECT * FROM grid.ego_dp_mv_griddistrict LIMIT 100

--New weather ID
--------------------
	-- All storage devices (DP)
CREATE TABLE model_draft.ego_supply_aggr_weather
	AS
	(SELECT DISTINCT
			aggr_id,
			w_id, 
			scn_name, 
			bus FROM model_draft.ego_supply_pf_generator_single);
ALTER TABLE model_draft.ego_supply_aggr_weather ADD COLUMN idx SERIAL PRIMARY KEY;

--------------------------------
CREATE MATERIALIZED VIEW model_draft.ego_supply_aggr_weather_mview
	AS
	(SELECT DISTINCT
			ROW_NUMBER() OVER () AS row_number,
			aggr_id,
			w_id, 
			scn_name, 
			bus FROM model_draft.ego_supply_pf_generator_single);

CREATE MATERIALIZED VIEW model_draft.ego_supply_aggr_weather_mview 
AS 
(WITH w_sub AS (
 SELECT DISTINCT
	aggr_id,
	w_id, 
	scn_name, 
	bus
		FROM
		model_draft.ego_supply_pf_generator_single
	) SELECT
		aggr_id,
		w_id,
		scn_name,
		bus,
		ROW_NUMBER () OVER (ORDER BY aggr_id) as row_number
			FROM
			w_sub);
 	
			------------------

Drop materialized view model_draft.ego_supply_aggr_weather_mview

SELECT * FROM model_draft.ego_supply_aggr_weather 
	WHERE aggr_id = 920

DROP TABLE model_draft.ego_supply_aggr_weather
------------------------

SELECT * FROM model_draft.ego_supply_pf_generator_single
	WHERE scn_name = 'NEP 2035' AND
		aggr_id = 924

SELECT * FROM model_draft.ego_grid_pf_hv_result_generator 
	WHERE 	result_id = 9 AND
		bus = 23971


Drop materialized view model_draft.ego_grid_pf_result_mview




SELECT * FROM model_draft.ego_grid_pf_hv_line
WHERE line_id = 13722 AND
scn_name = 'SH Status Quo';

SELECT * FROM model_draft.ego_grid_pf_hv_bus
WHERE bus_id = 13450 AND
scn_name = 'SH Status Quo'

