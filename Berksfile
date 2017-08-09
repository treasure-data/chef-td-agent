source "https://api.berkshelf.com"

metadata

cookbook "apt"
cookbook "yum"

group :integration do
  cookbook 'smoke', :path => './test/fixtures/smoke'
end
