class RequestDrugsController < ApplicationController
  before_action :set_request_drug, only: [:show, :edit, :update, :destroy]

  def index
    @request_drugs = RequestDrug.all
  end

  def show
  end

  def new
    @request_drug = RequestDrug.new
  end

  def edit
  end

  def create
    @request_drug = RequestDrug.new(request_drug_params)

    if @request_drug.save
      redirect_to @request_drug, notice: 'Request drug was successfully created.'
    else
      render :new
    end
  end

  def update
    if @request_drug.update(request_drug_params)
      redirect_to @request_drug, notice: 'Request drug was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @request_drug.destroy

    redirect_to request_drugs_url, notice: 'Request drug was successfully destroyed.'
  end

  private

    def set_request_drug
      @request_drug = RequestDrug.find(params[:id])
    end

    def request_drug_params
      params.require(:request_drug).permit(:id)
    end
end
