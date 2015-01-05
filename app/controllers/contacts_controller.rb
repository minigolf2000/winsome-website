class ContactsController < ApplicationController

  before_filter :set_page_title
  before_filter :set_comment

  def set_page_title
    @page_title = "Contact Us"
  end

  def set_comment
    @comment = Comment.new(comment_params)
  end

  def new
  end

  def create
    if @comment.save
      redirect_to success_path
    else
      render 'new'
    end
  end

  protected

  def comment_params
    comment_params = params[:comment]
    comment_params.permit(:subject, :name, :company, :email, :comments) if comment_params
  end
end