package org.ciat.view;


import java.io.File;

import org.ciat.control.GBIFNormalizer;
import org.ciat.control.Normalizable;
import org.ciat.model.OrganizationMatchAPI;
import org.ciat.model.TaxaMatchAPI;

public class ExecNormalizer extends Executer {

	public static void main(String[] args) {
		Executable app = new ExecNormalizer();
		app.run();
	}

	public void run() {

		log("Starting process");



		// Reduce and normalize
		log("Normalizing GBIF data");
		Normalizable gbifNormalizer = new GBIFNormalizer();
		gbifNormalizer.process(new File(Executer.prop.getProperty("data.gbif")));
		System.gc();


		// export counters
		log("Exporting counters");
		CountExporter.getInstance().process();
		System.gc();
		
		// export taxa
		log("Exporting taxa");
		TempIO.exportMatched(TaxaMatchAPI.getInstance().getMatchedTaxa(),new File(Executer.prop.getProperty("file.taxa.matched")));
		TempIO.exportUnmatched(TaxaMatchAPI.getInstance().getUnmatchedTaxa(),new File(Executer.prop.getProperty("file.taxa.unmatched")));
		
		// export organizations
		log("Exporting organizations");
		TempIO.exportMatched(OrganizationMatchAPI.getInstance().getMatchedOrganizations(),new File(Executer.prop.getProperty("file.organizations.matched")));
		TempIO.exportUnmatched(OrganizationMatchAPI.getInstance().getUnmatchedOrganizations(),new File(Executer.prop.getProperty("file.organizations.unmatched")));
		
		
		TaxaMatchAPI.getInstance().getUnmatchedTaxa();
		System.gc();
		

	}

}
