module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @path_regex = regex_to(path)
        @controller = controller
        @action = action
      end

      def match?(method, path)
        @method == method && path =~ @path_regex
      end

      def add_params(env, path)
        env['simpler.params'] = path.match(@path_regex).named_captures.transform_keys!(&:to_sym)
      end

      def regex_to(path)
        regex = path.split('/').
                   map { |p| p.start_with?(':') ? "(?<#{p.delete_prefix(':')}>\\w+)" : p }.
                   join('/')

        Regexp.new('^' + regex + '$')
      end
    end
  end
end
