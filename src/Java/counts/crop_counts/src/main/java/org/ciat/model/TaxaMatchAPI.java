package org.ciat.model;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.ciat.view.Executer;
import org.ciat.view.TempIO;
import org.json.JSONObject;

public class TaxaMatchAPI {

	private static TaxaMatchAPI instance = null;
	private Map<String, String> speciesMatched = new HashMap<String, String>();
	private Set<String> speciesUnmatched = new HashSet<String>();
	private Map<String, String> genusMatched = new HashMap<String, String>();
	private Set<String> genusUnmatched = new HashSet<String>();
	private Map<String, String> keyTaxon = new HashMap<String, String>();
	private final String rankField = "rank";
	//private final String nameField = "scientificName";
	private final String keyField = "usageKey";
	private final String speciesField = "species";


	public String fetchSpeciesKey(String name) {

		// check first in the Map

		String result = speciesMatched.get(name);
		if (result != null) {
			return result;
		} else {
			if (speciesUnmatched.contains(name)) {
				return null;
			} else {
				result = "";
			}
		}

		// make connection

		URLConnection urlc;
		try {
			URL url = new URL("http://api.gbif.org/v1/species/match?kingdom=Plantae&name="
					+ URLEncoder.encode(name, "UTF-8") + "");

			urlc = url.openConnection();
			// use post mode
			urlc.setDoOutput(true);
			urlc.setAllowUserInteraction(false);

			// send query
			try (BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()))) {

				// get result
				String json = br.readLine();
				JSONObject object = new JSONObject(json);
				if (object.has(rankField) && object.has(keyField)) {
					String rank = object.get(rankField) + "";
					// check if the taxon is an specie or subspecie
					if (rank.equals("SPECIE")) {
						String value = object.get(keyField) + "";
						value = value.replaceAll("\n", "");
						value = value.replaceAll("\r", "");
						result += value;
						// add result in the Map
						speciesMatched.put(name, value);
						if (object.has(speciesField)) {
							String species = object.get(speciesField) + "";
							keyTaxon.put(value, species);
						}
						return result;
					}
				}

			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		speciesUnmatched.add(name);
		return null;
	}
	
	public String fetchGenusKey(String name) {

		// check first in the Map

		String result = genusMatched.get(name);
		if (result != null) {
			return result;
		} else {
			if (genusUnmatched.contains(name)) {
				return null;
			} else {
				result = "";
			}
		}

		// make connection

		URLConnection urlc;
		try {
			URL url = new URL("http://api.gbif.org/v1/species/match?kingdom=Plantae&name="
					+ URLEncoder.encode(name, "UTF-8") + "");

			urlc = url.openConnection();
			// use post mode
			urlc.setDoOutput(true);
			urlc.setAllowUserInteraction(false);

			// send query
			try (BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()))) {

				// get result
				String json = br.readLine();
				JSONObject object = new JSONObject(json);
				if (object.has(rankField) && object.has(keyField)) {
					String rank = object.get(rankField) + "";
					// check if the taxon is an specie or subspecie
					if (rank.equals("GENUS") ) {
						String value = object.get(keyField) + "";
						value = value.replaceAll("\n", "");
						value = value.replaceAll("\r", "");
						result += value;
						// add result in the Map
						genusMatched.put(name, value);
						return result;
					}
				}

			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		genusUnmatched.add(name);
		return null;
	}

	public String fetchTaxonNameByID(String id) {

		// check first in the Map

		String result = keyTaxon.get(id);
		if (result != null) {
			return result;
		} 
		System.out.println(keyTaxon);
		System.out.println(id);
		// make connection

		URLConnection urlc;
		try {
			URL url = new URL("http://api.gbif.org/v1/species/" + URLEncoder.encode(id, "UTF-8") + "");

			urlc = url.openConnection();
			// use post mode
			urlc.setDoOutput(true);
			urlc.setAllowUserInteraction(false);

			// send query
			try (BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()))) {

				// get result
				String json = br.readLine();

				JSONObject object = new JSONObject(json);
				if (object.has(speciesField)) {
					String species = object.get(speciesField) + "";
					keyTaxon.put(id, species);
					return species;
				}
			}

		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public Map<String, String> getMatchedSpecies() {
		return speciesMatched;
	}

	public Set<String> getUnmatchedSpecies() {
		return speciesUnmatched;
	}
	
	public Map<String, String> getMatchedGenus() {
		return genusMatched;
	}

	public Set<String> getUnmatchedGenus() {
		return genusUnmatched;
	}
	
	public Map<String, String> getKeyTaxon() {
		return keyTaxon;
	}


	public static TaxaMatchAPI getInstance() {
		if (instance == null) {

			instance = new TaxaMatchAPI();

			File inputSpecies = new File(Executer.prop.getProperty("file.species.matched"));
			if (inputSpecies.exists()) {
				try (BufferedReader reader = new BufferedReader(
						new InputStreamReader(new FileInputStream(inputSpecies), "UTF-8"))) {

					String line = reader.readLine();
					while (line != null) {
						String[] values = line.split(TempIO.SEPARATOR);
						if (values.length == 2) {
							String key = values[0];
							String name = values[1].replace('×', 'x');
							instance.speciesMatched.put(name, key);
							instance.keyTaxon.put(key, name);
						}
						line = reader.readLine();
					}

				} catch (FileNotFoundException e) {
					System.out.println("File not found " + inputSpecies.getAbsolutePath());
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

			System.out.println(instance.speciesMatched.size() + " species imported");
			
			
			File inputGenus = new File(Executer.prop.getProperty("file.genus.matched"));
			if (inputGenus.exists()) {
				try (BufferedReader reader = new BufferedReader(
						new InputStreamReader(new FileInputStream(inputGenus), "UTF-8"))) {

					String line = reader.readLine();
					while (line != null) {
						String[] values = line.split(TempIO.SEPARATOR);
						if (values.length == 2) {
							String key = values[0];
							String name = values[1].replace('×', 'x');
							instance.genusMatched.put(name, key);
						}
						line = reader.readLine();
					}

				} catch (FileNotFoundException e) {
					System.out.println("File not found " + inputGenus.getAbsolutePath());
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

			System.out.println(instance.genusMatched.size() + " genera imported");
		}

		return instance;
	}

	public void setMatchedTaxa(Map<String, String> matchedTaxa) {
		this.speciesMatched = matchedTaxa;
	}

}
