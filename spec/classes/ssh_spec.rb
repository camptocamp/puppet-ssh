require 'spec_helper'

describe 'ssh' do
  let(:facts) {{
    :osfamily => 'Debian',
  }}
  it { should compile.with_all_deps }
end
