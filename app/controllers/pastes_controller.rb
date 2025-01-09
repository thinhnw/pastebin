class PastesController < ApplicationController
  before_action :set_paste, only: %i[ destroy ]
  before_action :authorize_paste, only: %i[ show_by_slug raw destroy ]

  # GET /pastes or /pastes.json
  def index
    @pastes = Paste.all
  end

  def show_by_slug
    @paste = Paste.where(slug: params[:slug]).first
    redirect_to new_paste_path and return if @paste.nil?
    render :show
  end

  def raw
    @paste = Paste.find_by!(slug: params[:slug])
    render plain: @paste.content_file.download
  end

  # GET /pastes/new
  def new
    @paste = Paste.new
  end

  # POST /pastes or /pastes.json
  def create
    @paste = Paste.new(paste_params.except(:content))
    file_io = StringIO.new(paste_params[:content])
    @paste.content_file.attach(
      io: file_io,
      filename: "#{@paste.slug}.txt",
      content_type: "text/plain"
    )

    respond_to do |format|
      if @paste.save
        format.html { redirect_to paste_slug_path(slug: @paste.slug), notice: "Paste was successfully created." }
        format.json { render :show, status: :created, location: @paste }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @paste.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /pastes/1 or /pastes/1.json
  def destroy
    @paste.destroy!

    respond_to do |format|
      format.html { redirect_to pastes_path, status: :see_other, notice: "Paste was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paste
      @paste = Paste.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def paste_params
      params.expect(paste: [ :title, :slug, :private, :content, :language ])
    end

    def authorize_paste
      paste = Paste.find_by(slug: params[:slug])
      if paste.private? && (!user_signed_in?)
        redirect_to root_path
      end
    end
end
