class DrugsController < ApplicationController
  before_action :set_drug, only: [:show, :edit, :update, :destroy]
  before_action :set_country, only: [:show, :edit]

  def index
    @drugs = Drug.all
  end

  def show
  end

  def new
    @drug = Drug.new
  end

  def edit
  end

  def create
    @drug = Drug.new(drug_params)

    if @drug.save
      redirect_to @drug, notice: 'Drug was successfully created.'
    else
      render :new
    end
  end

  def update
    if @drug.update(drug_params)
      redirect_to @drug, notice: 'Drug was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @drug.destroy

    redirect_to drugs_url, notice: 'Drug was successfully destroyed.'
  end

  private
    def set_drug
      @drug = Drug.find(params[:id])
    end

    def set_country
      @countries = Country.all
    end

    def drug_params
      params.require(:drug).permit(:id, :mnn, :name, :country_id, :dosage_form, :packing, :producer, :unit)
    end
end
