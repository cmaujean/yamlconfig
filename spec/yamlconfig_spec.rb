require 'spec_helper'
require 'yamlconfig'

describe YAMLConfig do
  describe "with an empty file" do
    it "does not raise an exception" do
      lambda {
        YAMLConfig.new('spec/data/empty_file')
      }.should_not raise_error
    end
  end
  
  describe "with a non-existent file" do
    it "it raises an exception" do
      lambda {
        YAMLConfig.new('spec/data/missing_file')
      }.should raise_error(Errno::ENOENT)
    end
  end
  
  describe "with complex values" do
    before :each do
      @yc = YAMLConfig.new('spec/data/complex_values')
    end

    it "creates an instance" do
      @yc.kind_of?(YAMLConfig).should be_true
    end
    
    it "parses array values" do
      @yc.arrayval[1].should == "bar"
    end
    
    it "parses hashes" do
      @yc.hashval["foo"].should == "FOO"
    end
  end
  
  describe "#write" do
    before :each do
      @old_file = 'spec/data/accessor_config'
      @new_file = @old_file + '_tmp'
      FileUtils.cp @old_file, @new_file
      
      @yc = YAMLConfig.new @new_file
      @yc['nogoodshits'] = %W(cmaujean erikh PopeKetric)
    end

    it "writes to the same filehandle and reloads" do
      lambda { @yc.write }.should_not raise_error
      @yc['nogoodshits'].should == %W(cmaujean erikh PopeKetric)
      @yc['#nogoodshits'].should == %W(*.bar.com *.example.com) 
    end

    it "writes to a new filehandle and does not reload" do
      FileUtils.rm @new_file rescue true # don't care if the file doesn't exist
      @yc.write @new_file
            
      @yc['nogoodshits'].should == %W(cmaujean erikh PopeKetric)
      @yc['#nogoodshits'].should == %W(*.bar.com *.example.com) 
    end
    
    after :each do
      #FileUtils.rm @new_file rescue true # don't care if the file doesn't exist
    end
  end
  
  describe "#[key]" do
    before :each do
      lambda {
        @yc = YAMLConfig.new('spec/data/accessor_config')
      }.should_not raise_error
    end
    
    it "returns the value for the key requested" do
      @yc['#nogoodshits'].should ==  %W(*.bar.com *.example.com)
    end
    
    it "returns nil for keys that do not exist" do
      @yc['monkey'].should be_nil
    end
  end
  
  describe "#[key]=value" do
    before :each do
      lambda {
        @yc = YAMLConfig.new('spec/data/accessor_config')
      }.should_not raise_error
      @yc['monkey'] = "foo"
    end
    
    it "sets key=value for new keys" do
      @yc['monkey'].should == 'foo'
    end
    
    it "sets key=value for existing keys" do
      @yc['monkey'] = "bar"
      @yc['monkey'].should == "bar"
    end
  end
  
  describe "dynamic accessors" do
    before :each do
      @freakboy = YAMLConfig.new('spec/data/freakboy')
      @config = YAMLConfig.new('spec/data/config')
    end
    
    it "returns the value when a key is called as an accessor" do
      @freakboy.boondongle.should == "foogalicious"
    end
    
    it "it retains different values for different instances" do
      @freakboy.servername.should == 'freakboy'
      @config.servername.should == 'normalfairypoof'
    end
  end
  
  describe "reload_from_file" do
    before :each do
      @yc = YAMLConfig.new('spec/data/freakboy')
      @yc.resource = 'spec/data/flatulentmonkey'
      @yc.reload_from_file
    end
    
    it "should throw NoMethodError for non-existent methods" do
      lambda {
        @yc.boondongle
      }.should raise_error(NoMethodError)
    end
    
    it "should not throw errors for existing methods" do
      @yc.servername.should == 'flatulentmonkey'
    end
  end

  describe "#each" do
    it "iterates the keys and values" do
      f = YAMLConfig.new('spec/data/freakboy')
      f.each do |key,value|
        f[key].should == value
      end
    end
  end
    
  describe "#+" do 
    it "adds the new keys and values to itself" do
      f = YAMLConfig.new('spec/data/freakboy')
      y = { 'a' => '1', 'b' => '2' }
      a = f + y
      f.a.should == '1'
    end
  end
end