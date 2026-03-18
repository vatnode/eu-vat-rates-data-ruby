require_relative "lib/eu_vat_rates_data/version"

Gem::Specification.new do |spec|
  spec.name        = "eu_vat_rates_data"
  spec.version     = EuVatRatesData::VERSION
  spec.authors     = ["Iurii Rogulia"]
  spec.email       = ["iurii@rogulia.fi"]

  spec.summary     = "VAT rates for 44 European countries — EU-27 plus Norway, Switzerland, UK, and more. Daily auto-updates from EC TEDB."
  spec.description = "VAT rates (standard, reduced, super-reduced, parking) for 44 European countries — EU-27 plus Norway, Switzerland, UK, and more. Updated daily from the official European Commission TEDB. Includes eu_member flag. Useful for billing, invoicing, e-commerce, fintech, and VAT MOSS compliance."
  spec.homepage    = "https://github.com/vatnode/eu-vat-rates-data-ruby"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.0"

  spec.metadata = {
    "homepage_uri"    => spec.homepage,
    "source_code_uri" => spec.homepage,
    "bug_tracker_uri" => "#{spec.homepage}/issues",
  }

  spec.files = Dir["lib/**/*", "data/**/*", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]
end
