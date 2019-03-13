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

public class OrganizationMatchAPI {

	private static OrganizationMatchAPI instance = null;
	private Map<String, String> matched = new HashMap<String, String>();
	private Set<String> unmatched = new HashSet<String>();
	private final String countryField = "country";
	private final String nameField = "title";

	public String fetchCountry(String uuid) {

		// check first in the Map

		String result = matched.get(uuid);
		if (result != null) {
			return result;
		} else {
			if (unmatched.contains(uuid)) {
				return null;
			} else {
				result = "";
			}
		}

		// make connection

		URLConnection urlc;
		try {
			URL url = new URL("https://api.gbif.org/v1/organization/" + URLEncoder.encode(uuid, "UTF-8") + "");

			urlc = url.openConnection();
			// use post mode
			urlc.setDoOutput(true);
			urlc.setAllowUserInteraction(false);

			// send query
			try (BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()))) {

				// get result
				String json = br.readLine();

				JSONObject object = new JSONObject(json);
				String name = "";
				String country = Utils.NO_COUNTRY3;

				if (object.has(nameField)) {

					name = object.get(nameField) + "";
				}
				if (object.has(countryField)) {

					country = Utils.iso2CountryCodeToIso3CountryCode(object.get(countryField) + "");
				}

				String value = name + TempIO.SEPARATOR + country;
				value = value.replaceAll("\n", "");
				value = value.replaceAll("\r", "");
				result += value;
				// add result in the Map
				matched.put(uuid, value);
				return result;

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

		unmatched.add(uuid);
		return null;
	}

	public Map<String, String> getMatchedOrganizations() {
		return matched;
	}

	public Set<String> getUnmatchedOrganizations() {
		return unmatched;
	}

	public static OrganizationMatchAPI getInstance() {
		if (instance == null) {

			instance = new OrganizationMatchAPI();

			File input = new File(Executer.prop.getProperty("file.org.matched"));
			if (input.exists()) {
				try (BufferedReader reader = new BufferedReader(
						new InputStreamReader(new FileInputStream(input), "UTF-8"))) {

					String line = reader.readLine();
					while (line != null) {
						String[] values = line.split(TempIO.SEPARATOR);
						if (values.length == 2) {
							instance.matched.put(values[1], values[0]);
						}
						line = reader.readLine();
					}

				} catch (FileNotFoundException e) {
					System.out.println("File not found " + input.getAbsolutePath());
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

			System.out.println(instance.matched.size() + " taxa imported");
		}

		return instance;
	}

}
