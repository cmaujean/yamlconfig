require 'test/unit'
require 'yamlconfig'
require 'fileutils'

class TestConfig < Test::Unit::TestCase
  def test_yaml_empty
    assert_nothing_raised do
      YAMLConfig.new('yamlconfig/test/data/empty_file')
    end
  end

  def test_yaml_complex
    f = YAMLConfig.new('yamlconfig/test/data/complex_values')
    assert_equal(f.arrayval[1], "bar", "array values work")
    assert_equal(f.hashval["foo"], "FOO", "hash values work")
  end

  def test_yaml_write
    old_file = 'yamlconfig/test/data/accessor_config'
    new_file = old_file + '_tmp'
    FileUtils.cp old_file, new_file

    # write to the same filehandle
    f = nil
    assert_nothing_raised do
      f = YAMLConfig.new new_file
      f['nogoodshits'] = %W(cmaujean erikh PopeKetric)
      f.write
    end

    # test that it reloads properly
        
    assert_equal f['nogoodshits'], %W(cmaujean erikh PopeKetric)
    assert_equal f['#nogoodshits'], %W(*.bar.com *.example.com) 

    FileUtils.rm new_file

    # write to a new filehandle

    assert_nothing_raised do
      f.write new_file
      f = YAMLConfig.new new_file
    end

    # test that it created the right data

    assert_equal f['nogoodshits'], %W(cmaujean erikh PopeKetric)
    assert_equal f['#nogoodshits'], %W(*.bar.com *.example.com) 

    FileUtils.rm new_file

  end

  def test_array_accessor
    f = nil
    assert_nothing_raised do
      f = YAMLConfig.new('yamlconfig/test/data/accessor_config')
    end
    assert_equal f['#nogoodshits'],  %W(*.bar.com *.example.com)
    assert_nil f['monkey']

    assert_nothing_raised do
      f['monkey'] = "foo"
    end

    assert_equal f['monkey'], 'foo'
  end

  def test_accessors 
    f = YAMLConfig.new('yamlconfig/test/data/freakboy')
    g = YAMLConfig.new('yamlconfig/test/data/config')
  
    assert_equal f.servername, 'freakboy'
    assert_equal g.servername, 'normalfairypoof'
    assert_equal f.boondongle, 'foogalicious'

  end
  

  def test_reload
    f = YAMLConfig.new('yamlconfig/test/data/freakboy')
    f.resource = 'yamlconfig/test/data/flatulentmonkey'
    f.reload
    begin
      f.boondongle
    rescue NoMethodError
      assert(true, "NoMethodError was triggered for boondongle")
    else
      assert(false, "NoMethodError was not triggered! something is wrong, return was #{f.boondongle}")
    end
    assert_equal f.servername, 'flatulentmonkey'
  end

  def test_each
    f = YAMLConfig.new('yamlconfig/test/data/freakboy')
    f.each do |key,value|
      assert f[key] == value, "part of the each tests, f[#{key}] == #{value}"
    end
  end
  
  def test_plus
    f = YAMLConfig.new('yamlconfig/test/data/freakboy')
    y = { 'a' => '1', 'b' => '2' }
    a = f + y
    assert_equal '1', f.a 
  end
end

# vi:sw=2 ts=2
