require 'minitest/autorun'
require_relative '../lib/eu_vat_rates_data'

class SmokeTest < Minitest::Test
  def test_de_standard_rate
    assert_equal 19.0, EuVatRatesData.get_standard_rate('DE')
  end

  def test_ee_standard_rate
    assert_equal 24.0, EuVatRatesData.get_standard_rate('EE')
  end

  def test_fr_is_eu_member
    assert EuVatRatesData.eu_member?('FR')
  end

  def test_gb_is_not_eu_member
    refute EuVatRatesData.eu_member?('GB')
  end

  def test_dataset_has_44_countries
    assert_equal 44, EuVatRatesData.all_rates.length
  end

  def test_eu_member_field_present
    assert_equal true,  EuVatRatesData.get_rate('DE')['eu_member']
    assert_equal false, EuVatRatesData.get_rate('NO')['eu_member']
  end

  def test_data_version_format
    assert_match(/\A\d{4}-\d{2}-\d{2}\z/, EuVatRatesData.data_version)
  end
end
