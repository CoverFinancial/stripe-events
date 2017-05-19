class FailedPaymentEmailer
  include Sidekiq::Worker

  def perform(event_id)

  end
end