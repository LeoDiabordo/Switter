class SwitsController < ApplicationController
  before_action :set_swit, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /swits
  # GET /swits.json
  def index
    @swits = Swit.all(:order => "created_at DESC")
    @swit = Swit.new
    @comment = Comment.new

  end

  # GET /swits/1
  # GET /swits/1.json
  def show
  end

  # GET /swits/new
  def new
    @swit = Swit.new
  end

  # GET /swits/1/edit
  def edit
  end

  # POST /swits
  # POST /swits.json
  def create
    @swit = Swit.new(swit_params)
    @swit_fin = swits_path
    @body = @swit.body

    respond_to do |format|
      if @swit.save
        @tags = @body.scan(/\{[^}]*\}/)
          # render :text => @tags

        @tags.each do |doortag|
          @doortag = Doortag.new(swit_id: @swit.id, tag: doortag)
          @doortag.save
          # raise Hash[doortag.attributes.select {|_,v| v.is_a? Array}].inspect
        end

        format.html { redirect_to swits_path }
        format.json { render action: 'show', status: :created, location: @swit }

      else
        format.html { render action: 'new' }
        format.json { render json: @swit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /swits/1
  # PATCH/PUT /swits/1.json
  def update
    respond_to do |format|
      if @swit.update(swit_params)
        format.html { redirect_to @swit }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @swit.errors, status: :unprocessable_entity }
      end
    end
  end

  def addlike
    
  end

  # DELETE /swits/1
  # DELETE /swits/1.json
  def destroy
    # @tag = Doortag.where(swit_id: @swit.id).first
    # @tag.destroy()

    @swit.destroy
    respond_to do |format|
      format.html { redirect_to swits_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_swit
      @swit = Swit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def swit_params
      params.require(:swit).permit(:body, :author, :likes, :unlike)
    end
end
