package org.ciat.control;

import java.util.LinkedHashSet;
import java.util.Set;

import org.ciat.model.Basis;
import org.ciat.model.DataSourceName;
import org.ciat.model.OrganizationMatchAPI;
import org.ciat.model.Utils;

public class GBIFNormalizer extends Normalizer {
	
	Set<String> issues = new LinkedHashSet<>();

	public GBIFNormalizer() {
		super();
		issues.add("COORDINATE_OUT_OF_RANGE");
		issues.add("COUNTRY_COORDINATE_MISMATCH");
		issues.add("ZERO_COORDINATE");
	}

	@Override
	public String validate() {

		String result = super.validate();

		// ignoring CWR dataset in GBIF
		if (colIndex.get("datasetkey") != null
				&& values[colIndex.get("datasetkey")].contains("07044577-bd82-4089-9f3a-f4a9d2170b2e")) {
			result += "GBIF_ALREADY_IN_CWR;";
		}

		// only allow species and subspecies
		if (colIndex.get("taxonrank") != null) {
			if (!(values[colIndex.get("taxonrank")].contains("SPECIES")
					|| values[colIndex.get("taxonrank")].contains("VARIETY"))) {
				result += "GBIF_RANK_IS_" + colIndex.get("taxonrank") + ";";
			}
		}

		for (String issue : issues) {
			if (colIndex.get("issue") != null && values[colIndex.get("issue")].contains(issue)) {
				result += "GBIF_" + issue + ";";
			}
		}

		return result;
	}


	@Override
	public Basis getBasis() {
		if (values[colIndex.get("basisofrecord")].toUpperCase().equals("LIVING_SPECIMEN")) {
			return Basis.G;
		}
		return Basis.H;
	}

	@Override
	public String getYear() {
		String year = values[colIndex.get("year")];
		return Utils.validateYear(year);
	}

	@Override
	public String getTaxonKey() {
		return values[colIndex.get("taxonkey")];
	}
	
	@Override
	public String getGenus() {
		return values[colIndex.get("genus")];
	}
	
	@Override
	public String getSpecies() {
		return values[colIndex.get("species")];
	}

	@Override
	public String getDecimalLatitude() {
		return values[colIndex.get("decimallatitude")];
	}

	@Override
	public String getDecimalLongitude() {
		return values[colIndex.get("decimallongitude")];
	}
	
	@Override
	public String getAccessionNumber() {
		return values[colIndex.get("recordnumber")];
	}

	@Override
	public String getCountry() {
		return Utils.iso2CountryCodeToIso3CountryCode(values[colIndex.get("countrycode")]);
	}
	
	@Override
	public String getInstitution() {
		return values[colIndex.get("publishingorgkey")];
	}
	
	@Override
	public String getInstitutionCountry() {
		String country = OrganizationMatchAPI.getInstance().fetchCountry(getInstitution());
		return Utils.iso2CountryCodeToIso3CountryCode(country);
	}

	@Override
	public DataSourceName getDataSourceName() {
		return DataSourceName.GBIF;
	}

	@Override
	public String getSpecificSeparator() {
		return "\t";
	}
	
	@Override
	public boolean isRepatriated() {
		String orgCountry = OrganizationMatchAPI.getInstance().fetchCountry(geyOrgUUID());
		orgCountry = Utils.iso2CountryCodeToIso3CountryCode(orgCountry);
		return orgCountry.equals(getCountry());
	}


	private String geyOrgUUID() {
		return values[colIndex.get("publishingorgkey")];
	}
	
}



