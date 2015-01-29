bowerrc_dir = JSON.parse(IO.read("#{Rails.root.to_s}/.bowerrc"))['directory']
govuk_import_paths = JSON.parse(IO.read("#{bowerrc_dir}/govuk-template/paths.json"))['import_paths']
moj_import_paths = JSON.parse(IO.read("#{bowerrc_dir}/mojular/paths.json"))['import_paths']

(govuk_import_paths + moj_import_paths).each do |path|
  Sass.load_paths << File.expand_path("#{Rails.root.to_s}/#{bowerrc_dir}/#{path}")
end
