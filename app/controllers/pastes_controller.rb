class PastesController < ApplicationController
  before_action :set_paste, only: %i[ show raw edit update destroy ]
  before_action :authorize_paste, only: %i[ show raw edit update destroy ]
  before_action :authenticate_user!, only: %i[ index  ]

  # GET /pastes or /pastes.json
  def index
    @pastes = Paste.all
  end

  def show
    @paste = Paste.where(slug: params[:slug]).first
    redirect_to new_paste_path and return if @paste.nil?
    render :show
  end

  def raw
    render plain: @paste.content_file.download
  end

  # GET /pastes/new
  def new
    @paste = Paste.new
  end

  # POST /pastes or /pastes.json
  def create
    if user_signed_in?
      @paste = current_user.pastes.build(paste_params.except(:content))
    else
      @paste = Paste.new(paste_params.except(:content))
    end

    file_io = StringIO.new(paste_params[:content])
    @paste.content_file.attach(
      io: file_io,
      filename: "#{@paste.slug}.txt",
      content_type: "text/plain"
    )

    respond_to do |format|
      if @paste.save
        format.html { redirect_to @paste, notice: "Paste was successfully created." }
        format.json { render :show, status: :created, location: @paste }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @paste.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      begin
        file_io = StringIO.new(paste_params[:content])
        @paste.content_file.attach(
          io: file_io,
          filename: "#{@paste.slug}.txt",
          content_type: "text/plain"
        )
      rescue => e
        Rails.logger.error "File attachment failed: #{e.message}"
        raise ActiveRecord::Rollback
      end

      unless @paste.update(paste_params.except(:content))
        raise ActiveRecord::Rollback
      end
    end
    if @paste.persisted?
      redirect_to @paste, notice: "Paste was successfully updated."
    else
      render :edit, status: :unprocessable_entity
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
    def set_paste
      @paste = Paste.find_by!(slug: params[:slug])
    end
    # Only allow a list of trusted parameters through.
    def paste_params
      params.expect(paste: [ :title, :slug, :private, :content, :language ])
    end

    def authorize_paste
      paste = Paste.find_by(slug: params[:slug])
      if paste.nil? || (paste.private? && (!user_signed_in? || paste.user_id != current_user.id))
        redirect_to root_path
        nil
      end
    end
end
