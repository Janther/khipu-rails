module KhipuRails

  extend self

  def configure
    @config = Config.default
    yield @config
  end

  attr_accessor :config
end