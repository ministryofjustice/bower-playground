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
    app.set :partials_dir, File.join('..', mojular_dir, 'templates') # relative to `source/` dir

    app.ready do
      sprockets.append_path File.join(app.root, bowerrc_dir)
      sprockets.import_asset('jquery')

      sprockets.append_path moj_assets
      Dir.chdir(moj_assets) do
        Dir['**/*.{js,png,jpg}'].each do |asset|
          # Rewrite sprockets logical paths to use assets dir defined in config
          root_dir = asset.split(File::SEPARATOR).shift
          sprockets.import_asset(asset) do |logical_path|
            case logical_path.extname
            when '.js'
              logical_path.sub(root_dir, app.config.js_dir)
            else
              logical_path.sub(root_dir, app.config.images_dir)
            end
          end
        end
      end
      sprockets.append_path govuk_assets
      Dir.chdir(govuk_assets) do
        Dir['**/*.{js,png,jpg,ico}'].each do |asset|
          # Rewrite sprockets logical paths to use assets dir defined in config
          sprockets.import_asset(asset) do |logical_path|
            root_dir = asset.split(File::SEPARATOR).shift
            case logical_path.extname
            when '.js'
              logical_path.sub(root_dir, app.config.js_dir)
            else
              logical_path.sub(root_dir, app.config.images_dir)
            end
          end
        end
      end
    end
  end
end

::Middleman::Extensions.register(:moj_skeleton, MoJSkeleton)
