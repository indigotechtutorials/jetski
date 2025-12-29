class PagesController < Jetski::BaseController
  def home
    @root = true
  end
end