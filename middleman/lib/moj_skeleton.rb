class MoJSkeleton < ::Middleman::Extension
  def initialize(app, options_hash={})
    super
    require_relative './method_missing'

    bowerrc_dir = JSON.parse(IO.read("#{app.root}/.bowerrc"))['directory']
    mojular_dir = File.join(bowerrc_dir, 'mojular')
    moj_assets = File.join(app.root, mojular_dir, 'assets')
    govuk_assets = File.join(app.root, bowerrc_dir, 'govuk-template', 'assets')

    app.compass_config do |config|
      govuk_import_paths = JSON.parse(IO.read("#{bowerrc_dir}/govuk-template/paths.json"))['import_paths']
      moj_import_paths = JSON.parse(IO.read("#{bowerrc_dir}/mojular/paths.json"))['import_paths']

      (govuk_import_paths + moj_import_paths).each do |path|
        config.add_import_path("../#{bowerrc_dir}/#{path}")
      end
    end

    # app.set :layouts_dir, File.join('..', mojular_dir, 'layouts') # relative to `source/` dir
    # app.set :layout, 'erb/base'

    app.ready do
      sprockets.append_path File.join(app.root, bowerrc_dir)
      sprockets.import_asset('jquery')

      sprockets.append_path moj_assets
      Dir.chdir(moj_assets) do
        Dir['**/*.{js,png,jpg}'].each do |asset|
          sprockets.import_asset(asset) do |logical_path|
            logical_path
          end
        end
      end
      sprockets.append_path govuk_assets
      Dir.chdir(govuk_assets) do
        Dir['**/*.{js,png,jpg,ico}'].each do |asset|
          sprockets.import_asset(asset) do |logical_path|
            logical_path
          end
        end
      end
    end
  end

  helpers do
  end
end

::Middleman::Extensions.register(:moj_skeleton, MoJSkeleton)
