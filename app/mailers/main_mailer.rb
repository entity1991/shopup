class MainMailer < ActionMailer::Base
  default from: "Administrator <ruslankuzma@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.received.subject
  #
  def help(question, sender)
    @question = question
    @sender = sender
    mail :to => "ruslankuzma@gmail.com", :subject => 'You have a new question'
  end

  def order_notifier(order, store)
    @order = order
    @store = store
    mail :to => store.owner.email, :subject => 'You have a new order'
  end
end