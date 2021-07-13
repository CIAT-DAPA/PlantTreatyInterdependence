package org.ciat.view;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedHashMap;
import java.util.Map;

import org.ciat.control.Normalizer;
import org.ciat.model.MapCounter;
public class CountExporter {

	private static CountExporter instance = null;

	private Map<String, MapCounter> columns;

	private CountExporter() {
		super();
		this.columns = new LinkedHashMap<String, MapCounter>();
		this.columns.put("total", new MapCounter());
		this.columns.put("repat", new MapCounter());
		this.columns.put("local", new MapCounter());

	}

	public Map<String, MapCounter> getCounters() {
		return columns;
	}

	public static CountExporter getInstance() {
		if (instance == null) {
			instance = new CountExporter();
		}
		return instance;
	}

	public void process() {
		exportSpeciesCounters();
	}



	private void exportSpeciesCounters() {

		// header of summary file
		File outputSummary = new File(Executer.prop.getProperty("file.counts.summary"));
		String header = "taxa" + Normalizer.getStandardSeparator();
		header += "rank" + Normalizer.getStandardSeparator();
		header += "country" + Normalizer.getStandardSeparator();

		for (String name : columns.keySet()) {
			header += name + Normalizer.getStandardSeparator();
		}

		try (PrintWriter writerSummary = new PrintWriter(new BufferedWriter(new FileWriter(outputSummary)))) {

			// print header
			writerSummary.println(header);

			// for each target taxon in the list
			for (String taxonkey : columns.get("total").keySet()) {
				String countsLine = "";
				for (String name : columns.keySet()) {
					int count = 0;
					if (columns.get(name).get(taxonkey) != null) {
						count = columns.get(name).get(taxonkey);
					}
					countsLine += count + Normalizer.getStandardSeparator();
				}

				writerSummary.println(taxonkey + Normalizer.getStandardSeparator() + countsLine);

			}
		} catch (FileNotFoundException e) {
			System.out.println("File not found " + outputSummary.getAbsolutePath());
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	public void updateCounters(String taxonkey, String rank, String country, boolean repatriated) {
		String item = taxonkey + Normalizer.getStandardSeparator() + rank + Normalizer.getStandardSeparator() + country;
		columns.get("total").increase(item);

		if (repatriated) {
			columns.get("repat").increase(item);
		} else {
			columns.get("local").increase(item);
		}

	}

}
