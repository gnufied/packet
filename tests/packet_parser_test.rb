require File.join(File.dirname(__FILE__),"spec_helper")

context "Packet Parser" do
  include Packet::NbioHelper
  setup do
    @huge_payload = object_dump('H'*65000)
    @array_load = object_dump([1,2,3])
    @packet_parser = Packet::BinParser.new
  end

  specify "should able to parse complete messages" do
    @packet_parser.extract(@huge_payload) do |parsed_data|
      complete_message = Marshal.load(parsed_data)
      complete_message.should == ('H'*65000)
    end
    @packet_parser.data.should.be.empty
    @packet_parser.parser_state.should == 0
    @packet_parser.length_string.should.be.empty
    @packet_parser.numeric_length.should == 0
    @packet_parser.remaining.should.be.empty

    @packet_parser.extract(@array_load) do |parsed_data|
      complete_message = Marshal.load(parsed_data)
      complete_message.should == [1,2,3]
    end
    @packet_parser.data.should.be.empty
    @packet_parser.parser_state.should == 0
    @packet_parser.length_string.should.be.empty
    @packet_parser.numeric_length.should == 0
    @packet_parser.remaining.should.be.empty
  end

  specify "should able to parse incomplete messages" do
    @packet_parser.extract(@array_load[0..1]) do |parsed_data|
      raise "extract succeeded with incomplete message"
    end
    @packet_parser.data.should.be.empty
    @packet_parser.remaining.should.be.empty
    @packet_parser.parser_state.should == 0
    @packet_parser.length_string.should == "00"

    @packet_parser.extract(@array_load[2..10]) do |parsed_data|
      raise "extract succeeded with incomplete message"
    end
    # 11 of 19 bytes has been fed to the parser
    @packet_parser.length_string.should == "000000010"
    @packet_parser.numeric_length.should == 8
    @packet_parser.parser_state.should == 1
    @packet_parser.data[0].should == "\004\b"

    @packet_parser.extract(@array_load[11..16]) do |parsed_data|
      raise "extract succeeded with incomplete message"
    end

    # 17 of 19 bytes has been fed to the parser
    @packet_parser.length_string.should == "000000010"
    @packet_parser.numeric_length.should == 2
    @packet_parser.parser_state.should == 1
    @packet_parser.data.join.should == "\004\b[\bi\006i\a"

    @packet_parser.extract(@array_load[17..18]) do |parsed_data|
      parsed_data.should == "\004\b[\bi\006i\ai\b"
      a = Marshal.load(parsed_data)
      a.should == [1,2,3]
    end
    @packet_parser.length_string.should == ""
    @packet_parser.numeric_length.should == 0
    @packet_parser.parser_state.should == 0
    @packet_parser.data.join.should == ""
  end

  specify "combo messages should be read as well" do
    combo_message = @array_load + @huge_payload #=> len = 65034

    @packet_parser.extract(combo_message[0..100]) do |parsed_data|
      parsed_data.should == "\004\b[\bi\006i\ai\b"
      a = Marshal.load(parsed_data)
      a.should == [1,2,3]
    end

    @packet_parser.length_string.should == "000065006"
    @packet_parser.numeric_length.should == 64933
    @packet_parser.parser_state.should == 1
    @packet_parser.data.join.length.should == 73
  end

end

context "Packet parser for erraneous messages" do
  setup do
    @packet_parser = Packet::BinParser.new
  end

  specify "should reject length with error part" do
    a = "h00000076\004\b{\t:\ttype:\020sync_invoke:\vworker:\017foo_worker:\barg\"\bboy:\022worker_method\"\vbarbar"
    @packet_parser.extract(a) do |parser_data|
      raise "Should not be called"
    end
  end
end
