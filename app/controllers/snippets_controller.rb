class SnippetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_snippet, only: %i[show edit update destroy]

  def index
    @snippets = current_user.snippets
  end

  def show
  end

  def new
    @snippet = current_user.snippets.build
  end

  def create
    @snippet = current_user.snippets.build(snippet_params)
    if @snippet.save
      redirect_to @snippet, notice: 'Snippet was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @snippet.update(snippet_params)
      redirect_to @snippet, notice: 'Snippet was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @snippet.destroy
    redirect_to snippets_url, notice: 'Snippet was successfully destroyed.'
  end

  private

  def set_snippet
    @snippet = current_user.snippets.find(params[:id])
  end

  def snippet_params
    params.require(:snippet).permit(:title, :description, :content)
  end
end
