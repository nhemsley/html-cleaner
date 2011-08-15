require 'sinatra'
require 'haml'
require 'haml/html'
require './cleaner'
require 'tempfile'

REMOVE_ATTRS = ["width", "height", "cellpadding", "cellspacing", "valign", "halign"]

get '/' do
  @remove_tags = params[:remove_tags].split(",") rescue []
  @remove_attrs = REMOVE_ATTRS
  haml :index
end

post '/clean' do
  @remove_tags = params[:remove_tags].split(",") rescue []
  @remove_attrs = params[:remove_attrs].split(",") || []
  cleaner = Cleaner.new(params[:html], {:remove_tags => @remove_tags, :remove_attrs => @remove_attrs})
  @cleaned = cleaner.render
  
  # path = ""
  # Tempfile.open("html") do |f|
  #   f.write(@cleaned.to_s)
  #   path = f.path
  # end
  # puts "xmllinting"
  # @cleaned = `xmllint --format #{path}`
  # puts @cleaned
  
  
  @haml = convert(@cleaned)
  haml :index
end

def convert(html)
  Haml::HTML.new(html, :xhtml => true).render
end
