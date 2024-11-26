# frozen_string_literal: true

module Games
  class New < ApplicationView
    include Phlex::Rails::Helpers::FormWith
    include Phlex::Rails::Helpers::Pluralize

    def initialize(game:)
      @game = game
    end

    def view_template
      div(class: "max-w-md mx-auto p-4") do
        h1(class: "text-2xl font-bold mb-6") { "Create New Planning Poker Game" }

        form_with(model: @game, class: "space-y-4") do |form|
          render_errors if @game.errors.any?

          div do
            form.label :owner_name, class: "block mb-2"
            form.text_field :owner_name,
                            required: true,
                            class: "w-full px-3 py-2 border rounded",
                            placeholder: "Your Name"
          end

          div do
            form.label :title, class: "block mb-2"
            form.text_field :title,
                            class: "w-full px-3 py-2 border rounded",
                            placeholder: "Game Title (Optional)"
          end

          div do
            form.submit "Create Game",
                        class: "w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600"
          end
        end
      end
    end

    def render_errors
      div(class: "rounded-md bg-red-50 p-4 mb-4") do
        h2(class: "text-red-800 text-sm font-medium") do
          "#{pluralize(@game.errors.count, 'error')} prohibited this game from being saved:"
        end
        ul(class: "mt-2 text-sm text-red-700") do
          @game.errors.full_messages.each do |message|
            li { message }
          end
        end
      end
    end
  end
end
