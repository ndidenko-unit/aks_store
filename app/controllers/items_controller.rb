class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :cancel_sale]
  before_action :authenticate_user!
  before_action :blocked_user!
  before_action :only_for_admin!, only: [:destroy]

  def index
    @item = Item.new
    @items = []
    status_id = 0
    status_id = Status.find_by(name: params[:status]).id if params[:status].present? && params[:status] != 'Все товары'
    @items = search_items(params[:search], status_id)
    @all_statuses = Status.all.map(&:name).unshift('Все товары')
  end


  def show
    tmp_version = @item
    @versions = []
    while !tmp_version.nil?
      @versions << tmp_version
      tmp_version = tmp_version.paper_trail.previous_version
    end
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item, notice: 'Товар добавлен.'
    else
      render :new
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Товар обновлен.'
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: 'Товар удален.'
  end

  def cancel_sale
    @trading_day = @item.trading_day
    if @trading_day.close?
      redirect_to @trading_day, notice: 'Торговый день закрыт.'
    else
      @trading_day.items.delete(@item)
      status_stock = {status_id: 1, user_id: current_user.id}
      @item.update(status_stock)
      redirect_to @trading_day, notice: 'Продажа отменена.'
    end
  end

  private

  def search_items(search_params, status_id)
    items = []
    search_params ||= ''
    items = Item.where(id: search_params) if search_params.scan(/\D/).empty?
    if status_id == 0
      items += Item.where("name ~* ?", search_params) unless search_params.blank?
      items = Item.all if search_params.blank?
    else
      items += Item.where(status_id: status_id).where("name ~* ?", search_params) unless search_params.blank?
      items = Item.where(status_id: status_id) if search_params.blank?
    end
    begin
      items.reverse_order.paginate(page: params[:page], per_page: 20)
    rescue
      items
    end
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :purchase, :retail, :store_id, :status_id, :user_id)
  end
end
