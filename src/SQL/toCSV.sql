SELECT
crop, country, "2019" as year, genus_count_institution_supply, species_count_institution_supply
FROM genesys_2018.EXPORT_FINAL_COUNTRIES;

SELECT
crop, country, "2019" as year, genus_count_origin_supply, species_count_origin_supply
FROM genesys_2018.EXPORT_FINAL_COUNTRIES;

SELECT
crop, country, "2019" as year, upov_genus_varietal_release, upov_species_varietal_release
FROM genesys_2018.EXPORT_FINAL_COUNTRIES;

SELECT
crop, country, year, genus_count_institution_supply, species_count_institution_supply
FROM genesys_2018.EXPORT_GROUP1_FINAL_WORLD;

SELECT
crop, country, year, genus_count_gbif_research_supply, species_count_gbif_research_supply
FROM genesys_2018.EXPORT_GROUP1_FINAL_WORLD;

SELECT
crop, country, year, genus_count_origin_supply, species_count_origin_supply
FROM genesys_2018.EXPORT_GROUP1_FINAL_WORLD;

SELECT
crop, country, year, upov_genus_varietal_release, upov_species_varietal_release
FROM genesys_2018.EXPORT_GROUP1_FINAL_WORLD;
