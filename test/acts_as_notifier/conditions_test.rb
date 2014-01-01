require 'test_helper'

class ConditionsTest < ActiveSupport::TestCase
  def setup
    @widget = Widget.new
  end

  def test_notification_not_sent_if_condition_false
    MyMailer.expects(:created_with_name_method).never
    @widget.save
  end

  def test_notification_sent_if_condition_true
    MyMailer.expects(:created_with_name_method)
    @widget.name = "Name"
    @widget.save
  end

  def test_condition_can_be_string
    @widget.expects(:string_condition?)
    @widget.save
  end

  def test_condition_can_be_symbolic_method_name
    @widget.expects(:has_name?)
    @widget.save
  end

  def test_condition_can_be_proc
    @widget.expects(:proc_condition?)
    @widget.save
  end

  def test_condition_procs_receive_options_param
    @widget.expects(:proc_condition?).with(has_entries(:method => :created_with_proc_condition, :custom => 'created_with_proc_condition'))
    @widget.save
  end

  def test_supports_unless_conditions
    skip ":unless conditions not implemented yet"
  end
end
