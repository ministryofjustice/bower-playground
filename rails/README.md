# Installation

1. Add `gem mojular` to your Gemfile
2. `bundle install`
3. Add the following to `app/controllers/application_controller.rb` to use Mojular custom layouts
    There are two variants of template: `erb/external` (intendend for public-facing projects) and `erb/internal`
    (for internal projects).

    ```ruby
    layout "erb/external"
    prepend_view_path(File.expand_path("#{Mojular::Rails::Engine.root}/templates"))
    ```
