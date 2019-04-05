class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy, :get_data]

  def index
    @requests = Request.all
  end

  def show
    @request_drugs = @request.request_drugs.all

    @new_request_drug = @request.request_drugs.build

    @drugs = Drug.all.map{ |drug| [ "#{drug.name} | #{drug.mnn}", drug.id ] }
  end

  def new
    @request = Request.new
  end

  def edit
  end

  def create
    if params[:get_data_button]
      get_data
      render :new
    else
      @request = Request.new(request_params)
      if @request.save
        redirect_to edit_request_path(@request.id), notice: 'Request was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    if @request.update(request_params)
      redirect_to @request, notice: 'Request was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @request.destroy

    redirect_to requests_url, notice: 'Request was successfully destroyed.'
  end

  private

    def set_request
      @request = Request.find_by(id: params[:id])
    end

    def request_params
      params.require(:request).permit(:id, :auction_number, :customer, :etp, :number,
       :purchase_info, :max_price, :delivery_time, :delivery_place, :exp_date
      )
    end

    def get_data
      @request ||= Request.new(request_params)
      ZakupkiXmlService.call(@request) if @request.valid?
    end

end
