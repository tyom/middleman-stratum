###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page "*/partials/*", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

helpers do
  def pages_for_section(section_name)
    section = data.nav.find do |s|
      s.directory == section_name
    end

    pages = []

    return pages unless section

    if section.directory
      pages << sitemap.resources.select { |r|
        r.path.include?(section.directory + "/") && !r.data.hidden && !r.path.include?(section.directory + "/index.html")
      }.map do |r|
        ::Middleman::Util.recursively_enhance({
          :name   => r.data.menu_label || r.data.title,
          :path   => r.url,
          :order  => r.data.menu_order
        })
      end.sort_by { |p| p.order.to_s || p.path }
    end

    pages << section.pages if section.pages
    pages.flatten
  end
end

# Asset directories
set :css_dir, 'styles'
set :js_dir, 'scripts'
set :images_dir, 'images'

# Dev-specific configuration
configure :development do
  # Reload the browser automatically whenever files change
  activate :livereload
  Slim::Engine.set_default_options pretty: true, sort_attrs: false
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_path, "/Content/images/"
end


# See https://github.com/tvaughan/middleman-deploy
activate :deploy do |deploy|
  deploy.method = :rsync    # :git, :ftp, :sftp, :rsync
  deploy.user = "username"
  deploy.host = "example.com"
  deploy.path = "/path/to/www"
end
