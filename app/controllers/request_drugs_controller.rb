class RequestDrugsController < ApplicationController
  before_action :set_request_drug, only: [:show, :edit, :update, :destroy]

  # GET /request_drugs
  # GET /request_drugs.json
  def index
    @request_drugs = RequestDrug.all
  end

  # GET /request_drugs/1
  # GET /request_drugs/1.json
  def show
  end

  # GET /request_drugs/new
  def new
    @request_drug = RequestDrug.new
  end

  # GET /request_drugs/1/edit
  def edit
  end

  # POST /request_drugs
  # POST /request_drugs.json
  def create
    @request_drug = RequestDrug.new(request_drug_params)

    respond_to do |format|
      if @request_drug.save
        format.html { redirect_to @request_drug, notice: 'Request drug was successfully created.' }
        format.json { render :show, status: :created, location: @request_drug }
      else
        format.html { render :new }
        format.json { render json: @request_drug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /request_drugs/1
  # PATCH/PUT /request_drugs/1.json
  def update
    respond_to do |format|
      if @request_drug.update(request_drug_params)
        format.html { redirect_to @request_drug, notice: 'Request drug was successfully updated.' }
        format.json { render :show, status: :ok, location: @request_drug }
      else
        format.html { render :edit }
        format.json { render json: @request_drug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /request_drugs/1
  # DELETE /request_drugs/1.json
  def destroy
    @request_drug.destroy
    respond_to do |format|
      format.html { redirect_to request_drugs_url, notice: 'Request drug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request_drug
      @request_drug = RequestDrug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_drug_params
      params.fetch(:request_drug, {})
    end
end
