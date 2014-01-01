class MyMailer < ActionMailer::Base
  default from: 'test@example.com'
 
  def create_method(recipients, model)
    mail(to: recipients, subject: 'Something was created')
  end

  def update_method(recipients, model)
    mail(to: recipients, subject: 'Something was updated')
  end

  def save_method(recipients, model)
    mail(to: recipients, subject: 'Something was saved')
  end

  def created_with_class_mailer(recipients, model)
    mail(to: recipients, subject: 'Something was created and mailer specified as a class')
  end

  def created_with_string_mailer(recipients, model)
    mail(to: recipients, subject: 'Something was created and mailer specified as a string')
  end

  def created_with_symbol_mailer(recipients, model)
    mail(to: recipients, subject: 'Something was created and mailer specified as a symbol')
  end
end