require "rails_helper"

RSpec.describe "Api::V1::Notes", type: :request do
  describe "GET /api/v1/notes" do
    context "when there are notes" do
      before { create_list(:note, 3) }

      it "returns all notes with status 200" do
        get "/api/v1/notes"

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).count).to eq(3)
      end

      it "returns notes with title and content fields" do
        get "/api/v1/notes"

        body = JSON.parse(response.body)
        expect(body.first).to include("title", "content")
      end
    end

    context "when there are no notes" do
      it "returns an empty array with status 200" do
        get "/api/v1/notes"

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe "POST /api/v1/notes" do
    context "with title and content" do
      let(:params) { { note: { title: "My note", content: "Optional content" } } }

      it "creates the note and returns status 201" do
        expect {
          post "/api/v1/notes", params: params, as: :json
        }.to change(Note, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it "returns the created note in the response body" do
        post "/api/v1/notes", params: params, as: :json

        body = JSON.parse(response.body)
        expect(body["title"]).to eq("My note")
        expect(body["content"]).to eq("Optional content")
      end
    end

    context "with title only" do
      let(:params) { { note: { title: "Title only" } } }

      it "creates the note successfully and returns status 201" do
        expect {
          post "/api/v1/notes", params: params, as: :json
        }.to change(Note, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it "returns the note with content as nil" do
        post "/api/v1/notes", params: params, as: :json

        body = JSON.parse(response.body)
        expect(body["title"]).to eq("Title only")
        expect(body["content"]).to be_nil
      end
    end

    context "with title as nil" do
      let(:params) { { note: { title: nil, content: "Some content" } } }

      it "does not persist the note and returns status 422" do
        expect {
          post "/api/v1/notes", params: params, as: :json
        }.not_to change(Note, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns error message for blank title" do
        post "/api/v1/notes", params: params, as: :json

        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Title can't be blank")
      end
    end

    context "without title" do
      let(:params) { { note: { content: "No title" } } }

      it "does not persist the note and returns status 422" do
        expect {
          post "/api/v1/notes", params: params, as: :json
        }.not_to change(Note, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns error messages in the response body" do
        post "/api/v1/notes", params: params, as: :json

        body = JSON.parse(response.body)
        expect(body["errors"]).to include("Title can't be blank")
      end
    end
  end
end
