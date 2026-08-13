require_relative "lib/eu_vat_rates_data/version"

Gem::Specification.new do |spec|
  spec.name        = "eu_vat_rates_data"
  spec.version      = EuVatRatesData::VERSION
  spec.authors     = ["Iurii Rogulia"]
  spec.email       = ["iurii@rogulia.fi"]

  spec.summary      = "VAT rates for 45 European countries — EU-27 plus Norway, Switzerland, UK, and more. From vatnode.dev."
  spec.description  = "VAT rates (standard, reduced, super-reduced, parking) for 45 European countries — EU-27 plus Norway, Switzerland, UK, and more. Includes eu_member flag, local VAT name and abbreviation. Useful for billing, invoicing, e-commerce, fintech, and VAT compliance. From vatnode.dev — live VIES validation via API."
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
  }

  spec.files = Dir["lib/**/*", "data/**/*", "README.md", "LICENSE"]
  spec.require_paths = ["lib"]
end
