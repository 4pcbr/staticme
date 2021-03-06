module Staticme

  module Arguments

    ARGS  = {
      :path       => {
        :short      => 'f',
        :default    => Proc.new { Dir.pwd }
      },
      :port       => {
        :short    => 'p',
        :default    => 8080,
        :sanitizer  => Proc.new { |v| v.to_i }
      },
      :host       => {
        :short      => 'h',
        :default    => '0.0.0.0'
      },
      :index      => {
        :short      => 'i',
        :default    => 'index.html'
      },
      :ws_port    => {
        :short      => 'ws',
        :default    => 8090,
      }
    }

    def parse_input(argv)
      params = Hash.new

      ARGS.each_pair do |param_name, param_attrs|
        param_shorten_name = param_attrs[:shorten]
        default = param_attrs[:default]
        sanitizer = param_attrs[:sanitizer]
        param_value = argv["--#{param_name}"] ||
                      ( param_shorten_name.nil? ? nil : argv["-#{param_shorten_name}"] ) ||
                      ( default.is_a?(Proc) ? default.call : default )
        ( param_value = sanitizer.call( param_value ) ) if sanitizer.is_a? Proc

        if !param_value.nil?
          params[param_name] = param_value
        end
      end

      params
    end

  end

end
