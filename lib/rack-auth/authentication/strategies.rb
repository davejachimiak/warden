module Rack
  module Auth
    module Strategies
      class << self
        
        # Adds a strategy to the grab-bag of strategies available to use.
        # A strategy is a place where you can put logic related to authentication.
        # A strategy inherits from Rack::Auth::Strategies::Base.  The _add_ method provides a clean way
        # to declare your strategies.  
        # You _must_ declare an @authenticate!@ method.
        # You _may_ provide a @valid?@ method.
        # The valid method should return true or false depending on if the strategy is a valid one for the request.
        # 
        # Parameters: 
        #   <label: Symbol> The label is the name given to a strategy.  Use the label to refer to the strategy when authenticating
        #   <strategy: Class|nil> The optional stragtegy argument if set _must_ be a class that inherits from Rack::Auth::Strategies::Base and _must_
        #                         implement an @authenticate!@ method
        #   <block> The block acts as a convinient way to declare your strategy.  Inside is the class definition of a strategy.
        #
        # Examples:
        #
        #   Block Declared Strategy:
        #    Rack::Auth::Strategies.add(:foo) do
        #      def authenticate!
        #        # authentication logic
        #      end
        #    end
        #
        #    Class Declared Strategy:
        #      Rack::Auth::Strategies.add(:foo, MyStrategy)
        #
        # :api: public
        def add(label, strategy = nil, &blk)
          strategy = strategy.nil? ? Class.new(Rack::Auth::Strategies::Base, &blk) : strategy
          raise NoMethodError, "authenitate! is not declared in the #{label} strategy" if !strategy.instance_methods.include?("authenticate!")
          raise "#{label.inspect} is Not a Rack::Auth::Strategy::Base" if !strategy.ancestors.include?(Rack::Auth::Strategies::Base)
          _strategies[label] = strategy
        end
        
        # Provides access to declared strategies by label
        # :api: public
        def [](label)
          _strategies[label]
        end
        
        # Clears all declared middleware.
        # :api: public
        def clear!
          @strategies = {}
        end

        # :api: private
        def _strategies
          @strategies ||= {}
        end
      end # << self
      
    end # Strategies
  end # Auth
end # Rack
