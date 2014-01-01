require 'test_helper'

class ActsAsNotifierTest < ActiveSupport::TestCase
  def setup
    @widget = Widget.new
  end

  def test_model_class_methods_created
    assert Widget.respond_to?(:acts_as_notifier)
  end

  def test_model_instance_methods_created
    assert @widget.respond_to?(:force_notification)
  end

  def test_mailer_is_invoked_on_create
    MyMailer.expects(:create_method)
    @widget.save
  end

  def test_mailer_is_invoked_on_update
    @widget.save
    MyMailer.expects(:update_method)
    @widget.name = "Name"
    @widget.save
  end

  def test_mailer_is_invoked_on_save
    MyMailer.expects(:save_method)
    @widget.save
  end

  def test_message_deliver_method_called
    mailer = mock('Mail::Message')
    mailer.expects(:deliver).returns(:true)
    MyMailer.stubs(:create_method).returns(mailer)
    @widget.save
  end

  def test_forced_notification
    MyMailer.expects(:created_with_name_method)
    @widget.force_notification(:method => :created_with_name_method)
  end
end
