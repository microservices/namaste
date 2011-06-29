require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Namaste do
  describe "namaste dublin kernel shortcuts" do
    it "should define the appropriate setters and getters" do
      Dir.mktmpdir do |d|
      dir = Namaste::Dir.new(d)
      dir.respond_to?(:type).should be_true
      dir.respond_to?(:type=).should be_true
      dir.respond_to?(:who).should be_true
      dir.respond_to?(:who=).should be_true
      dir.respond_to?(:what).should be_true
      dir.respond_to?(:what=).should be_true
      dir.respond_to?(:when).should be_true
      dir.respond_to?(:when=).should be_true
      dir.respond_to?(:where).should be_true
      dir.respond_to?(:where=).should be_true
      end
    end
  end

  describe "namaste_tags" do
    before(:each) do
      @tmpdir = Dir.mktmpdir
      @dir = Namaste::Dir.new(@tmpdir)
    end

    after(:each) do
      FileUtils.rm_rf(@tmpdir)
    end

    it "should handle dublin kernel filters correctly" do
      File.open(File.join(@dir.path, "1=last,first"), "w") do |f|
        f.write("Last, First")
      end

      @dir.namaste[:who].should have(1).entries
      tag = @dir.namaste[:who].first
      tag.tag.should == "1"
      tag.value.should == "Last, First"
    end

    it "should handle numeric filters correctly" do
      File.open(File.join(@dir.path, "1=last,first"), "w") do |f|
        f.write("Last, First")
      end

      @dir.namaste[1].should have(1).entries
      tag = @dir.namaste[1].first
      tag.tag.should == "1"
      tag.value.should == "Last, First"
    end

    it "should add new tags" do
      @dir.namaste[1] = "Mahler, Gustav"

      @dir.namaste[1].should have(1).entries
      tag = @dir.namaste[1].first
      tag.tag.should == "1"
      tag.value.should == "Mahler, Gustav"
    end

    it "should append tags" do
      @dir.namaste[1] = "Mahler, Gustav"
      @dir.namaste[1] = "Helsinki Radio Symphony Orchestra"

      @dir.namaste[1].should have(2).entries
    end

    it "should delete tags" do
      @dir.namaste[1] = "Schmidt, Andreas"
      @dir.namaste[1].should have(1).entries
      @dir.namaste[1].first.delete
      @dir.namaste[1].should be_empty
    end

  end
  describe "dirtype" do
    it "should understand the dirtype property" do
      Dir.mktmpdir do |tmpdir|

        File.open(File.join(tmpdir,"0=dflat_0.19"),"w") do |f|
          f.write("Dflat/0.19")
        end

        @dir = Namaste::Dir.new(tmpdir)
        dt = @dir.dirtype

        dt.full.should == "Dflat/0.19"
        dt.name.should == "Dflat"
        dt.major.should == "0"
        dt.minor.should == "19"
      end
    end

  end
end
