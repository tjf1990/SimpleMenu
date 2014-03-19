class <%= controller_class_name %>Controller < ApplicationController
  load_and_authorize_resource

  # GET <%= route_url %>
  # GET <%= route_url %>.json
  def index
    #@<%= plural_table_name %> automatically set to <%= singular_table_name.camelize %>.accessible_by(current_ability)

    respond_to do |format|
      format.html { render 'index', layout: !(request.xhr?) }
      format.json { render <%= key_value :json, "@#{plural_table_name}" %> }
    end
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.json
  def show
    #@<%= singular_table_name %> automatically set to <%= singular_table_name.camelize %>.find(params[:id])

    respond_to do |format|
      format.html { render 'show', layout: !(request.xhr?) }
      format.json { render <%= key_value :json, "@#{singular_table_name}" %> }
    end
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.json
  def new
    #@<%= singular_table_name %> params set via ability.rb

    respond_to do |format|
      format.html { render 'new', layout: !(request.xhr?) }
      format.json { render <%= key_value :json, "@#{singular_table_name}" %> }
    end
  end

  # GET <%= route_url %>/1/edit
  def edit
    #@<%= singular_table_name %> automatically set to <%= singular_table_name.camelize %>.find(params[:id])

    respond_to do |format|
      format.html {render 'edit', layout:!(request.xhr?)}
    end
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.json
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>

    respond_to do |format|
      if @<%= orm_instance.save %>
        if request.xhr?
          format.html { render partial: '<%= plural_table_name %>/row', locals: {<%= singular_table_name %>: @<%= singular_table_name %>, index: 0, is_hidden: false}}
        else
          format.html { redirect_to @<%= singular_table_name %>, <%= key_value :notice, "'#{human_name} was successfully created.'" %> }
        end
        format.json { render <%= key_value :json, "@#{singular_table_name}" %>, <%= key_value :status, ':created' %>, <%= key_value :location, "@#{singular_table_name}" %> }
      else
        if request.xhr?
          format.html { render partial: '<%= plural_table_name %>/row_form', locals: {<%= singular_table_name %>: @<%=singular_table_name%>}, status: :unprocessable_entity }
        else
          format.html { render <%= key_value :action, '"new"' %> }
        end
        format.json { render <%= key_value :json, "@#{orm_instance.errors}" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.json
  def update
    #@<%= singular_table_name %> automatically set to <%= singular_table_name.camelize %>.find(params[:id])

    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
        format.html { redirect_to @<%= singular_table_name %>, <%= key_value :notice, "'#{human_name} was successfully updated.'" %> }
        format.json { head :no_content }
      else
        format.html { render <%= key_value :action, '"edit"' %> }
        format.json { render <%= key_value :json, "@#{orm_instance.errors}" %>, <%= key_value :status, ':unprocessable_entity' %> }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.json
  def destroy
    #@<%= singular_table_name %> automatically set to <%= singular_table_name.camelize %>.find(params[:id])

    @<%= orm_instance.destroy %>

    respond_to do |format|
      if request.xhr?
        format.html { render partial: 'shared/undo_button'}
      else
        format.html { redirect_to <%= index_helper %>_url, notice: '<%= singular_table_name %> deleted successfully'}
      end
      format.json { head :no_content }
    end
  end
end

