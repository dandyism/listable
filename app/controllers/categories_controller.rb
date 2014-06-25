class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end
  
  def show
    conditions = []
    values = []

    unless params[:keywords].blank?
      keywords = params[:keywords].split

      keywords.each do |keyword|
        conditions << <<-SQL
          UPPER(posts.title) LIKE UPPER('%?%') 
          OR UPPER(posts.description) LIKE UPPER('%?%')"
        SQL

        values << keyword
      end
    end

    unless params[:min_price].blank?
      conditions << 'posts.price >= ?'
      values << params[:min_price]
    end

    unless params[:max_price].blank?
      conditions << 'posts.price <= ?'
      values << params[:max_price]
    end

    query = conditions.join(' OR ')
    @category = Category.find(params[:id])
    @posts = @category.posts.where(query, values)
  end
end
