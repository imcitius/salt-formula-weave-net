describe file('/usr/local/bin/weave') do
  it { should be_a_file }
  it { should be_executable }
end

describe systemd_service('weave') do
  it { should be_enabled }
  it { should be_running }
end

describe command('/usr/local/bin/weave version') do
  its(:stdout) { should match(/^weave script 2.5.1/) }
end

describe command('/usr/local/bin/weave status') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Version: 2.5.1/) }
  its(:stdout) { should match(/Service: router/) }
  its(:stdout) { should match(/Encryption: disabled/) }
  its(:stdout) { should match(/Status: (idle|ready)/) }
end

systemd_unit = "/lib/systemd/system/weave.service"
if file(systemd_unit).exist?
  describe file(systemd_unit) do
    it { should be_a_file }
    its(:content) { should_not match(/ExecStartPost=\/usr\/local\/bin\/weave expose/) }
  end

  describe file("#{systemd_unit}.d") do
    it { should be_directory }
  end
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