# This is the base controller of the library
module Jetski
  class WaterfallController
    attr_accessor :action_name, :controller_name
    attr_reader :res
    def initialize(res)
      @res = res
    end

    # Method to render matching view with controller_name/action_name
    
    def render
      views_folder = File.join(Jetski.app_root, 'app/views')
      assets_folder = File.join(Jetski.app_root, 'app/assets/stylesheets')
      layout_content = File.read(File.join(views_folder, "layouts/application.html"))
      page_content = File.read(File.join(views_folder, controller_name, "#{action_name}.html"))
      page_with_layout = layout_content.gsub("YIELD_CONTENT", page_content)
      action_css_file = File.join(assets_folder, "#{controller_name}.css")
      css_content = if File.exist? action_css_file
        "<link rel='stylesheet' href='/assets/#{controller_name}.css'>"
      else
        ''
      end
      page_with_css = page_with_layout.gsub("DYNAMIC_CSS", css_content)
      res.body = page_with_css
    end
  end
end