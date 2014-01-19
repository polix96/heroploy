module ShellSupport
  def stub_shell
    Shell.stub(:eval).and_return("")
    Shell.stub(:exec)
  end
  
  def expect_command(cmd = nil)
    if cmd.nil?
      expect(Shell).to receive(:exec)
    else
      expect(Shell).to receive(:exec).with(cmd)
    end
  end
  
  def expect_eval(cmd = nil)
    if cmd.nil?
      expect(Shell).to receive(:eval)
    else
      expect(Shell).to receive(:eval).with(cmd)
    end
  end
end