# frozen_string_literal: true

class ApplicationLayout < ApplicationView
  include Phlex::Rails::Layout
  include Phlex::Rails::Helpers::ContentFor

  def view_template(&block)
    doctype

    html do
      head do
        title { content_for(:title) || "Pohqer" }
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        csp_meta_tag
        csrf_meta_tags
        stylesheet_link_tag "application", "tailwind", data_turbo_track: "reload"
        javascript_importmap_tags
        # turbo?      end

        body do
          main(class: "container w-full mx-auto mt-28 flex", &block)
        end
      end
    end
  end
end
