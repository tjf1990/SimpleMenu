class FoodItemsController < ApplicationController
  load_and_authorize_resource

  # GET /food_items
  # GET /food_items.json
  def index
    #@food_items automatically set to FoodItem.accessible_by(current_ability)

    respond_to do |format|
      format.html { render 'index', layout: !(request.xhr?) }
      format.json { render json: @food_items }
    end
  end

  # GET /food_items/1
  # GET /food_items/1.json
  def show
    #@food_item automatically set to FoodItem.find(params[:id])

    respond_to do |format|
      format.html { render 'show', layout: !(request.xhr?) }
      format.json { render json: @food_item }
    end
  end

  # GET /food_items/new
  # GET /food_items/new.json
  def new
    #@food_item params set via ability.rb

    respond_to do |format|
      format.html { render 'new', layout: !(request.xhr?) }
      format.json { render json: @food_item }
    end
  end

  # GET /food_items/1/edit
  def edit
    #@food_item automatically set to FoodItem.find(params[:id])

    respond_to do |format|
      format.html {render 'edit', layout:!(request.xhr?)}
    end
  end

  # POST /food_items
  # POST /food_items.json
  def create
    @food_item = FoodItem.new(params[:food_item])

    respond_to do |format|
      if @food_item.save
        format.html { redirect_to @food_item, notice: 'Food item was successfully created.' }
        format.json { render json: @food_item, status: :created, location: @food_item }
      else
        format.html { render action: "new" }
        format.json { render json: @food_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /food_items/1
  # PUT /food_items/1.json
  def update
    #@food_item automatically set to FoodItem.find(params[:id])

    respond_to do |format|
      if @food_item.update_attributes(params[:food_item])
        format.html { redirect_to @food_item, notice: 'Food item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @food_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /food_items/1
  # DELETE /food_items/1.json
  def destroy
    #@food_item automatically set to FoodItem.find(params[:id])

    @food_item.destroy

    respond_to do |format|
      if request.xhr?
        format.html { render partial: 'shared/undo_button'}
      else
        format.html { redirect_to food_items_url, notice: 'food_item deleted successfully'}
      end
      format.json { head :no_content }
    end
  end
end

