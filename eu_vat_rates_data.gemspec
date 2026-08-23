require_relative "lib/eu_vat_rates_data/version"

Gem::Specification.new do |spec|
  spec.name        = "eu_vat_rates_data"
  spec.version      = EuVatRatesData::VERSION
  spec.authors     = ["Iurii Rogulia"]
  spec.email       = ["iurii@rogulia.fi"]

  spec.summary      = "Official-source European VAT rates for 45 jurisdictions"
  spec.description  = "Daily-checked European VAT rates with standard and reduced rate types, offline access, local VAT metadata, and VAT number format validation."
  spec.homepage    = "https://vatnode.dev/vat-rates?ref=rates-rubygems"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.0"

  repo = "https://github.com/vatnode/eu-vat-rates-data-ruby"

  spec.metadata = {
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => repo,
    "bug_tracker_uri"   => "#{repo}/issues",
    "changelog_uri"     => "#{repo}/blob/main/CHANGELOG.md",
    "documentation_uri" => "#{repo}#readme",
    "canonical_data_uri" => "https://github.com/vatnode/eu-vat-rates-data",
  }

  spec.files = Dir["lib/**/*", "data/**/*", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]
end
