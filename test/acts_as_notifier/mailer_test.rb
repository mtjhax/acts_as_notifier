require 'test_helper'

class MailerTest < ActiveSupport::TestCase
  def setup
    @widget = Widget.new
  end

  def test_mailer_can_be_class
    MyMailer.expects(:created_with_class_mailer)
    @widget.stubs(:mailer_test?).returns(true)
    @widget.save
  end

  def test_mailer_can_be_string
    MyMailer.expects(:created_with_string_mailer)
    @widget.stubs(:mailer_test?).returns(true)
    @widget.save
  end

  def test_mailer_can_be_symbol
    MyMailer.expects(:created_with_symbol_mailer)
    @widget.stubs(:mailer_test?).returns(true)
    @widget.save
  end

  def test_mailer_passed_model_instance
    MyMailer.expects(:create_method).with(anything, @widget)
    @widget.save
  end

  def test_error_raised_if_mailer_not_configured
    @widget.stubs(:no_mailer_test?).returns(true)
    assert_raises(RuntimeError) { @widget.save }
  end

  def test_error_raised_if_method_not_configured
    @widget.stubs(:no_method_test?).returns(true)
    assert_raises(RuntimeError) { @widget.save }
  end

  def test_error_raised_if_method_not_valid
    @widget.stubs(:invalid_method_test?).returns(true)
    assert_raises(RuntimeError) { @widget.save }
  end

end
