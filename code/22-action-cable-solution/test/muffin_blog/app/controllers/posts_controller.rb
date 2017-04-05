class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end
end
