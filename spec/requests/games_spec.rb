# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "POST /games" do
    subject { post games_path, params: params }

    context "with valid parameters" do
      let(:params) do
        {
          game: {
            owner_name: "John Doe"
          }
        }
      end

      it "creates a new Game with an owner" do
        expect { subject }.to change(Game, :count).by(1)
                                                  .and change(Player, :count).by(1)
      end

      it "sets up the owner relationship correctly" do # rubocop:disable RSpec/MultipleExpectations
        subject
        game = Game.last
        owner = game.owner

        expect(owner).to be_present
        expect(owner.name).to eq("John Doe")
        expect(owner.game).to eq(game)
      end

      it "redirects to the created game" do
        subject
        expect(response).to redirect_to(game_path(Game.last))
      end

      it "sets the player in the session" do
        subject
        game = Game.last
        expect(session["game_#{game.id}_player_id"]).to eq(game.owner.id)
      end

      it "creates a new round" do
        expect { subject }.to change(Round, :count).by(1)
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          game: {
            owner_name: "" # owner_name is required
          }
        }
      end

      it "does not create a new Game" do
        expect { subject }.not_to change(Game, :count)
      end

      it "don't create a new player" do
        expect { subject }.not_to change(Player, :count)
      end

      it "returns an unprocessable entity status" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /games/:game_id/rounds/:id/finish" do
    subject { post finish_game_round_path(game, round, **request_params) }

    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let(:player) { create(:player, game: game) }
    let(:request_params) { {} }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
    end

    context "when ending a round" do
      it "finishes the round" do
        subject
        expect(round.reload).to be_finished
      end

      context "with HTML format" do
        it "redirects to the game page" do
          subject
          expect(response).to redirect_to(game_path(game))
        end
      end

      context "with Turbo Stream format" do
        let(:request_params) { { format: :turbo_stream } }

        it "renders turbo stream response" do
          subject
          expect(response.media_type).to eq Mime[:turbo_stream]
        end

        it "replaces the round component" do
          subject
          expect(response.body).to include("turbo-stream")
          expect(response.body).to include("action=\"replace\"")
          expect(response.body).to include("round_#{round.id}")
        end
      end
    end
  end
end
