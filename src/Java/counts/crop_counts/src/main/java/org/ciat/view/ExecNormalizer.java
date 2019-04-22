package org.ciat.view;


import java.io.File;

import org.ciat.control.GBIFNormalizer;
import org.ciat.control.Normalizable;
import org.ciat.model.OrganizationMatchAPI;

public class ExecNormalizer extends Executer {

	public static void main(String[] args) {
		Executable app = new ExecNormalizer();
		app.run();
	}

	public void run() {

		log("Starting process");



		// Reduce and normalize
		log("Counting GBIF data");
		Normalizable gbifNormalizer = new GBIFNormalizer();
		gbifNormalizer.process(Executer.prop);
		System.gc();


		// export counters
		log("Exporting counters");
		CountExporter.getInstance().process();
		System.gc();
		
		// export organizations
		log("Exporting organizations");
		TempIO.exportMatched(OrganizationMatchAPI.getInstance().getMatchedOrganizations(),new File(Executer.prop.getProperty("file.org.matched")));
		TempIO.exportUnmatched(OrganizationMatchAPI.getInstance().getUnmatchedOrganizations(),new File(Executer.prop.getProperty("file.org.unmatched")));
		
		
     	System.gc();
		

	}

}
