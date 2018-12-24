require 'test_helper'

class TradingDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trading_day = trading_days(:one)
  end

  test "should get index" do
    get trading_days_url
    assert_response :success
  end

  test "should get new" do
    get new_trading_day_url
    assert_response :success
  end

  test "should create trading_day" do
    assert_difference('TradingDay.count') do
      post trading_days_url, params: { trading_day: { day: @trading_day.day, month: @trading_day.month, store_id: @trading_day.store_id, year: @trading_day.year } }
    end

    assert_redirected_to trading_day_url(TradingDay.last)
  end

  test "should show trading_day" do
    get trading_day_url(@trading_day)
    assert_response :success
  end

  test "should get edit" do
    get edit_trading_day_url(@trading_day)
    assert_response :success
  end

  test "should update trading_day" do
    patch trading_day_url(@trading_day), params: { trading_day: { day: @trading_day.day, month: @trading_day.month, store_id: @trading_day.store_id, year: @trading_day.year } }
    assert_redirected_to trading_day_url(@trading_day)
  end

  test "should destroy trading_day" do
    assert_difference('TradingDay.count', -1) do
      delete trading_day_url(@trading_day)
    end

    assert_redirected_to trading_days_url
  end
end
