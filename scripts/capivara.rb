#!/usr/bin/env ruby

require 'capybara'
require 'capybara/dsl'

# Configura o driver do Capybara para usar o navegador Chrome
Capybara.default_driver = :selenium_chrome

# Inicializa o módulo DSL do Capybara
include Capybara::DSL

# Visita a página do Google
visit 'https://www.google.com/'
# visit 'https://github.com/jesherdevsk8'

# Preenche o campo de busca com "capivara" e envia o formulário
fill_in 'q', with: 'capivara'
find('input[name="btnK"]').click

sleep(20)
