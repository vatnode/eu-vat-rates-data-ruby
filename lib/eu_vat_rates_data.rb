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
#   EuVatRatesData.flag("FI")              # => "🇫🇮"
module EuVatRatesData
  DATA_FILE = File.expand_path("../data/eu-vat-rates-data.json", __dir__)

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

  # Return true if the country code is present in the dataset (all 44 countries).
  # Use eu_member? to check EU membership specifically.
  # @param country_code [String] ISO 3166-1 alpha-2 code
  # @return [Boolean]
  def self.has_rate?(country_code)
    rates.key?(country_code.upcase)
  end

  # Return true if vat_id matches the expected format for its country.
  # Input must include the country code prefix (e.g. "ATU12345678").
  # Returns false when the country has no standardised format or the ID does not match.
  # Note: Greece uses the "EL" prefix, not "GR".
  # @param vat_id [String] VAT number string including country code prefix
  # @return [Boolean]
  def self.valid_format?(vat_id)
    code = vat_id[0, 2].upcase
    rate = get_rate(code)
    return false unless rate && rate["pattern"]
    !!(vat_id.upcase =~ /\A#{rate["pattern"]}\z/)
  end

  # Return the ISO 8601 date when EU data was last fetched from EC TEDB.
  # @return [String] e.g. "2026-03-18"
  def self.data_version
    dataset["version"]
  end

  # Return the flag emoji for a 2-letter ISO 3166-1 alpha-2 country code.
  # Computed from regional indicator symbols — no lookup table needed.
  # Returns an empty string if the input is not exactly 2 ASCII letters.
  #
  # @param country_code [String] ISO 3166-1 alpha-2 code (e.g. "FI", "DE")
  # @return [String] flag emoji (e.g. "🇫🇮"), or "" if invalid
  #
  # @example
  #   EuVatRatesData.flag("FI")  # => "🇫🇮"
  #   EuVatRatesData.flag("DE")  # => "🇩🇪"
  #   EuVatRatesData.flag("GB")  # => "🇬🇧"
  def self.flag(country_code)
    code = country_code.upcase
    return "" unless code.length == 2 && code.match?(/\A[A-Z]{2}\z/)
    base = 0x1F1E6
    [base + code.ord - 65, base + code[-1].ord - 65].pack("U*")
  end
end
