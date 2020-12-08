class ApplicationService
  class << self
    def delay_call(*args, &block)
      delay.call(*args, &block)
    end

    def call(*args, &block)
      new(*args, &block).call
    end
  end

  def initialize(*, _block)
    raise_not_implemented!
  end

  def call
    raise_not_implemented!
  end

  private

  def raise_not_implemented!
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
