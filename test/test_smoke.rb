require 'minitest/autorun'
require_relative '../lib/eu_vat_rates_data'

class SmokeTest < Minitest::Test
  def test_de_is_eu_member
    assert EuVatRatesData.eu_member?('DE')
  end

  def test_gb_is_not_eu_member
    refute EuVatRatesData.eu_member?('GB')
  end

  def test_no_is_not_eu_member
    refute EuVatRatesData.eu_member?('NO')
  end

  def test_dataset_has_45_countries
    assert_equal 45, EuVatRatesData.all_rates.length
  end

  def test_all_standard_rates_positive
    EuVatRatesData.all_rates.each do |code, rate|
      assert rate['standard'] > 0, "#{code}: standard rate is #{rate['standard']}"
    end
  end

  def test_eu_member_field_is_bool
    EuVatRatesData.all_rates.each do |code, rate|
      assert [true, false].include?(rate['eu_member']), "#{code}: eu_member is not boolean"
    end
  end

  def test_all_vat_names_non_empty
    EuVatRatesData.all_rates.each do |code, rate|
      assert rate['vat_name'].is_a?(String) && !rate['vat_name'].empty?, "#{code}: vat_name is empty"
    end
  end

  def test_data_version_format
    assert_match(/\A\d{4}-\d{2}-\d{2}\z/, EuVatRatesData.data_version)
  end

  def test_unknown_country_returns_nil
    assert_nil EuVatRatesData.get_rate('XX')
  end

  def test_valid_format_accepts_well_formed_ids
    assert EuVatRatesData.valid_format?('ATU12345678')
    assert EuVatRatesData.valid_format?('DE123456789')
    assert EuVatRatesData.valid_format?('atu12345678')
  end

  def test_valid_format_rejects_malformed_input
    refute EuVatRatesData.valid_format?('')
    refute EuVatRatesData.valid_format?('INVALID')
    refute EuVatRatesData.valid_format?('DE12')
  end

  # Greek VAT numbers carry the VIES prefix EL while the dataset keys Greece as GR.
  def test_valid_format_handles_greek_el_prefix
    assert EuVatRatesData.valid_format?('EL123456789')
    assert EuVatRatesData.valid_format?('el123456789')
    refute EuVatRatesData.valid_format?('EL12345678')
  end
end
