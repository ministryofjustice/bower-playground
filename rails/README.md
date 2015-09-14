# Installation

1. Edit `.bowerrc` to desired directory
2. `bower install`
3. Add the following to `config/initializers/assets.rb`:
    ```ruby
    bowerrc_dir = JSON.parse(IO.read("#{Rails.root.to_s}/.bowerrc"))['directory']
    Rails.application.config.assets.paths << Rails.root.join(bowerrc_dir)
    Rails.application.config.assets.paths << Rails.root.join(bowerrc_dir, 'mojular', 'assets')
    Rails.application.config.assets.paths << Rails.root.join(bowerrc_dir, 'govuk-template', 'assets')
    Rails.application.config.assets.precompile += %w(*.js *.png *.jpg *.ico)
    ```

4. Add the following to `config/initializers/sass.rb`:
    ```ruby
    bowerrc_dir = JSON.parse(IO.read("#{Rails.root.to_s}/.bowerrc"))['directory']
    govuk_import_paths = JSON.parse(IO.read("#{bowerrc_dir}/govuk-template/paths.json"))['import_paths']
    moj_import_paths = JSON.parse(IO.read("#{bowerrc_dir}/mojular/paths.json"))['import_paths']

    (govuk_import_paths + moj_import_paths).each do |path|
      Sass.load_paths << File.expand_path("#{Rails.root.to_s}/#{bowerrc_dir}/#{path}")
    end
    ```

5. Add the following to `app/controllers/application_controller.rb`
    There are two variants of template: `erb/external` (intendend for public-facing projects) and `erb/internal`
    (for internal projects).

    ```ruby
    layout 'erb/external'

    bowerrc_dir = JSON.parse(IO.read("#{Rails.root.to_s}/.bowerrc"))['directory']
    prepend_view_path(File.expand_path("#{Rails.root.to_s}/#{bowerrc_dir}/mojular/templates"))
    ```
