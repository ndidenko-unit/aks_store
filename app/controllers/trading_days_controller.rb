class TradingDaysController < ApplicationController
  before_action :set_trading_day, only: [:show, :edit, :update, :destroy, :trade_item,
                                         :trade_item_without_code, :add_expense, :close_day,
                                         :if_day_close, :unblock_day, :only_for_creator!,
                                         :change_seller]

  before_action :if_day_close, only: [:trade_item, :add_expense]
  before_action :authenticate_user!
  before_action :blocked_user!
  before_action :only_for_admin!, only: [:destroy, :unblock_day]
  before_action :only_for_creator!, only: [:show, :edit, :update]

  def index
    @trading_days = TradingDay.all.reverse_order.paginate(page: params[:page], per_page: 20)
  end

  def show
    @expense = Expense.new
    @users_for_select = User.all.collect(&:email)
  end

  def new
    @trading_day = TradingDay.new
  end

  def edit
  end

  def create
    @trading_day = TradingDay.new(trading_day_params)
    if @trading_day.save
      redirect_to @trading_day, notice: 'Торговый день был успешно создан.'
    else
      render :new
    end
  end

  def update
    if @trading_day.update(trading_day_params)
      redirect_to @trading_day, notice: 'Торговый день был успешно обновлен.'
    else
      render :edit
    end
  end

  def destroy
    @trading_day.destroy
    redirect_to trading_days_url, notice: 'Торговый день был успешно удален.'
  end

  def trade_item
    begin
      @item = Item.find(trading_day_params[:item_ids])
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
      redirect_to @trading_day, notice: 'Товар с таким кодом не найден.'
    end
  end

  def trade_item_without_code
    binding.pry
    @item = Item.new(trading_day_params)
    if @item.save
      redirect_to @trading_day, notice: "Укажите на товаре код: #{@item.id} <br> Товар #{@item.name} добавлен в список продаж."
    else
      redirect_to @trading_day, notice: 'Товар не был создан. Проверьте наличие цены и названия.'
    end
  end


  def close_day
    final_proceeds = @trading_day.previously_proceeds - @trading_day.all_expenses
    @trading_day.update(proceeds: final_proceeds)
    if @trading_day.proceeds != nil
      redirect_to @trading_day, notice: "Выручка в сумме #{@trading_day.proceeds} грн. успешно сдана. Торговый день окончен!"
    else
      redirect_to @trading_day, notice: 'Произошла ошибка. Выручка не обнаружена.'
    end
  end

  def change_seller
    seller = User.find_by email: params[:seller]
    @trading_day.user = seller
    if @trading_day.save
      redirect_to root_path, notice: "Торговля успешно передана продавцу #{@trading_day.user.email}."
    else
      redirect_to @trading_day, notice: 'Торговля не была передана. Произошла ошибка.'
    end
  end

  def unblock_day
    @trading_day.unblock
    redirect_to @trading_day, notice: 'Торговый день разблокирован.'
  end

  def my_day
    @my_day = TradingDay.where(user_id: current_user.id, proceeds: nil)
    if @my_day.count == 1
      redirect_to @my_day.last
    elsif @my_day.count > 1
      redirect_to trading_days_path, notice: 'У вас несколько открытых дней.'
    else
      redirect_to trading_days_path, notice: 'Ваш торговый день не определен.'
    end
  end

  private

    def set_trading_day
      @trading_day = TradingDay.find(params[:id])
    end

    def trading_day_params
      params.require(:trading_day).permit(:day, :month, :year, :store_id, :user_id, :item_ids,
                                          :name, :retail, :status_id, :trading_day_id)
    end

    def if_day_close
      if @trading_day.close?
        redirect_to @trading_day, notice: 'Торговый день уже закрыт.'
      end
    end

    def only_for_creator!
      if current_user != @trading_day.user && current_user.role != "admin"
        redirect_to trading_days_path, notice: 'У вас нет прав на этот торговый день'
      end
    end
end
