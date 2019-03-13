package org.ciat.control;


import java.util.Properties;

import org.ciat.model.Basis;
import org.ciat.model.DataSourceName;

public interface Normalizable {
	
	public Basis getBasis();
	
	public String getYear();
	
	public String getTaxonKey();
	
	public String getGenus();
	
	public String getSpecies();
	
	public String getSpecificSeparator();
	
	public String getDecimalLatitude();
	
	public String getDecimalLongitude();
	
	public String getAccessionNumber();

	public String getCountry();
	
	public DataSourceName getDataSourceName();

	public String validate();
	
	public boolean isRepatriated();

	public void process(Properties prop);

	public String normalize();

}
