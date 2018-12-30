describe file('/usr/local/bin/weave') do
  it { should be_a_file }
  it { should be_executable }
end

describe service('weave') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe command('/usr/local/bin/weave version') do
  its(:stdout) { should match(/^weave script 2.5.0/) }
end

['/etc/default/weave', '/etc/sysconfig/weave'].each do |filename|
  if file(filename).exist?
    describe file(filename) do
      it { should be_a_file }
      its(:content) { should match(/WEAVE_PASSWORD='secret'/) }
      its(:content) { should match(/LOG_LEVEL='warning'/) }
    end
  end
end

describe command('/usr/local/bin/weave status') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Version: 2.5.0/) }
  its(:stdout) { should match(/Service: router/) }
  its(:stdout) { should match(/Encryption: enabled/) }
  its(:stdout) { should match(/Status: idle/) }
end

# weaveDNS
describe port(53) do
  it { should be_listening }
  its(:processes) { should include 'weaver' }
  its(:protocols) { should include 'tcp' }
  its(:protocols) { should include 'udp' }
end

describe port(6782) do
  it { should be_listening }
  its(:processes) { should include 'weaver' }
end

describe port(6783) do
  it { should be_listening }
  its(:processes) { should include 'weaver' }
end

describe port(6784) do
  it { should be_listening }
  its(:processes) { should include 'weaver' }
end