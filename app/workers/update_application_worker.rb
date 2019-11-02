class UpdateApplicationWorker
  include Sidekiq::Worker

  def perform(application, delete = fasle)
    # byebug
    @applicaton = Application.find(application)
    if delete
      @applicaton.update(chats_count: @applicaton.chats_count + 1)
    else
      @applicaton.update(chats_count: @applicaton.chats_count - 1)
    end
  end
end