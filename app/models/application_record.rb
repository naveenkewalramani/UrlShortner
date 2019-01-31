class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  require 'rdoc/task'
  RDoc::Task.new do |rdoc|
    rdoc.main = "README.rdoc"
    rdoc.rdoc_files.include("README.rdoc", "lib   /*.rb")
  end
end
