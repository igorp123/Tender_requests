class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]

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
    #@new_request_drug = @request.request_drugs.build
    #@drugs = Drug.all.map{ |drug| [ "#{drug.name} | #{drug.mnn}", drug.id ] }
  end

  def edit
  end

  def create
    @request = Request.new(request_params)
    if params[:get_data_button]
      get_xml_data
      render :new
    else
      if @request.save
        redirect_to edit_request_path(@request.id), notice: 'Request was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    if params[:get_data_button]
      get_xml_data
      render :edit
    else

      if @request.update(request_params)
        redirect_to edit_request_path(@request.id), notice: 'Request was successfully updated.'
      else
        render :edit
      end
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
       :purchase_info, :max_price, :delivery_time, :delivery_place, :exp_date,
       request_drugs_attributes: [:id, :drug_id, :request_id, :quantity, :_destroy, :unit],
       customer_drugs_attributes: [
         :id, :mnn, :quantity, :price, :cost,
         dosages_attributes: [:id, :form, :value, :unit, :customer_drug_id]
       ]
       )
    end

    def get_xml_data
      #ZakupkiXmlService.call(@request) if @request.valid?
      @request.xml_parse if @request.valid?
    end

end
