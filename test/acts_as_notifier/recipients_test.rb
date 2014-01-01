require 'test_helper'

class RecipientsTest < ActiveSupport::TestCase
  def setup
    @widget = Widget.new
  end

  def test_mailer_receives_recipient_string
    MyMailer.expects(:create_method).with(@widget.notification_recipients, anything)
    @widget.save
  end

  def test_recipients_can_be_symbolic_method_name
    @widget.expects(:notification_recipients).at_least_once
    @widget.save
  end

  def test_recipients_can_be_object_with_email_method
    user = mock('User')
    user.stubs(:email).returns('xyz@xyz.xyz')
    @widget.stubs(:notification_recipients).returns(user)
    MyMailer.expects(:create_method).with('xyz@xyz.xyz', @widget)
    @widget.save
  end

  def test_recipients_can_be_array
    user = mock('User')
    user.stubs(:email).returns('xyz@xyz.xyz')
    @widget.stubs(:notification_recipients).returns([user, 'abc@abc.abc'])
    MyMailer.expects(:create_method).with('xyz@xyz.xyz, abc@abc.abc', @widget)
    @widget.save
  end

  def test_recipients_can_be_proc
    @widget.stubs(:use_proc?).returns(true)
    MyMailer.expects(:recipients_proc_method).with(@widget.proc_recipients(nil), @widget)
    @widget.save
  end

  def test_recipients_proc_receives_options_param
    @widget.stubs(:use_proc?).returns(true)
    @widget.expects(:proc_recipients).with(has_entries(:method => :recipients_proc_method, :custom => 'recipients_proc_method'))
    @widget.save
  end

  def test_no_notification_if_recipients_blank
    @widget.stubs(:notification_recipients).returns(' ')
    MyMailer.expects(:create_method).never
    @widget.save
  end
end
