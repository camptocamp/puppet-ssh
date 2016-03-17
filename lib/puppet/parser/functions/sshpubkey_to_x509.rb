module Puppet::Parser::Functions
  newfunction(:sshpubkey_to_x509, :type => :rvalue, :doc => <<-EOS
    Converts an SSH public key to an X509 public key.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "sshpubkey_to_x509(): Wrong number of arguments " +
          "given (#{args.size} for 2)") if args.size != 2

    type = args[0]
    key = args[1]

    begin
      # /bin/dash (default in Ubuntu) doesn't support here-strings (<<<)
      Puppet::Util::Execution.execute("bash -c \"ssh-keygen -f /dev/stdin -e -m pem <<<'#{type} #{key}'\"")
    rescue Puppet::ExecutionFailure => detail
      raise Puppet::ParseError, "Failed to execute ssh-keygen: #{detail}", detail.backtrace
    end
  end
end
