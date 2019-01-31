package org.ciat.view;


import java.io.File;

import org.ciat.control.GBIFNormalizer;
import org.ciat.control.Normalizable;
import org.ciat.model.TaxonKeyFinder;

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
		
		// export counters
		log("Exporting taxa");
		TaxaIO.exportTaxaMatched(TaxonKeyFinder.getInstance().getMatchedTaxa(),new File(Executer.prop.getProperty("file.taxa.matched")));
		TaxaIO.exportTaxaUnmatched(TaxonKeyFinder.getInstance().getUnmatchedTaxa(),new File(Executer.prop.getProperty("file.taxa.unmatched")));
		
		TaxonKeyFinder.getInstance().getUnmatchedTaxa();
		System.gc();
		

	}

}
