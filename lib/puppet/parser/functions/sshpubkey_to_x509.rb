module Puppet::Parser::Functions
  newfunction(:sshpubkey_to_x509, :type => :rvalue, :doc => <<-EOS
    Converts an SSH public key to an X509 public key.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "sshpubkey_to_x509(): Wrong number of arguments " +
          "given (#{args.size} for 2)") if args.size != 2

    type = args[0]
    key = args[1]

    # Use a tempfile, as using stdin fails
    tmp = Tempfile.new('sshpubkey_to_x509')
    begin
      tmp.puts("#{type} #{key}")
      tmp.close
      Puppet::Util::Execution.execute("ssh-keygen -f #{tmp.path} -e -m pem")
    rescue Puppet::ExecutionFailure => detail
      raise Puppet::ParseError, "Failed to execute ssh-keygen: #{detail}", detail.backtrace
    ensure
      tmp.unlink
    end
  end
end
