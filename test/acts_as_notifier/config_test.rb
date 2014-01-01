require 'test_helper'

class ConfigTest < ActiveSupport::TestCase
  def setup
    @widget = Widget.new
  end

  def test_can_configure_default_mailer
    ActsAsNotifier::Config.default_mailer = MyMailer
    MyMailer.expects(:create_with_default_mailer_method)
    @widget.stubs(:no_mailer_test?).returns(true)
    @widget.save
    ActsAsNotifier::Config.default_mailer = nil
  end

  def test_can_configure_default_method
    ActsAsNotifier::Config.default_method = :my_default_method
    MyMailer.expects(:my_default_method)
    @widget.stubs(:no_method_test?).returns(true)
    @widget.save
    ActsAsNotifier::Config.default_method = nil
  end

  def test_can_disable_notifications
    ActsAsNotifier::Config.disabled = true
    MyMailer.expects(:create_method).never
    @widget.save
    ActsAsNotifier::Config.disabled = false
  end

  def test_messages_can_be_queued_with_delayed_job
    ActsAsNotifier::Config.use_delayed_job = true
    MyMailer.expects(:delay).at_least_once.returns(MyMailer)
    @widget.save
    ActsAsNotifier::Config.use_delayed_job = false
  end
end
