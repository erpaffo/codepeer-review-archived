class SnippetsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @snippets = current_user.snippets
  end

  def show
    @snippet = current_user.snippets.find(params[:id])
  end

  def new
    @snippet = current_user.snippets.new
  end

  def create
    @snippet = current_user.snippets.new(snippet_params)
    if @snippet.save
      redirect_to @snippet, notice: 'Snippet was successfully created.'
    else
      render :new
    end
  end

  def edit
    @snippet = current_user.snippets.find(params[:id])
  end

  def update
    @snippet = current_user.snippets.find(params[:id])
    if @snippet.update(snippet_params)
      redirect_to @snippet, notice: 'Snippet was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @snippet = current_user.snippets.find(params[:id])
    @snippet.destroy
    redirect_to snippets_url, notice: 'Snippet was successfully destroyed.'
  end

  def resume
    # Logic to find the last modified snippet and redirect to its edit page
    @snippet = current_user.snippets.order(updated_at: :desc).first
    if @snippet
      redirect_to edit_snippet_path(@snippet)
    else
      redirect_to snippets_path, alert: 'No snippets available to resume.'
    end
  end

  private

  def snippet_params
    params.require(:snippet).permit(:title, :content)
  end
end
