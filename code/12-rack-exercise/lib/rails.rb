module Rails
  autoload :Application, "rails/application"

  def self.env
    ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "development"
  end

  def self.groups
    [:default, env]
  end

  def self.application
    Application.instance
  end

  def self.root
    application.root
  end
end