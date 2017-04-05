module ActionView
  module Helpers
    def stylesheet_link_tag(name, options={})
      %Q{<link href="/assets/#{name}.css" media="all" rel="stylesheet" />}
    end

    def javascript_include_tag(name, options={})
      %Q{<script src="/assets/#{name}.js"></script>}
    end

    def csrf_meta_tags
      # Not implemented
    end

    def h(text)
      ERB::Util.h text
    end

    def link_to(title, url)
      %Q{<a href="#{url}">#{h title}</a>}
    end
  end
end