module Api
  module V1
    class NotesController < ApplicationController
      def index
        notes = Note.order(created_at: :desc)
        render json: notes, status: :ok
      end

      def create
        service = Notes::CreateNoteService.new(note_params)

        if service.call
          render json: service.note, status: :created
        else
          render json: { errors: service.errors }, status: :unprocessable_content
        end
      end

      private

      def note_params
        params.require(:note).permit(:title, :content)
      end
    end
  end
end
