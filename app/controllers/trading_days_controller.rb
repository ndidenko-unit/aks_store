class TradingDaysController < ApplicationController
  before_action :set_trading_day, only: [:show, :edit, :update, :destroy]

  # GET /trading_days
  # GET /trading_days.json
  def index
    @trading_days = TradingDay.all
  end

  # GET /trading_days/1
  # GET /trading_days/1.json
  def show
  end

  # GET /trading_days/new
  def new
    @trading_day = TradingDay.new
  end

  # GET /trading_days/1/edit
  def edit
  end

  # POST /trading_days
  # POST /trading_days.json
  def create
    @trading_day = TradingDay.new(trading_day_params)

    respond_to do |format|
      if @trading_day.save
        format.html { redirect_to @trading_day, notice: 'Trading day was successfully created.' }
        format.json { render :show, status: :created, location: @trading_day }
      else
        format.html { render :new }
        format.json { render json: @trading_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trading_days/1
  # PATCH/PUT /trading_days/1.json
  def update
    respond_to do |format|
      if @trading_day.update(trading_day_params)
        format.html { redirect_to @trading_day, notice: 'Trading day was successfully updated.' }
        format.json { render :show, status: :ok, location: @trading_day }
      else
        format.html { render :edit }
        format.json { render json: @trading_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trading_days/1
  # DELETE /trading_days/1.json
  def destroy
    @trading_day.destroy
    respond_to do |format|
      format.html { redirect_to trading_days_url, notice: 'Trading day was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trading_day
      @trading_day = TradingDay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trading_day_params
      params.require(:trading_day).permit(:day, :month, :year, :store_id)
    end
end
