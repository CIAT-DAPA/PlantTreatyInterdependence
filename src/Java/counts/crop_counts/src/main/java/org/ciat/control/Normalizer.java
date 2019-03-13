package org.ciat.control;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;

import org.ciat.model.Basis;
import org.ciat.model.DataSourceName;
import org.ciat.model.TargetTaxa;
import org.ciat.model.TaxaMatchAPI;
import org.ciat.model.Utils;
import org.ciat.view.CountExporter;
import org.ciat.view.FileProgressBar;


public class Normalizer implements Normalizable {

	// column separator
	public static final String STANDARD_SEPARATOR = "\t";

	public static final int YEAR_MIN = 1950;
	public static final int YEAR_MAX = Calendar.getInstance().get(Calendar.YEAR);
	public static final String VALID = "";

	protected String[] values;

	// target columns
	protected static String[] colTarget = { "accessionNumber", "taxonkey", "genus", "species", "decimallongitude",
			"decimallatitude", "countrycode", "year",
			"basis", "source"};

	// index of columns
	protected Map<String, Integer> colIndex = new LinkedHashMap<String, Integer>();

	@Override
	public void process(Properties prop) {

		File input = new File(prop.getProperty("inputs/"+getDataSourceName().toString()+".csv"));
		File fileGGenusOcc = new File(prop.getProperty("outputs/g.genus.occurrences.csv"));
		File fileGSpeciesOcc = new File(prop.getProperty("outputs/g.species.occurrences.csv"));
		
		
		try (PrintWriter writerGGenusOcc = new PrintWriter(new BufferedWriter(new FileWriter(fileGGenusOcc)), true);
				PrintWriter writerGSpeciesOcc = new PrintWriter(new BufferedWriter(new FileWriter(fileGSpeciesOcc)), true);
				BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(input), "UTF-8"))) {
			
			if(!fileGGenusOcc.exists()) {
				writerGGenusOcc.println(getHeader());
			}
			if(!fileGSpeciesOcc.exists()) {
				writerGGenusOcc.println(getHeader());
			}
			

			/* header */
			String line = reader.readLine();
			colIndex = Utils.getColumnsIndex(line, getSpecificSeparator());
			/* */

			/* progress bar */
			FileProgressBar bar = new FileProgressBar(input.length());
			/* */

			line = reader.readLine();

			while (line != null) {
				line += getSpecificSeparator();
				line = line.replace("\"", "");
				values = null;
				values = line.split(getSpecificSeparator());
				if (values.length >= colIndex.size()) {
					
					String normal = normalize();

					Basis basis = getBasis();

					if (basis.equals(Basis.G)) {
						
						String taxonKey = getTaxonKey();
						boolean isTargetSpecies = taxonKey != null
								&& TargetTaxa.getInstance().getSpeciesKeys().contains(taxonKey);
						if (isTargetSpecies) {
							String species = TaxaMatchAPI.getInstance().fetchTaxonNameByID(taxonKey);
							String country = getCountry();
							boolean repat = isRepatriated();
							CountExporter.getInstance().updateCounters(species, "SPECIES", country, repat);
							writerGSpeciesOcc.println(normal);
						}

						String genus = getGenus();
						boolean isTargetGenus = genus != null && TargetTaxa.getInstance().getGenera().contains(genus);

						if (isTargetGenus) {

							String country = getCountry();
							boolean repat = isRepatriated();
							CountExporter.getInstance().updateCounters(genus, "GENUS", country, repat);
							writerGGenusOcc.println(normal);
						}
					}
				}
				/* show progress */
				bar.update(line.length());
				/* */

				line = reader.readLine();

			}
			bar.finish();

		} catch (FileNotFoundException e) {
			System.out.println("File not found " + input.getAbsolutePath());
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	@Override
	public String normalize() {
		String country = getCountry();
		String lon = getDecimalLongitude();
		String lat = getDecimalLatitude();
		Basis basis = getBasis();
		String source = getDataSourceName().toString();
		String taxonKey = getTaxonKey();
		String year = getYear();
		String accessionNumber = getAccessionNumber();
		String genus = getGenus();
		String species = getSpecies();
		String normal = accessionNumber + STANDARD_SEPARATOR + taxonKey +  STANDARD_SEPARATOR + genus +  STANDARD_SEPARATOR + species +  STANDARD_SEPARATOR + lon + STANDARD_SEPARATOR + lat + STANDARD_SEPARATOR + country
				+ STANDARD_SEPARATOR + year + STANDARD_SEPARATOR + basis + STANDARD_SEPARATOR + source;
		return normal;

	}


	/*
	 * This method works with the premise that the record is useful until otherwise
	 * is proved
	 */
	@Override
	public String validate() {

		String result = VALID;

		// remove records without country
		String country = getCountry();
		if (country == null || country == Utils.NO_COUNTRY2 || country == Utils.NO_COUNTRY3) {
			result += "NO_COUNTRY;";
		}

		// remove records with invalid coordinates
		String lon = getDecimalLongitude();
		String lat = getDecimalLatitude();
		if (!Utils.areValidCoordinates(lat, lon)) {
			result += "NO_VALID_COORDINATES;";
		}

		// remove records of H before the 1950
		Basis basis = getBasis();
		String year = getYear();
		if (!year.equals(Utils.NO_YEAR)) {
			if (basis.equals(Basis.H) && Integer.parseInt(year) < Normalizer.YEAR_MIN) {
				result += "BEFORE_1950;";
			}
		}

		return result;
	}

	public String centroidValidation() {

		String result = VALID;

		if (Utils.areValidCoordinates(getDecimalLatitude(), getDecimalLongitude())) {

			// remove records with invalid coordinates
			Double lng = Double.parseDouble(getDecimalLongitude());
			Double lat = Double.parseDouble(getDecimalLatitude());

			if (Utils.areCentroidCoordinates(lat, lng)) {
				result += "CENTROID_COORDINATES;";
			}

		}
		return result;
	}

	@Override
	public Basis getBasis() {
		return null;
	}

	@Override
	public String getYear() {
		return Utils.NO_YEAR;
	}

	@Override
	public String getTaxonKey() {
		return null;
	}

	@Override
	public String getGenus() {
		return null;
	}
	
	@Override
	public String getSpecies() {
		return null;
	}

	@Override
	public DataSourceName getDataSourceName() {
		return null;
	}

	@Override
	public String getDecimalLatitude() {
		return null;
	}

	@Override
	public String getDecimalLongitude() {
		return null;
	}

	@Override
	public String getCountry() {
		return Utils.NO_COUNTRY3;
	}

	public static String getStandardSeparator() {
		return STANDARD_SEPARATOR;
	}

	public static String getHeader() {
		String result = "";
		for (String field : colTarget) {
			result += field + STANDARD_SEPARATOR;
		}
		result = result.substring(0, result.length() - 1);
		return result;
	}

	@Override
	public String getSpecificSeparator() {
		return null;
	}

	@Override
	public boolean isRepatriated() {
		return false;
	}

	public String getAccessionNumber() {
		return null;
	}

}
