# Activity: Final Project: Soccer Pool
# Date: 26-Nov-2015
# Authors:
#        A01370815 Diego Galindez Barreda
#        A01165957 Saul de Nova Caballero
#        A01169999 Rodrigo Villalobos Sánchez

require 'sinatra'

get '/' do
  "Hello world!"
end

get '/:name' do
  "Hello #{params['name']}!"
end
