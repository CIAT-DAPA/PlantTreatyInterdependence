package org.ciat.control;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Properties;


import org.ciat.model.TaxaMatchAPI;
import org.ciat.view.Executable;
import org.ciat.view.Executer;
import org.ciat.view.FileProgressBar;
import org.ciat.view.TempIO;

public class Resolver extends Executer {
	public static final String STANDARD_SEPARATOR = "\t";

	public static void main(String[] args) {
		Executable app = new Resolver();
		app.run();
	}

	public void run() {

		log("Starting process");

		processGenus(prop);
		processSpecies(prop);
	
		// export taxa
		log("Exporting taxa");
		TempIO.exportMatched(TaxaMatchAPI.getInstance().getMatchedSpecies(),new File(prop.getProperty("file.species.matched")));
		TempIO.exportUnmatched(TaxaMatchAPI.getInstance().getUnmatchedSpecies(),new File(prop.getProperty("file.species.unmatched")));
		
		// export taxa
		log("Exporting taxa");
		TempIO.exportMatched(TaxaMatchAPI.getInstance().getMatchedGenus(),new File(prop.getProperty("file.genus.matched")));
		TempIO.exportUnmatched(TaxaMatchAPI.getInstance().getUnmatchedGenus(),new File(prop.getProperty("file.genus.unmatched")));
		

		

	}
	
	public void processGenus(Properties prop) {

		File input = new File(prop.getProperty("file.genus"));

		TaxaMatchAPI.getInstance();

		try (BufferedReader reader = new BufferedReader(
						new InputStreamReader(new FileInputStream(input), "UTF-8"))) {


			/* header */
			String line = reader.readLine();
			/* */

			/* progress bar */
			FileProgressBar bar = new FileProgressBar(input.length());
			/* */

			line = reader.readLine();

			while (line != null) {
				line = line.replace("\"", "");
				TaxaMatchAPI.getInstance().fetchGenusKey(line);
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
	
	public void processSpecies(Properties prop) {

		File input = new File(prop.getProperty("file.species"));

		TaxaMatchAPI.getInstance();

		try (BufferedReader reader = new BufferedReader(
						new InputStreamReader(new FileInputStream(input), "UTF-8"))) {


			/* header */
			String line = reader.readLine();
			/* */

			/* progress bar */
			FileProgressBar bar = new FileProgressBar(input.length());
			/* */

			line = reader.readLine();

			while (line != null) {
				line = line.replace("\"", "");
				TaxaMatchAPI.getInstance().fetchSpeciesKey(line);
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

}
