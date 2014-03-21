class VersionsController < ApplicationController
  #todo: add to security
  #revert model to version :id and return normal rud_toolbar
  def revert
    @version = PaperTrail::Version.find(params[:id])

    respond_to do |format|
      if (obj = @version.reify).save
        format.html {render partial:'shared/rud_toolbar', locals: {model: obj, enabled_buttons: {}}}
      end
    end
  end
end
