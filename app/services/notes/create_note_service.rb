module Notes
  class CreateNoteService
    attr_reader :note, :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def call
      @note = Note.new(@params)

      if @note.save
        true
      else
        @errors = @note.errors.full_messages
        false
      end
    end
  end
end
