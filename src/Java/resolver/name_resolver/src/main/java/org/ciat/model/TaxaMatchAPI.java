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
	private Map<String, NameUsage> speciesMatched = new HashMap<String, NameUsage>();
	private Set<String> speciesUnmatched = new HashSet<String>();
	private Map<String, NameUsage> genusMatched = new HashMap<String, NameUsage>();
	private Set<String> genusUnmatched = new HashSet<String>();
	private Map<String, NameUsage> keyTaxon = new HashMap<String, NameUsage>();
	private final String rankField = "rank";
	// private final String nameField = "scientificName";
	private final String usageKeyField = "usageKey";
	private final String speciesField = "species";
	private final String genusField = "genus";
	private final String statusField = "status";
	// private final String canonicalNameField = "canonicalName";
	private final String scientificNameField = "scientificName";

	public NameUsage fetchSpeciesKey(String name) {

		// check first in the Map

		NameUsage result = speciesMatched.get(name);
		if (result != null) {
			return result;
		} else {
			if (speciesUnmatched.contains(name)) {
				return null;
			} else {
				result = new NameUsage("", "", "", "", "SPECIES", "");
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
				if (object.has(rankField) && object.has(usageKeyField)) {
					String rank = object.get(rankField) + "";
					// check if the taxon is an specie or subspecie
					if (rank.equals("SPECIE") || rank.equals("SUBSPECIE")) {
						String usageKey = object.has(usageKeyField) ? object.get(usageKeyField) + "" : "";
						String status = object.has(statusField) ? object.get(statusField) + "" : "";
						String genusName = object.has(genusField) ? object.get(genusField) + "" : "";
						String speciesName = object.has(speciesField) ? object.get(speciesField) + "" : "";
						String scientificName = object.has(speciesField) ? object.get(scientificNameField) + "": "";

						result = new NameUsage(usageKey, scientificName, genusName, speciesName, rank, status);
						// add result in the Map
						speciesMatched.put(name, result);

						keyTaxon.put(usageKey, result);
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

	public NameUsage fetchGenusKey(String name) {

		// check first in the Map

		NameUsage result = genusMatched.get(name);
		if (result != null) {
			return result;
		} else {
			if (genusUnmatched.contains(name)) {
				return null;
			} else {
				result = new NameUsage("", "", "", "", "GENUS", "");
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
				if (object.has(rankField) && object.has(usageKeyField)) {
					String rank = object.get(rankField) + "";
					// check if the taxon is a genus
					if (rank.equals("GENUS")) {
						String usageKey = object.has(usageKeyField) ? object.get(usageKeyField) + "" : "";
						String status = object.has(statusField) ? object.get(statusField) + "" : "";
						String genusName = object.has(genusField) ? object.get(genusField) + "" : "";
						String scientificName = object.has(speciesField) ? object.get(scientificNameField) + "": "";


						result = new NameUsage(usageKey, scientificName, genusName, "", rank, status);
						// add result in the Map
						genusMatched.put(name, result);
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

	public String fetchSpeciesNameByID(String id) {

		// check first in the Map

		String result = keyTaxon.get(id).getSpeciesName();
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
					String usageKey = object.has("nubkey") ? object.get("nubkey") + "" : "";
					String status = object.has("taxonomicStatus") ? object.get("taxonomicStatus") + "" : "";
					String genusName = object.has(genusField) ? object.get(genusField) + "" : "";
					String speciesName = object.has(speciesField) ? object.get(speciesField) + "" : "";
					String scientificName = object.has(speciesField) ? object.get(scientificNameField) + "": "";
					String rank = object.get(rankField) + "";


					NameUsage resultName = new NameUsage(usageKey, scientificName, genusName, speciesName, rank,
							status);
					keyTaxon.put(id, resultName);
					return speciesName;
				}
			}

		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public Map<String, NameUsage> getMatchedSpecies() {
		return speciesMatched;
	}

	public Set<String> getUnmatchedSpecies() {
		return speciesUnmatched;
	}

	public Map<String, NameUsage> getMatchedGenus() {
		return genusMatched;
	}

	public Set<String> getUnmatchedGenus() {
		return genusUnmatched;
	}

	public Map<String, NameUsage> getKeyTaxon() {
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
						if (values.length < 6) {
							NameUsage usage = new NameUsage(values[1], values[2], values[3], values[4], values[5],
									values[6]);
							instance.speciesMatched.put(values[0], usage);
							instance.keyTaxon.put(values[1], usage);
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
						if (values.length < 6) {
							NameUsage usage = new NameUsage(values[1], values[2], values[3], values[4], values[5],
									values[6]);
							instance.genusMatched.put(values[0], usage);
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

	public void setMatchedTaxa(Map<String, NameUsage> matchedTaxa) {
		this.speciesMatched = matchedTaxa;
	}

}
