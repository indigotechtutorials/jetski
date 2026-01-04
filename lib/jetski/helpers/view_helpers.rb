module Jetski
  module Helpers
    module ViewHelpers
      # Expecting a relative path.
      def render(partial_path, **locals)
        path_to_file = File.join(Jetski.app_root, 'app/views', 
          path_to_controller, "_#{partial_path}.html.erb")
        content = File.read(path_to_file)
        bind = binding
        locals.each do |k, v| 
          bind.local_variable_set k, v
        end
        template = ERB.new(content)
        template.result(bind)
      end

      # link_to "New post", "/posts/new"
      def link_to(link_text, url, **html_opts)
        # TODO: Allow passing block to link_to
        "<a href='#{url}' #{format_html_options(**html_opts)}>#{link_text}</a>"
      end

      # button_to("Click me", class: "cool-btn")
      def button_to(button_text, **html_opts)
        "<button #{format_html_options(**html_opts)}>#{button_text}</button>"
      end

      def input_tag(**html_opts)
        "<input #{format_html_options(**html_opts)}>"
      end

      def textarea_tag(**html_opts)
        "<textarea #{format_html_options(**html_opts.except(:value))}>#{html_opts[:value]}</textarea>"
      end

      def image_tag(image_path, **html_opts)
        abs_url = process_url(image_path)
        "<img src='#{abs_url}' #{format_html_options(**html_opts)}></img>"
      end

      def favicon_tag(url, **html_opts)
        abs_url = process_url(url)
        "<link rel='icon' type='image/x-icon' #{format_html_options(**html_opts)} href='#{abs_url}'>"
      end

      def stylesheet_tag(url, **html_opts)
        abs_url = process_url(url)
        "<link rel='stylesheet' #{format_html_options(**html_opts)} href='#{abs_url}'>"
      end

      def javascript_include_tag(url, **html_opts)
        abs_url = process_url(url)
        "<script src='#{abs_url}' #{format_html_options(**html_opts)}></script>"
      end

      def javascript_tag(**html_opts)
        "<script #{format_html_options(**html_opts)}>#{yield}</script>"
      end

      def format_html_options(**html_opts)
        html_opts.map do |k, v|
          formatted_key = k.to_s.gsub("_", "-")
          "#{formatted_key}='#{v}'"
        end.join(" ")
      end
    private
      def process_url(url)
        # Need to ensure urls start with / to avoid relative requests
        if url[0] == '/'
          url
        else
          "/#{url}"
        end
      end
    end
  end
end