require "rails_helper"

RSpec.describe Notes::CreateNoteService do
  describe "#call" do
    context "with valid params" do
      let(:params) { { title: "My note", content: "Some content" } }

      it "returns true" do
        service = described_class.new(params)
        expect(service.call).to be true
      end

      it "persists the note" do
        expect {
          described_class.new(params).call
        }.to change(Note, :count).by(1)
      end

      it "returns the created note" do
        service = described_class.new(params)
        service.call
        expect(service.note).to be_a(Note)
        expect(service.note).to be_persisted
      end
    end

    context "with title only" do
      let(:params) { { title: "Title only" } }

      it "returns true" do
        service = described_class.new(params)
        expect(service.call).to be true
      end

      it "persists the note with content as nil" do
        service = described_class.new(params)
        service.call
        expect(service.note.content).to be_nil
      end
    end

    context "with title as nil" do
      let(:params) { { title: nil } }

      it "returns false" do
        service = described_class.new(params)
        expect(service.call).to be false
      end

      it "does not persist the note" do
        expect {
          described_class.new(params).call
        }.not_to change(Note, :count)
      end

      it "returns error messages" do
        service = described_class.new(params)
        service.call
        expect(service.errors).to include("Title can't be blank")
      end
    end

    context "without title" do
      let(:params) { { content: "No title" } }

      it "returns false" do
        service = described_class.new(params)
        expect(service.call).to be false
      end

      it "does not persist the note" do
        expect {
          described_class.new(params).call
        }.not_to change(Note, :count)
      end

      it "returns error messages" do
        service = described_class.new(params)
        service.call
        expect(service.errors).to include("Title can't be blank")
      end
    end
  end
end
