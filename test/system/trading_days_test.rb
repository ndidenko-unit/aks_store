require "application_system_test_case"

class TradingDaysTest < ApplicationSystemTestCase
  setup do
    @trading_day = trading_days(:one)
  end

  test "visiting the index" do
    visit trading_days_url
    assert_selector "h1", text: "Trading Days"
  end

  test "creating a Trading day" do
    visit trading_days_url
    click_on "New Trading Day"

    fill_in "Day", with: @trading_day.day
    fill_in "Month", with: @trading_day.month
    fill_in "Store", with: @trading_day.store_id
    fill_in "Year", with: @trading_day.year
    click_on "Create Trading day"

    assert_text "Trading day was successfully created"
    click_on "Back"
  end

  test "updating a Trading day" do
    visit trading_days_url
    click_on "Edit", match: :first

    fill_in "Day", with: @trading_day.day
    fill_in "Month", with: @trading_day.month
    fill_in "Store", with: @trading_day.store_id
    fill_in "Year", with: @trading_day.year
    click_on "Update Trading day"

    assert_text "Trading day was successfully updated"
    click_on "Back"
  end

  test "destroying a Trading day" do
    visit trading_days_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Trading day was successfully destroyed"
  end
end
