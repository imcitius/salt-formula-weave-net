describe file('/usr/local/bin/weave') do
  it { should be_a_file }
  it { should be_executable }
end

describe systemd_service('weave') do
  it { should_not be_enabled }
  it { should_not be_running }
end

describe command('/usr/local/bin/weave version') do
  its(:stdout) { should match(/^weave script 2.5.1/) }
end

['/etc/default/weave', '/etc/sysconfig/weave'].each do |filename|
  if file(filename).exist?
    describe file(filename) do
      it { should be_a_file }
      its(:content) { should match(/WEAVE_PASSWORD="secret"/) }
      its(:content) { should match(/LOG_LEVEL="warning"/) }
    end
  end
end

systemd_unit = "/lib/systemd/system/weave.service"
if file(systemd_unit).exist?
  describe file(systemd_unit) do
    it { should be_a_file }
    its(:content) { should match(/ExecStartPost=\/usr\/local\/bin\/weave expose/) }
  end

  describe file("#{systemd_unit}.d") do
    it { should be_directory }
  end
end