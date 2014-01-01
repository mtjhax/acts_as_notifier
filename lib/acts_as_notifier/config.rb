module ActsAsNotifier
  module Config
    mattr_accessor :use_delayed_job, :default_mailer, :default_method, :disabled
  end
end