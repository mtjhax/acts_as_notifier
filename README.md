# acts_as_notifier

Easily define ActiveRecord callbacks that notify users of changes via email. Acts_as_notifier dries up your code with
a simple, readable DSL, the ability to configure defaults, and by using delayed_job automatically if enabled. The DSL
looks especially good when you have multiple notifications defined in a model.

Instead of this:

```ruby
class MyModel < ActiveRecord::Base
  def after_create
    if alerts_enabled?
      if MyMailer.respond_to?(:delay)
        MyMailer.delay.new_widget_alert(get_recipients, self)
      else
        MyMailer.new_widget_alert(get_recipients, self).deliver
      end
    end
  end
end
```

With acts_as_notifier you write this:

```ruby
# in config/initializers/acts_as_notifier.rb
ActsAsNotifier::Config.default_mailer = :MyMailer
ActsAsNotifier::Config.default_mailer = :new_widget_alert

class MyModel < ActiveRecord::Base
  acts_as_notifier do
    after_create do
      notify :get_recipients, :if => :alerts_enabled?
    end
  end
end
```

## When Should I Use This?

Honestly, using an ActiveRecord callback to trigger email notifications is an [anti-pattern](#soapbox).
Acts_as_notifier is a good solution when you have an existing Rails app, possibly with overly-complicated controllers,
and refactoring is not feasible. In that case, acts_as_notifier gets you up and running quickly and hides some of the
added complexity.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acts_as_notifier'
```

And then execute:

```ruby
$ bundle
```

Or install it yourself as:

```ruby
$ gem install acts_as_notifier
```

## Usage

```ruby
# in config/initializers/acts_as_notifier.rb
ActsAsNotifier::Config.default_mailer = :MyMailer
ActsAsNotifier::Config.default_mailer = :change_notification

# in app/models/my_model.rb
class MyModel < ActiveRecord::Base
  acts_as_notifier do
    after_create do
      notify recipients, options
    end
    after_update do
      notify recipients, options
    end
    after_save do
      notify recipients, options
    end
  end
end

# in app/mailers/my_mailer.rb
class MyMailer < ActionMailer::Base
  default from: 'test@example.com'

  def change_notification(recipients, model)
    mail(to: recipients, subject: "A #{model.class} with ID #{model.id} was changed")
  end
end
```

### recipients

Can be a string containing email addresses, any object with an 'email' method, an array of strings/objects,
or a proc or symbolic method name returning any of the above. Procs will be passed the options hash as a parameter.
Note that to make sure you get the up-to-date recipients at runtime, you will normally use a proc.

Examples:

```ruby
notify 'bob@somewhere.com', options
notify :find_admin_users, options

# note use of a proc to lazy-evaluate the ActiveRecord query
notify Proc.new { User.where(:should_notify, true) }, options

# pass yourself custom options in addition to the acts_as_notifiers options
notify :get_recipients, :role => :admins
def self.get_recipients(options)
  User.find_all_by_role(options[:role])
end
```

### options

| :if | A string, proc, or name of a method that must evaluate to a truthy value in order for the notification to be sent. Procs and strings are evaluated in the context of the model instance. Procs are be passed the options hash as a parameter. |
| :mailer | A class inheriting from ActionMailer::Base, may be a string or symbol or actual class. |
| :method | Mailer method to invoke. Should accept recipients string and the ActiveRecord model as params. |
| custom | Any additional options will be saved and passed to :if and recipients procs. |

Examples:


```ruby
acts_as_notifier do
  after_create do
    # different ways of specifying :if condition
    notify :recipients, :if => 'alerts_enabled?'
    notify :recipients, :if => :alerts_enabled?
    notify :recipients, :if => proc { alerts_enabled? }

    # passing your own custom option to an if condition proc
    notify :recipients, :if => proc {|opts| alerts_enabled_for_role?(opts[:role]) }, :role => :admin

    # specifying a mailer
    notify :recipients, :mailer => 'MyMailer'
    notify :recipients, :mailer => :MyMailer
    notify :recipients, :mailer => MyMailer

    # specifying mailer method (in MyMailer class, def new_record_notification(recipients, model))
    notify :recipients, :mailer => MyMailer, :method => :new_record_notification

    # complete example
    notify proc { User.where(wants_alerts: true) }, :if => :alerts_enabled?, :mailer => MyMailer, :method => :new_widget_alert
  end
                                                                                  x
  # another complete example
  after_save do
    notify :owner, :if => ->(widget){ widget.broken? }, :mailer => MyMailer, :method => :broken_widget_alert
  end
end
```

## Configuration

<table>
<tr><td>ActsAsNotifier::Config.use_delayed_job =</td><td>true/false</td></tr>
<tr><td>ActsAsNotifier::Config.default_mailer =</td><td>class inheriting from ActionMailer::Base</td></tr>
<tr><td>ActsAsNotifier::Config.default_method =</td><td>mailer method to invoke, takes recipient string and ActiveRecord model as params</td></tr>
<tr><td>ActsAsNotifier::Config.disabled =</td><td>true/false, can be globally enabled or disabled at any time</td></tr>
</table>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## <a name="soapbox"></a>Soapbox

Why do I consider using ActiveRecord callbacks to trigger email notifications an anti-pattern? Callback-based behaviors
are difficult to disable or isolate in testing and can result in mysterious, difficult-to-find bugs. In this particular
case, using them violates the single responsibility principle in that a model should only be concerned with persisting
your data. It also creates undesirable connections between your model, other models, and mailer classes. A better
solution is to build business logic classes that handle creating and updating models, sending notifications, and are
easier to isolate for testing.
