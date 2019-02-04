package org.ciat.control;

import java.io.File;

import org.ciat.model.Basis;
import org.ciat.model.DataSourceName;

public interface Normalizable {
	
	public Basis getBasis();
	
	public String getYear();
	
	public String getTaxonKey();
	
	public String getGenus();
	
	public String getSpecificSeparator();
	
	public String getDecimalLatitude();
	
	public String getDecimalLongitude();

	public String getCountry();
	
	public DataSourceName getDataSourceName();

	public String validate();
	
	public boolean isRepatriated();

	public void process(File input);

	public String normalize();

	
}
