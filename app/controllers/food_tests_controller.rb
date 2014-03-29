class FoodTestsController < ApplicationController
  load_and_authorize_resource

  # GET /food_tests
  # GET /food_tests.json
  def index
    #@food_tests automatically set to FoodTest.accessible_by(current_ability)

    respond_to do |format|
      format.html { render 'index', layout: !(request.xhr?) }
      format.json { render json: @food_tests }
    end
  end

  # GET /food_tests/1
  # GET /food_tests/1.json
  def show
    #@food_test automatically set to FoodTest.find(params[:id])
    #send table row if ajax request todo: add to scaffolding
    respond_to do |format|
      if request.xhr?
        format.html { render partial: 'row', locals: {food_test: @food_test, index: 0}} #index is set in javascript
      else
        format.html { render 'show'}
      end
      format.json { render json: @food_test }
    end
  end

  # GET /food_tests/new
  # GET /food_tests/new.json
  def new
    #@food_test params set via ability.rb

    respond_to do |format|
      format.html { render 'new', layout: !(request.xhr?) }
      format.json { render json: @food_test }
    end
  end

  # GET /food_tests/1/edit
  def edit
    #@food_test automatically set to FoodTest.find(params[:id])

    respond_to do |format|
      #send row form if ajax request todo: add to generator
      if request.xhr?
        format.html { render partial: 'row_form', locals: {food_test: @food_test} }
      else
        format.html { render 'edit' }
      end
    end
  end

  # POST /food_tests
  # POST /food_tests.json
  def create
    @food_test = FoodTest.new(params[:food_test])
    respond_to do |format|
      if @food_test.save
        if request.xhr?
          #todo: add to generator
          format.html {render partial: 'shared/combo_partial',
                              locals: { partials: [{name:'food_tests/row_form', locals: {food_test: FoodTest.new}},
                                                   {name:'food_tests/row', locals: {food_test: @food_test, index: 0, is_hidden: false, is_ajax: true}}]} }
        else
          format.html { redirect_to @food_test, notice: 'Food test was successfully created.' }
        end
        format.json { render json: @food_test, status: :created, location: @food_test }
      else
        if request.xhr?
          format.html { render partial: 'food_tests/row_form', locals: {food_test: @food_test}, status: :unprocessable_entity }
        else
          format.html { render action: 'new' }
        end
        format.json { render json: @food_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /food_tests/1
  # PUT /food_tests/1.json
  def update
    #@food_test automatically set to FoodTest.find(params[:id])
    #todo: add to generator
    respond_to do |format|
      if @food_test.update_attributes(params[:food_test])
        if request.xhr?
          format.html { render partial: 'row', locals: {food_test: @food_test, index: 0}}
        else
          format.html { redirect_to @food_test, notice: 'Food test was successfully updated.' }
        end
        format.json { head :no_content }
      else
        if request.xhr?
          format.html { render partial: 'row_form', locals: {food_test: @food_test}, status: :unprocessable_entity }
        else
          format.html { render action: 'edit' }
        end
        format.json { render json: @food_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /food_tests/1
  # DELETE /food_tests/1.json
  def destroy
    #@food_test automatically set to FoodTest.find(params[:id])

    @food_test.destroy

    respond_to do |format|
      if request.xhr?
        format.html { render partial: 'shared/undo_button', locals: {version_id: @food_test.versions.last.id} }
      else
        format.html { redirect_to food_tests_url, notice: 'food_test deleted successfully'}
      end
      format.json { head :no_content }
    end
  end
end

