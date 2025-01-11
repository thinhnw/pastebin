class PastesController < ApplicationController
  before_action :set_paste, only: %i[ show raw edit update destroy ]
  before_action :authorize_paste, only: %i[ show raw edit update destroy ]
  before_action :authenticate_user!, only: %i[ index  ]

  # GET /pastes or /pastes.json
  def index
    @pastes = current_user.pastes.ordered
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

    unless is_content_valid?
      render :new, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      @paste.save

      file_io = StringIO.new(paste_params[:content])
      @paste.content_file.attach(
        io: file_io,
        filename: "#{@paste.slug}.txt",
        content_type: "text/plain"
      )
      if @paste.errors.any?
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      else
        redirect_to @paste, notice: "Paste was successfully created."
      end
    end
  end

  def edit
  end

  def update
    if !is_content_valid?
      render :edit, status: :unprocessable_entity
      return
    end
    ActiveRecord::Base.transaction do
      file_io = StringIO.new(paste_params[:content])
      @paste.content_file.attach(
        io: file_io,
        filename: "#{@paste.slug}.txt",
        content_type: "text/plain"
      )

      if @paste.update(paste_params.except(:content))
        redirect_to @paste, notice: "Paste was successfully updated."
        return
      else
        raise ActiveRecord::Rollback
      end
    end
    @paste.reload
    render :edit, status: :unprocessable_entity
  end


  # DELETE /pastes/1 or /pastes/1.json
  def destroy
    @paste.destroy!

    respond_to do |format|
      format.html { redirect_to pastes_path, status: :see_other, notice: "Paste was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Paste was successfully destroyed." }
    end
  end

  private
    def set_paste
      @paste = Paste.find_by(slug: params[:slug])
      if @paste.nil?
        redirect_to root_path
      end
    end
    # Only allow a list of trusted parameters through.
    def paste_params
      params.expect(paste: [ :title, :slug, :private, :content, :language ])
    end

    def authorize_paste
      if @paste.private? && (!user_signed_in? || @paste.user_id != current_user.id)
        redirect_to root_path
      end
    end

    def is_content_valid?
      if !paste_params[:content].present?
        @paste.errors.add(:content, "should not be empty")
        return false
      end
      if paste_params[:content].size >= 1.kilobyte
        @paste.errors.add(:content, "should be less than 1KB")
        return false
      end
      true
    end
end
