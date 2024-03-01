require 'puppeteer'
require 'nokogiri'

Puppeteer.launch(headless: false, executable_path: '/usr/bin/google-chrome').then do |browser|
  browser.pages.then do |pages|
    page = pages.first
    page.goto('https://master--unique-begonia-ec585f.netlify.app/')

    page.wait_for_selector('input[placeholder="Username"]').then do
      page.wait_for_selector('input[placeholder="Password"]').then do
        page.wait_for_selector('button[type="button"]').then do

          nameInput = page.query_selector('[placeholder="Username"]')
          nameInput.click
          page.keyboard.type_text("admin")

          passwordInput = page.query_selector('[placeholder="Password"]')
          passwordInput.click
          page.keyboard.type_text("admin")

          button = page.query_selector('button[type="button"]')
          button.click.then do
            puts "Le bouton a été cliqué avec succès"

            page.wait_for_timeout(3000).then do
              puts "Connexion réussie"

              page.content.then do |content|
              html_doc = Nokogiri::HTML.parse(content)

              def create_array(html_doc, selector)
                array = []
                html_doc.search(selector).each do |element|
                  text = element.text.strip
                  array << text
                end
                return array
              end

              names = create_array(html_doc, "th.css-q34dxg")

              names.map! do |th|
                t = th.split(" ")
                t.pop
                t.join(" ")
              end

              links = create_array(html_doc,"tr td:nth-child(2)")
              categories = create_array(html_doc,"tr td:nth-child(3)")
              keywords = create_array(html_doc,"tr td:nth-child(4)")
              comments = create_array(html_doc,"tr td:nth-child(5)")

              print names
              print links
              print categories
              print keywords
              print comments

              browser.close
              end
            end
          end
        end
      end
    end
  end
end
