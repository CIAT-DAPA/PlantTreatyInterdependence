package org.ciat.model;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;

import java.util.Set;
import java.util.TreeSet;

import org.ciat.view.Executer;

public class TargetTaxa {

	private static TargetTaxa instance = null;
	private Set<String> species = new TreeSet<String>();
	private Set<String> genera = new TreeSet<String>();

	private TargetTaxa() {
		super();
		this.species = loadTargetSpecies(new File(Executer.prop.getProperty("resource.species")));
		this.genera = loadTargetGenera(new File(Executer.prop.getProperty("resource.genera")));
	}

	public Set<String> getSpecies() {
		return species;
	}

	public Set<String> getGenera() {
		return genera;
	}

	public static TargetTaxa getInstance() {
		if (instance == null) {
			instance = new TargetTaxa();
		}
		return instance;
	}

	private Set<String> loadTargetSpecies(File file) {
		Set<String> filters = new TreeSet<String>();
		try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file)))) {

			String line = reader.readLine();
			while (line != null) {
				filters.add(line);
				line = reader.readLine();
			}

		} catch (FileNotFoundException e) {
			System.out.println("File not found " + file.getAbsolutePath());
		} catch (IOException e) {
			System.out.println("Cannot read " + file.getAbsolutePath());
		}
		System.out.println(filters.size() + " target species");
		return filters;
	}

	private Set<String> loadTargetGenera(File file) {
		Set<String> filters = new TreeSet<String>();
		try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file)))) {

			String line = reader.readLine();
			while (line != null) {
				filters.add(line);
				line = reader.readLine();
			}

		} catch (FileNotFoundException e) {
			System.out.println("File not found " + file.getAbsolutePath());
		} catch (IOException e) {
			System.out.println("Cannot read " + file.getAbsolutePath());
		}

		System.out.println(filters.size() + " target genus");
		return filters;
	}

}
