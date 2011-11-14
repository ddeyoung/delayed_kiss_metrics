require 'spec_helper'

describe DelayedKiss do
  before(:each) do
    DelayedKiss.cache_config
  end
  
  after(:each) do
    DelayedKiss.reset_config
  end
  
  describe :configure do
    it "should configure the key" do
      test_key = "youraikeyvalue"
      DelayedKiss.configure do |config|
        config.key = test_key
      end
      
      DelayedKiss.key.should == test_key
    end
  end
  
  describe :record do
    it "should send a request to the KISSmetrics API when valid parameters are supplied" do
     HTTParty.expects(:get).once.returns(true)
     DelayedKiss.record("identity", "event")
    end
    
    it "should raise an error without an identity" do
      HTTParty.expects(:get).never
      expect { DelayedKiss.record(nil, "event") }.to raise_error(ArgumentError)
    end
    
    it "should raise an error without an event" do
      expect { DelayedKiss.record("identity", nil) }.to raise_error(ArgumentError)
    end
    
    it "should send a request to the KISSmetrics API with custom properties in the URL's query string" do
      HTTParty.expects(:get).with(regexp_matches(/type=crazy/)).returns(true)
      DelayedKiss.record("identity", "event", {:type => "crazy"})
    end
    
    it "should raise an error if the key is not configured and the whiny config is turned on" do
      DelayedKiss.key = nil
      DelayedKiss.whiny_config = true
      expect { DelayedKiss.record("identity", "event") }.to raise_error(DelayedKiss::ConfigurationError)
    end
    
    it "should not raise an error if the key is not configured and the whiny config is turned off" do
      DelayedKiss.whiny_config = false
      expect { DelayedKiss.record("identity", "event") }.to_not raise_error(DelayedKiss::ConfigurationError)
    end
    
    it "should not send a request to the KISSmetrics API if the API key is blank and the whiny config is turned off" do
      HTTParty.expects(:get).never
      
      DelayedKiss.key = nil
      DelayedKiss.whiny_config = false
      DelayedKiss.record("identity", "event")
    end
  end
  
  describe :alias do
    it "should send a request to the KISSmetrics API when valid parameters are supplied" do
      HTTParty.expects(:get).once.returns(true)
      DelayedKiss.alias("oldname", "newname")
    end
    
    it "should include the from alias in the query string" do
      HTTParty.expects(:get).with(regexp_matches(/_p=oldname/)).returns(true)
      DelayedKiss.alias("oldname", "newname")
    end
    
    it "should include the to alias in the query string" do
      HTTParty.expects(:get).with(regexp_matches(/_n=newname/)).returns(true)
      DelayedKiss.alias("oldname", "newname")
    end
    
    it "should raise an error without a from alias" do
      expect { DelayedKiss.alias(nil, "newname") }.to raise_error(ArgumentError)
    end
    
    it "should raise an error without a to alias" do
      expect { DelayedKiss.alias("oldname", nil) }.to raise_error(ArgumentError)
    end
    
    it "should raise an error if the key is not configured and the whiny config is turned on" do
      DelayedKiss.key = nil
      DelayedKiss.whiny_config = true
      expect { DelayedKiss.alias("oldname", "newname") }.to raise_error(DelayedKiss::ConfigurationError)
    end
    
    it "should not raise an error if the key is not configured and the whiny config is turned off" do
      DelayedKiss.whiny_config = false
      expect { DelayedKiss.alias("oldname", "newname") }.to_not raise_error(DelayedKiss::ConfigurationError)
    end
    
    it "should not send a request to the KISSmetrics API if the API key is blank and the whiny config is turned off" do
      HTTParty.expects(:get).never
      
      DelayedKiss.key = nil
      DelayedKiss.whiny_config = false
      DelayedKiss.alias("oldname", "newname")
    end
  end
  
  describe :set do
    it "should send a request to the KISSmetrics API when valid parameters are supplied" do
      HTTParty.expects(:get).once.returns(true)
      DelayedKiss.set("identity", {:gender => :male})
    end
    
    it "should include the set properties in the query string" do
      HTTParty.expects(:get).with(regexp_matches(/age=27/)).returns(true)
      DelayedKiss.set("identity", {:age => 27})
    end
    
    it "should not send a reuqest to the KISSmetrics API when the set paramters are blank" do
      HTTParty.expects(:get).never
      DelayedKiss.set("identity", {})
    end
    
    it "raises an error without an identity" do
      expect { DelayedKiss.set(nil, {:gener => :female}) }.to raise_error(ArgumentError)
    end
    
    it "should raise an error if the key is not configured and the whiny config is turned on" do
      DelayedKiss.key = nil
      DelayedKiss.whiny_config = true
      expect { DelayedKiss.set("identity", {:occupation => "Lab Rat"}) }.to raise_error(DelayedKiss::ConfigurationError)
    end
    
    it "should not raise an error if the key is not configured and the whiny config is turned off" do
      DelayedKiss.whiny_config = false
      expect { DelayedKiss.set("identity", {:age => "old"}) }.to_not raise_error(DelayedKiss::ConfigurationError)
    end
    
    it "should not send a request to the KISSmetrics API if the API key is blank and the whiny config is turned off" do
      HTTParty.expects(:get).never
      
      DelayedKiss.key = nil
      DelayedKiss.whiny_config = false
      DelayedKiss.set("identity", {:education => "college"})
    end
  end
end