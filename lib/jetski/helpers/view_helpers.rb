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
        "<img src='#{image_path}' #{format_html_options(**html_opts)}></img>"
      end

      def favicon_tag(url, **html_opts)
        "<link rel='icon' type='image/x-icon' #{format_html_options(**html_opts)} href='#{url}'>"
      end

      def format_html_options(**html_opts)
        html_opts.map do |k, v|
          formatted_key = k.to_s.gsub("_", "-")
          "#{formatted_key}='#{v}'"
        end.join(" ")
      end
    end
  end
end