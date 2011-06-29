require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Namaste::Tag" do
  describe "filename" do
    it "should handle a simple value" do
      Namaste::Tag.filename(0, 'abcdef').should == "0=abcdef"
    end
    it "should properly handle dflat" do
      Namaste::Tag.filename(0, 'Dflat/0.19').should == "0=dflat_0.19"
    end
    it "should handle compled values correctly" do
      Namaste::Tag.filename(0, 'rQ@f2!éüAsd!').should == "0=rq_f2_euasd_"
    end
    it "should handle extended integers correctly" do
      Namaste::Tag.filename('x_123', 'extended').should == "x_123=extended"
    end
    it "should truncate file name at 255 characters" do
      namaste = Namaste::Tag.filename(0, 'lfvtshfasfogfzjgqokuwicivlnyluqlgfcsfmhtdbmrizvzqkiyaxqtlclkgxpgkmxtwwylepsorbdnddgrdgzpcyojqbwuxkqkfzmfbkxrfpaaymgygbpjgqxyklkfblqekgtrpdxvjsmodvkrlwcfrqswdknngervsjivehotqeiowigfpwymunrccgjhakdwpugwwtpqcpkwqvwlhcqccwqovlwaldwfuoalscdvzccgnpooedbrnttzmno')
      namaste.length.should == 255
      namaste.should == '0=lfvtshfasfogfzjgqokuwicivlnyluqlgfcsfmhtdbmrizvzqkiyaxqtlclkgxpgkmxtwwylepsorbdnddgrdgzpcyojqbwuxkqkfzmfbkxrfpaaymgygbpjgqxyklkfblqekgtrpdxvjsmodvkrlwcfrqswdknngervsjivehotqeiowigfpwymunrccgjhakdwpugwwtpqcpkwqvwlhcqccwqovlwaldwfuoalscdvzccgnpooedbrnt...'
    end
  end

  describe "new tag file" do
    it "should create a new file" do
      Dir.mktmpdir do |dir|
        file = File.join(dir, "1=value")
        tag = Namaste::Tag.new(dir, 1, 'value')
        tag.send(:filename).should == "1=value"
        tag.send(:file).path.should == file
        File.should exist(file)
        File.new(file).read.should == "value"
      end
    end
  end

  describe "opening an existing tag file" do
    it "should load tag and value" do
      Dir.mktmpdir do |dir|
        file = File.join(dir, "2=asdfg")
        File.open(file, "w+") { |f| f.write("asdfg"); f.flush }

        tag = Namaste::Tag.new(file)
        tag.send(:file).path.should == file
        tag.tag.should == "2"
        tag.value.should == "asdfg"
     end
    end

  end

  describe "writing a new value" do
    it "should delete and re-add a tag when the tag is changed" do
      Dir.mktmpdir do |dir|
        file = File.join(dir, "2=asdfg")
        File.open(file, "w+") { |f| f.write("asdfg"); f.flush }

        tag = Namaste::Tag.new(file)
        tag.tag = 1

        File.should_not exist(file)
        File.should exist(File.join(dir, "1=asdfg"))
     end

    end
    it "should delete and re-add a tag when the value is changed" do
      Dir.mktmpdir do |dir|
        file = File.join(dir, "2=asdfg")
        File.open(file, "w+") { |f| f.write("asdfg"); f.flush }

        tag = Namaste::Tag.new(file)
        tag.value = 'qwerty'

        File.should_not exist(file)
        File.should exist(File.join(dir, "2=qwerty"))
     end
    end
  end

  describe "deleting a tag" do

  end

end
