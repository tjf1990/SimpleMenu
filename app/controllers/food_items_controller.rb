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
      if request.xhr?
        format.html { render partial: 'row', locals: {food_item: @food_item, index: 0}} #index is set in javascript
      else
        format.html { render 'show' }
      end
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
      if request.xhr?
        format.html { render partial: 'row_form', locals: {food_item: @food_item} }
      else
        format.html {render 'edit'}
      end
    end
  end

  # POST /food_items
  # POST /food_items.json
  def create
    @food_item = FoodItem.new(params[:food_item])

    respond_to do |format|
      if @food_item.save
        if request.xhr?
          format.html {render partial: 'shared/combo_partial',
                              locals: { partials: [{name:'food_items/row_form', locals: {food_item: FoodItem.new}},
                                                   {name:'food_items/row', locals: {food_item: @food_item, index: 0, is_hidden: false, is_ajax: true}}]} }
        else
          format.html { redirect_to @food_item, notice: 'Food item was successfully created.' }
        end
        format.json { render json: @food_item, status: :created, location: @food_item }
      else
        if request.xhr?
          format.html { render partial: 'food_items/row_form', locals: {food_item: @food_item}, status: :unprocessable_entity }
        else
          format.html { render action: "new" }
        end
        format.json { render json: @food_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT/POST /food_items/1
  # PUT/POST /food_items/1.json
  def update
    #@food_item automatically set to FoodItem.find(params[:id])

    respond_to do |format|
      if @food_item.update_attributes(params[:food_item])
        if request.xhr?
          format.html { render partial: 'row', locals: {food_item: @food_item, index: 0}}
        else
          format.html { redirect_to @food_item, notice: 'Food item was successfully updated.' }
        end
        format.json { head :no_content }
      else
        if request.xhr?
          format.html { render partial: 'row_form', locals: {food_item: @food_item}, status: :unprocessable_entity }
        else
          format.html { render action: "edit" }
        end
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
        format.html { render partial: 'shared/undo_button', locals: {version_id: @food_item.versions.last.id}}
      else
        format.html { redirect_to food_items_url, notice: 'Food item deleted successfully'}
      end
      format.json { head :no_content }
    end
  end
end

