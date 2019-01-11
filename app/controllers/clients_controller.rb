class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = search_clients(params[:search])
  end

  def show
  end

  def new
    @client = Client.new
  end

  def edit
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to clients_url, notice: 'Client was successfully created.'
    else
      render :new
    end
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: 'Client was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_url, notice: 'Client was successfully destroyed.'
  end

  private

  def search_clients(search_params)
    clients = []
    search_params ||= ''
    clients = Client.where("phone ~* ?", search_params) if search_params.scan(/\D/).empty?
    clients += Client.where("name ~* ?", search_params) unless search_params.blank? && !search_params.scan(/\D/).empty?
    clients = Client.all if search_params.blank?
    begin
      clients.reverse_order.paginate(page: params[:page], per_page: 20)
    rescue
      clients
    end
  end

    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:name, :phone, :discount)
    end
end
