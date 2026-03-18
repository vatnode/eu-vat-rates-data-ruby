require "json"
require_relative "eu_vat_rates_data/version"

# VAT rates for 44 European countries (EU-27 + 17 non-EU).
#
# EU rates sourced from the European Commission TEDB (Taxes in Europe Database),
# checked daily. Non-EU rates maintained manually.
#
# Usage:
#   require "eu_vat_rates_data"
#
#   EuVatRatesData.get_rate("FI")
#   # => {"country"=>"Finland", "currency"=>"EUR", "eu_member"=>true,
#   #     "standard"=>25.5, "reduced"=>[10.0, 13.5], "super_reduced"=>nil, "parking"=>nil}
#
#   EuVatRatesData.get_standard_rate("DE")  # => 19.0
#   EuVatRatesData.eu_member?("NO")         # => false
#   EuVatRatesData.eu_member?("FR")         # => true
#   EuVatRatesData.data_version             # => "2026-03-18"
module EuVatRatesData
  DATA_FILE = File.expand_path("../../data/eu-vat-rates-data.json", __dir__)

  @dataset = nil

  def self.dataset
    @dataset ||= JSON.parse(File.read(DATA_FILE, encoding: "utf-8"))
  end

  def self.rates
    dataset["rates"]
  end

  # Return the full rate hash for a country, or nil if not found.
  # @param country_code [String] ISO 3166-1 alpha-2 code (e.g. "FI", "DE", "NO")
  # @return [Hash, nil]
  def self.get_rate(country_code)
    rates[country_code.upcase]
  end

  # Return the standard VAT rate for a country, or nil if not found.
  # @param country_code [String] ISO 3166-1 alpha-2 code
  # @return [Float, nil]
  def self.get_standard_rate(country_code)
    rate = get_rate(country_code)
    rate&.fetch("standard")
  end

  # Return all 44 country rate hashes keyed by ISO country code.
  # @return [Hash{String => Hash}]
  def self.all_rates
    rates.dup
  end

  # Return true if the country is an EU-27 member state.
  # Returns false for non-EU countries (GB, NO, CH, etc.) and unknown codes.
  # @param country_code [String] ISO 3166-1 alpha-2 code
  # @return [Boolean]
  def self.eu_member?(country_code)
    rate = get_rate(country_code)
    rate ? rate["eu_member"] == true : false
  end

  # Return the ISO 8601 date when EU data was last fetched from EC TEDB.
  # @return [String] e.g. "2026-03-18"
  def self.data_version
    dataset["version"]
  end
end
