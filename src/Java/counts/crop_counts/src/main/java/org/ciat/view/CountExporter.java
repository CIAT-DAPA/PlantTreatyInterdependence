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
import org.ciat.model.TaxaMatchAPI;
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
		exportDatasetCounters();
	}

	private void exportDatasetCounters() {
		File output = new File(Executer.prop.getProperty("file.taxa.summary"));
		try (PrintWriter writer = new PrintWriter(new BufferedWriter(new FileWriter(output)))) {
			writer.println("species.matched" + Normalizer.getStandardSeparator() + "species.unmatched");
			writer.println(TaxaMatchAPI.getInstance().getMatchedTaxa().keySet().size()
					+ Normalizer.getStandardSeparator() + TaxaMatchAPI.getInstance().getUnmatchedTaxa().size());

		} catch (FileNotFoundException e) {
			System.out.println("File not found " + output.getAbsolutePath());
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	private void exportSpeciesCounters() {

		// header of summary file
		File outputSummary = new File(Executer.prop.getProperty("file.counts.summary"));
		String header = "";

		for (String name : columns.keySet()) {
			header += name + Normalizer.getStandardSeparator();
		}

		try (PrintWriter writerSummary = new PrintWriter(new BufferedWriter(new FileWriter(outputSummary)))) {

			// print header
			writerSummary.println("taxonkey" + Normalizer.getStandardSeparator() + header);

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

	public void updateCounters(String taxonkey, String country, boolean repatriated) {
		String item = taxonkey + Normalizer.getStandardSeparator() + country;
		columns.get("total").increase(item);

		if (repatriated) {
			columns.get("repat").increase(item);
		} else {
			columns.get("local").increase(item);
		}

	}

}
