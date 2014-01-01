class Widget < ActiveRecord::Base
  attr_accessible :name

  acts_as_notifier do
    after_create do
      notify :notification_recipients, :mailer => MyMailer, :method => :create_method
      notify :notification_recipients, :mailer => MyMailer, :method => :created_with_name_method, :if => :has_name?
      notify proc{|opts| proc_recipients(opts) }, :mailer => MyMailer, :method => :recipients_proc_method, :if => :use_proc?, :custom => 'recipients_proc_method'
      notify :notification_recipients, :mailer => MyMailer, :method => :created_with_string_condition, :if => 'string_condition?'
      notify :notification_recipients, :mailer => MyMailer, :method => :created_with_proc_condition, :if => proc{|opts| proc_condition?(opts) }, :custom => 'created_with_proc_condition'
      notify :notification_recipients, :mailer => MyMailer, :method => :created_with_class_mailer, :if => :mailer_test?
      notify :notification_recipients, :mailer => 'MyMailer', :method => :created_with_string_mailer, :if => :mailer_test?
      notify :notification_recipients, :mailer => :MyMailer, :method => :created_with_symbol_mailer, :if => :mailer_test?
      notify :notification_recipients, :mailer => nil, :method => :create_with_default_mailer_method, :if => :no_mailer_test?
      notify :notification_recipients, :mailer => MyMailer, :method => nil, :if => :no_method_test?
      notify :notification_recipients, :mailer => MyMailer, :method => :invalid_method, :if => :invalid_method_test?
    end
    after_save do
      notify :notification_recipients, :mailer => MyMailer, :method => :save_method
    end
    after_update do
      notify :notification_recipients, :mailer => MyMailer, :method => :update_method
    end
  end

  def notification_recipients
    "admin@example.com"
  end

  def proc_recipients(opts)
    "proc_recipients@example.com"
  end

  def has_name?
    name.present?
  end

  def use_proc?
    false
  end

  def string_condition?
    false
  end

  def proc_condition?(opts)
    false
  end

  def mailer_test?
    false
  end

  def no_mailer_test?
    false
  end

  def no_method_test?
    false
  end

  def invalid_method_test?
    false
  end
end
