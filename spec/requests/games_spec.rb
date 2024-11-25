# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "POST /games" do
    let(:valid_attributes) do
      {
        game: {
          owner_name: "John Doe"
        }
      }
    end

    context "with valid parameters" do
      it "creates a new Game with an owner" do
        expect do
          post games_path, params: valid_attributes
        end.to change(Game, :count).by(1)
                                   .and change(Player, :count).by(1)
      end

      it "sets up the owner relationship correctly" do # rubocop:disable RSpec/MultipleExpectations
        post games_path, params: valid_attributes
        game = Game.last
        owner = game.owner

        expect(owner).to be_present
        expect(owner.name).to eq("John Doe")
        expect(owner.game).to eq(game)
      end

      it "redirects to the created game" do
        post games_path, params: valid_attributes
        expect(response).to redirect_to(game_path(Game.last))
      end

      it "sets the player in the session" do
        post games_path, params: valid_attributes
        game = Game.last
        expect(session["game_#{game.id}_player_id"]).to eq(game.owner.id)
      end

      it "creates a new round" do
        expect do
          post games_path, params: valid_attributes
        end.to change(Round, :count).by(1)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          game: {
            owner_name: "" # owner_name is required
          }
        }
      end

      it "does not create a new Game" do
        expect do
          post games_path, params: invalid_attributes
        end.to change(Game, :count).by(0)
                                   .and change(Player, :count).by(0)
      end

      it "returns an unprocessable entity status" do
        post games_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
