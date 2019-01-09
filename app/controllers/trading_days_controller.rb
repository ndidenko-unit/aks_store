class TradingDaysController < ApplicationController
  before_action :set_trading_day, only: [:show, :edit, :update, :destroy, :trade_item, :trade_item_without_code,
                                         :add_expense, :close_day, :if_day_close, :unblock_day]
  before_action :if_day_close, only: [:trade_item, :add_expense]
  before_action :authenticate_user!
  before_action :blocked_user!
  before_action :only_for_admin!, only: [:destroy, :unblock_day]
  # GET /trading_days
  # GET /trading_days.json
  def index
    @trading_days = TradingDay.all.paginate(page: params[:page], per_page: 20)
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
        format.html { redirect_to @trading_day, notice: 'Торговый день был успешно создан.' }
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
        format.html { redirect_to @trading_day, notice: 'Торговый день был успешно обновлен.' }
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
      format.html { redirect_to trading_days_url, notice: 'Торговый день был успешно удален.' }
      format.json { head :no_content }
    end
  end

  def trade_item
    begin
      @item = Item.find(params[:trading_day][:item_ids])
        if @item.trading_day.present?
          redirect_to @trading_day, notice: "Товар #{@item.name} уже продан #{@item.trading_day.date_and_store}. #{view_context.link_to('Посмотреть день', @item.trading_day)}"; return
        elsif @item.store != @trading_day.store
          redirect_to @trading_day, notice: "Товар #{view_context.link_to("#{@item.name}", @item)} закреплен за точкой #{@item.store.name}."; return
        end
      status_sold = {status_id: 2, user_id: current_user.id}
      @item.update(status_sold)
      @trading_day.items << @item
      redirect_to @trading_day, notice: "Товар #{@item.name} добавлен в список продаж."
    rescue
      redirect_to @trading_day, notice: "Товар с таким кодом не найден."
    end
  end

  def trade_item_without_code
    @item = Item.new(name: params[:trading_day][:name], retail: params[:trading_day][:price],
                        status_id: 2, user_id: current_user.id, store_id: @trading_day.store.id,
                        trading_day_id: @trading_day.id)
    if @item.save
      redirect_to @trading_day, notice: "Укажите на товаре код: #{@item.id} <br> Товар #{@item.name} добавлен в список продаж."
    else
      redirect_to @trading_day, notice: "Товар не был создан. Проверьте наличие цены и названия."
    end
  end

  def add_expense
    @expense = Expense.create(sum: params[:expense][:sum], comment: params[:expense][:comment],
                              trading_day_id: @trading_day.id, user_id: current_user.id)
    if @expense.id.present?
      redirect_to @trading_day, notice: "Расход успешно добавлен."
    else
      redirect_to @trading_day, notice: "Неверно введены данные расхода."
    end
  end

  def close_day
    final_proceeds = @trading_day.previously_proceeds - @trading_day.all_expenses
    @trading_day.update(proceeds: final_proceeds)
    if @trading_day.proceeds != nil
      redirect_to @trading_day, notice: "Выручка в сумме #{@trading_day.proceeds} грн. успешно сдана. Торговый день окончен!"
    else
      redirect_to @trading_day, notice: "Произошла ошибка. Выручка не обнаружена."
    end
  end

  def unblock_day
    @trading_day.unblock
    redirect_to @trading_day, notice: "Торговый день разблокирован."
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

    def if_day_close
      if @trading_day.close?
        redirect_to @trading_day, notice: "Торговый день уже закрыт."
      end
    end
end
