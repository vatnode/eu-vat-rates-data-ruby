require_relative "lib/eu_vat_rates_data/version"

Gem::Specification.new do |spec|
  spec.name        = "eu_vat_rates_data"
  spec.version     = EuVatRatesData::VERSION
  spec.authors     = ["Iurii Rogulia"]
  spec.email       = ["iurii@rogulia.fi"]

  spec.summary     = "EU VAT rates for all 27 member states + UK"
  spec.description = "EU VAT rates for all 27 member states + UK. Updated daily from EC TEDB, published automatically when rates change."
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
