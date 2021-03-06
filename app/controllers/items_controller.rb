class ItemsController < ApplicationController

  def index
    @items = nil
    if params[:category]
      @items = Item.where('lower(category) = ?', params[:category].downcase).order("description")
      @page_title = params[:category].capitalize
    elsif params[:collection]
      @items = Item.where('lower(collection) = ?', params[:collection].downcase).order("description")
      @page_title = params[:collection].capitalize
    elsif params[:query]
      query = params[:query].strip.downcase
      @items = Item.where(
        'cast(itemno as text) like :q_like OR lower(description) like :q_like OR lower(category) = :q_str OR lower(collection) = :q_str',
        q_str: query,
        q_int: query =~ /\A\d+\z/ ? query.to_i : nil,
        q_like: "%#{query}%"
      ).order("description")
      @page_title = "Products matching '#{params[:query]}'"
    else
      @items = Item.order("itemno")
      @page_title = "Products by Item Number"
    end
    @items = @items.page(params[:page] || 1)
  end

  def show
    @item = Item.find_by_itemno(params[:itemno])
    if !@item
      render inline: "Item not found"
      return
    end
    @page_title = @item.description
    @hide_page_title = true
  end

end
