# eu_vat_rates_data · Ruby

[![Gem Version](https://img.shields.io/gem/v/eu_vat_rates_data)](https://rubygems.org/gems/eu_vat_rates_data)
[![Last updated](https://img.shields.io/github/last-commit/vatnode/eu-vat-rates-data-ruby?path=data%2Feu-vat-rates-data.json&label=last%20updated)](https://github.com/vatnode/eu-vat-rates-data-ruby/commits/main)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

VAT rates for **45 European countries** — EU-27 plus Norway, Switzerland, UK, and more. EU rates sourced from the European Commission TEDB and checked daily. Non-EU rates maintained manually.

- Standard, reduced, super-reduced, and parking rates
- `eu_member` flag on every country — `true` for EU-27, `false` for non-EU
- `vat_name` — official name of the VAT tax in the country's primary official language
- `vat_abbr` — short abbreviation used locally (e.g. "ALV", "MwSt", "TVA")
- **`format` — human-readable VAT number format (e.g. `"ATU + 8 digits"`)** — unique to this package
- **`pattern` — regex for VAT number validation + built-in `valid_format?()` — free, no API key needed** — unique to this package
- No dependencies — pure Ruby 3.0+
- Data bundled in the gem — works offline, no network calls
- EU rates checked daily via GitHub Actions, new version published only when rates change

Also available in: [JavaScript/TypeScript (npm)](https://www.npmjs.com/package/eu-vat-rates-data) · [Python (PyPI)](https://pypi.org/project/eu-vat-rates-data/) · [PHP (Packagist)](https://packagist.org/packages/vatnode/eu-vat-rates-data) · [Go](https://pkg.go.dev/github.com/vatnode/eu-vat-rates-data-go)

---

## Need live VIES validation?

This package gives you VAT **rates** and **format checks** for free, offline, in your code. It does **not** call VIES — `valid_format?()` only checks the shape of a VAT number, not whether it actually exists.

For **live VIES validation** — confirming a VAT ID is real, pulling the registered company name and address, and getting the VIES consultation number as your reference for the check — there's **[vatnode](https://vatnode.dev?ref=rates-readme-rb)**:

- Live VIES validation, with national-database fallback when VIES is down
- Registered company name, address, registration date
- VIES consultation number for compliance and audit trails
- Webhooks for VAT status changes
- Official [MCP server](https://www.npmjs.com/package/vatnode-mcp) so AI agents (Claude, Cursor, ChatGPT) can validate VAT IDs directly
- Free tier — no credit card needed

```bash
curl https://api.vatnode.dev/v1/vat/IE6388047V \
  -H "Authorization: Bearer YOUR_API_KEY"
```

[**See what the API adds →**](https://vatnode.dev/vat-rates?ref=rates-readme-rb#beyond-rates) · [Get a free API key](https://vatnode.dev/login?ref=rates-readme-rb)

---

## Installation

```bash
gem install eu_vat_rates_data
# or in Gemfile:
gem 'eu_vat_rates_data'
```

---

## Usage

```ruby
require "eu_vat_rates_data"

# Full rate hash for a country
fi = EuVatRatesData.get_rate("FI")
# {
#   "country"       => "Finland",
#   "currency"      => "EUR",
#   "eu_member"     => true,
#   "vat_name"      => "Arvonlisävero",
#   "vat_abbr"      => "ALV",
#   "standard"      => 25.5,
#   "reduced"       => [10.0, 13.5],
#   "super_reduced" => nil,
#   "parking"       => nil
# }

# Just the standard rate
EuVatRatesData.get_standard_rate("DE")  # => 19.0

# EU membership check — false for non-EU countries (GB, NO, CH, ...)
if EuVatRatesData.eu_member?(user_input)
  rate = EuVatRatesData.get_rate(user_input)
end

# Dataset membership check (all 45 countries)
if EuVatRatesData.has_rate?(user_input)
  rate = EuVatRatesData.get_rate(user_input)
end

# All 45 countries at once
EuVatRatesData.all_rates.each do |code, rate|
  puts "#{code}: #{rate['standard']}%"
end

# When were EU rates last fetched?
puts EuVatRatesData.data_version  # e.g. "2026-03-27"

# VAT number format validation — no API key, no network call
EuVatRatesData.valid_format?("ATU12345678")  # => true
EuVatRatesData.valid_format?("DE123456789")  # => true
EuVatRatesData.valid_format?("INVALID")      # => false

# Access format metadata directly
at = EuVatRatesData.get_rate("AT")
puts at["format"]   # "ATU + 8 digits"
puts at["pattern"]  # "^ATU\\d{8}$"

# Flag emoji from a 2-letter country code — no lookup table, computed from regional indicator symbols
EuVatRatesData.flag("FI")  # => "🇫🇮"
EuVatRatesData.flag("DE")  # => "🇩🇪"
EuVatRatesData.flag("XX")  # => "" (empty string for unknown/invalid codes)
```

---

## Example: charging VAT on an invoice

Rates on their own rarely answer the question you actually have, which is what
to put on the invoice. Two rules cover most of it: charge the buyer's domestic
rate, unless the sale is cross-border B2B inside the EU, where the reverse
charge applies and you invoice 0%.

```ruby
# Money in minor units (cents). Never floats.
def invoice_total(net_cents, seller_country, buyer_country, buyer_vat_id = nil)
  cross_border_b2b = buyer_country != seller_country &&
                     !buyer_vat_id.nil? &&
                     EuVatRatesData.valid_format?(buyer_vat_id)

  return { vat_cents: 0, total_cents: net_cents, reverse_charge: true } if cross_border_b2b

  rate = EuVatRatesData.get_standard_rate(buyer_country)
  vat_cents = (net_cents * rate / 100.0).round

  { vat_cents: vat_cents, total_cents: net_cents + vat_cents, reverse_charge: false }
end

# Domestic sale in Finland — 25.5%
invoice_total(10_000, 'FI', 'FI')
# => { vat_cents: 2550, total_cents: 12550, reverse_charge: false }

# Finnish seller, German business buyer — reverse charge
invoice_total(10_000, 'FI', 'DE', 'DE123456789')
# => { vat_cents: 0, total_cents: 10000, reverse_charge: true }
```

`valid_format?` only checks the shape of the number. Applying the reverse charge
requires the buyer to actually be VAT-registered, which is a VIES lookup — see
above.

---

## Data source & update frequency

How the daily check works, and what changed when: [vatnode.dev/data](https://vatnode.dev/data?ref=rates-readme-rb).

- EU-27 rates: **European Commission TEDB**, checked against the source **daily at 07:00 UTC**, updated on any change
- Non-EU rates: maintained manually, updated on official rate changes
- Published to RubyGems only when actual rates change

---


## Keeping rates current

Rates are bundled at install time. A new package version is published automatically whenever rates change — but your installed version will not update itself.

**Recommended:** add [Renovate](https://renovatebot.com) or [Dependabot](https://docs.github.com/en/code-security/dependabot) to your repo. They detect new versions and open a PR automatically whenever rates change — no manual update commands needed.

**Need real-time accuracy?** Fetch the always-current JSON directly:

```
https://cdn.jsdelivr.net/gh/vatnode/eu-vat-rates-data@main/data/eu-vat-rates-data.json
```

No package needed — parse it with a single `fetch()` / `http.get()` / `file_get_contents()` call and cache locally.

---

## Covered countries

**EU-27** (checked daily against EC TEDB, updated on any change):

`AT` `BE` `BG` `CY` `CZ` `DE` `DK` `EE` `ES` `FI` `FR` `GR` `HR` `HU` `IE` `IT` `LT` `LU` `LV` `MT` `NL` `PL` `PT` `RO` `SE` `SI` `SK`

**Non-EU Europe** (manually maintained):

`AD` `AL` `BA` `CH` `GB` `GE` `IS` `LI` `MC` `MD` `ME` `MK` `NO` `RS` `TR` `UA` `XK`

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

---

## License

MIT

If you find this useful, a ⭐ on GitHub is appreciated.
