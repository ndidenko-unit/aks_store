class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :cancel_sale]
  before_action :authenticate_user!
  before_action :blocked_user!

  # GET /items
  # GET /items.json
  def index
    @item = Item.new
    @items = []
    status_id = 0
    status_id = Status.find_by(name: params[:status]).id if params[:status].present? && params[:status] != 'Все товары'
    @items = search_items(params[:search], status_id)
    @all_statuses = Status.all.map(&:name).unshift('Все товары')
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
    end
  end

  def cancel_sale
    @trading_day = @item.trading_day
    if @trading_day.close?
      redirect_to @trading_day, notice: 'Торговый день закрыт.'
    else
      @trading_day.items.delete(@item)
      status_stock = {status_id: 1}
      @item.update(status_stock)
      redirect_to @trading_day, notice: 'Продажа отменена.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:name, :purchase, :retail, :store_id, :status_id)
  end
end
