class DemeController < ApplicationController
  def index
    @result = nil
    @input = ""
  end

  def search
    @input = params[:deme].to_s.strip.upcase
    @result = DemeMatcher.match(@input)
    render :index
  end
end
