class FlatsController < ApplicationController
  before_action :set_flat, only: [:show, :edit, :update, :destroy]

  # GET /flats
  # GET /flats.json
  def index
    @flats_search = FlatsSearch.new(search_params)
    @flats = Flat.filter(@flats_search).order(created_at: :desc).page(params[:page]).per(9)
    @hash = Gmaps4rails.build_markers(@flats) do |flat, marker|
      if flat.coordinates
        marker.lat flat.coordinates[1]
        marker.lng flat.coordinates[0]
        marker.picture({
                           url: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=#{flat.price.to_i/100}|FF0000|000000",
                           width: 40,
                           height: 34
                       })
        # marker.infowindow render_to_string(:partial => 'infowindow', :locals => {:flat => flat})
        marker.json({id: flat._id.to_s})
      end
    end
  end

  # GET /flats/1
  # GET /flats/1.json
  def show
    render :show, layout: false
  end

  def modal
  end

  # GET /flats/new
  def new
    @flat = Flat.new
  end

  # GET /flats/1/edit
  def edit

  end

  # POST /flats
  # POST /flats.json
  def create
    @flat = Flat.new(flat_params)

    respond_to do |format|
      if @flat.save
        format.html { redirect_to @flat, notice: 'Flat was successfully created.' }
        format.json { render :show, status: :created, location: @flat }
      else
        format.html { render :new }
        format.json { render json: @flat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flats/1
  # PATCH/PUT /flats/1.json
  def update
    respond_to do |format|
      if @flat.update(flat_params)
        format.html { redirect_to flats_path, notice: 'Flat was successfully updated.' }
        format.json { render :show, status: :ok, location: @flat }
      else
        format.html { render :edit }
        format.json { render json: @flat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flats/1
  # DELETE /flats/1.json
  def destroy
    @flat.destroy
    respond_to do |format|
      format.html { redirect_to flats_url, notice: 'Flat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_flat
    @flat = Flat.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def flat_params
    params.require(:flat).permit(:address, :coords, :desc)
  end

  def search_params
    params.permit(flats_search: [:rooms, :lvl,:images,:from])[:flats_search]
  end
end
