package org.ciat.view;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import java.util.Set;

public class TempIO {

	public static final String SEPARATOR = "\t";

	public static void exportMatched(Map<String, String> matched, File output) {
		try (PrintWriter writer = new PrintWriter(new BufferedWriter(new FileWriter(output)))) {

			for (String name : matched.keySet()) {
				writer.println(matched.get(name) + SEPARATOR + name);
			}

		} catch (FileNotFoundException e) {
			System.out.println("File not found: " + output);
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	public static void exportUnmatched(Set<String> unmatched, File output) {
		try (PrintWriter writer = new PrintWriter(new BufferedWriter(new FileWriter(output)))) {

			for (String name : unmatched) {
				writer.println(name);
			}

		} catch (IOException e) {
			e.printStackTrace();
		}

	}

}
