package org.ciat.model;

import org.ciat.view.TempIO;

public class NameUsage {

	private String usageKey;
	private String scientificName;
	private String genusName;
	private String speciesName;
	private String rank;
	private String status;
	
	public NameUsage(String usageKey, String scientificName, String genusName, String speciesName, String rank, String status) {
		super();
		this.usageKey = usageKey;
		this.scientificName = scientificName;
		this.genusName = genusName;
		this.speciesName = speciesName;
		this.rank = rank;
		this.status = status;
	}


	@Override
	public String toString() {
		return "" + usageKey + TempIO.SEPARATOR + scientificName + TempIO.SEPARATOR + genusName+ TempIO.SEPARATOR  + speciesName + TempIO.SEPARATOR + rank + TempIO.SEPARATOR + status + "";
	}

	public String getUsageKey() {
		return usageKey;
	}

	public void setUsageKey(String usageKey) {
		this.usageKey = usageKey;
	}


	public String getGenusName() {
		return genusName;
	}

	public void setGenusName(String genusName) {
		this.genusName = genusName;
	}

	public String getSpeciesName() {
		return speciesName;
	}

	public void setSpeciesName(String speciesName) {
		this.speciesName = speciesName;
	}


	public String getRank() {
		return rank;
	}

	public void setRank(String rank) {
		this.rank = rank;
	}

	public String getScientificName() {
		return scientificName;
	}

	public void setScientificName(String scientificName) {
		this.scientificName = scientificName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
