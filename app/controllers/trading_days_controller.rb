class TradingDaysController < ApplicationController
  before_action :set_trading_day, only: [:show, :edit, :update, :destroy, :trade_item, :add_expense]
  before_action :authenticate_user!
  # GET /trading_days
  # GET /trading_days.json
  def index
    @trading_days = TradingDay.all
  end

  # GET /trading_days/1
  # GET /trading_days/1.json
  def show
    @expense = Expense.new
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

  def trade_item
    begin
      @item = Item.find(params[:trading_day][:item_ids])
        if @item.trading_day.present?
          redirect_to @trading_day, notice: "Товар #{@item.name} уже продан. #{view_context.link_to('Посмотреть день', @item.trading_day)}"; return
        elsif @item.store != @trading_day.store
        redirect_to @trading_day, notice: "Товар #{view_context.link_to("#{@item.name}", @item)} закреплен за точкой #{@item.store.name}."; return
        end
      status_sold = {status_id: 2}
      @item.update(status_sold)
      @trading_day.items << @item
      redirect_to @trading_day, notice: "Товар #{@item.name} добавлен в список продаж."
    rescue
      redirect_to @trading_day, notice: "Товар с таким кодом не найден."
    end
  end

  def add_expense
    @expense = Expense.create(sum: params[:expense][:sum], comment: params[:expense][:comment], trading_day_id: @trading_day.id)
    redirect_to @trading_day
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trading_day
      @trading_day = TradingDay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trading_day_params
      params.require(:trading_day).permit(:day, :month, :year, :store_id, :user_id)
    end
end
