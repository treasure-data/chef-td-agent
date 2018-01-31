source "https://api.berkshelf.com"

metadata

cookbook 'apt'
cookbook 'yum'

group :development do
  cookbook 'td-agent-spec', path: './test/fixtures/td-agent-spec'
end

group :integration do
  cookbook 'smoke', :path => './test/fixtures/smoke'
end
