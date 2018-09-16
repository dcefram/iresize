require "./spec_helper"

describe IResize do
  input_path = "./spec/"
  output_path = "./spec/output"
  height = "720"
  width = nil
  test_jpg = "./spec/test1.jpg"
  test_png = "./spec/test2.png"

  resizer = IResize::Resizer.new({
    :input_path  => input_path,
    :output_path => output_path,
    :height      => height,
    :width       => width,
  })

  Spec.before_each {
    resizer = IResize::Resizer.new({
      :input_path  => input_path,
      :output_path => output_path,
      :height      => height,
      :width       => width,
    })
  }

  it "should be able to get the path type" do
    resizer.get_path_type(input_path).should eq(File::Type::Directory)
  end

  it "should be able to calculate the correct width" do
    resizer = IResize::Resizer.new({
      :input_path  => test_jpg,
      :output_path => output_path,
      :height      => height,
      :width       => width,
    })

    resizer.calculate_with_aspect_ratio({
      :width  => 1920.to_f32,
      :height => 1080.to_f32,
    }).should eq({
      :width  => 1280.to_f32,
      :height => 720.to_f32,
    })
  end

  it "should be able to list files if a directory is the input_path" do
    resizer.list_files.empty?.should be_false
  end

  it "should be able to verify valid extensions" do
    resizer.is_valid_ext(File.join(input_path, "spec_helper.cr")).should be_false
    resizer.is_valid_ext(test_jpg).should be_true
    resizer.is_valid_ext(test_png).should be_true
  end

  # @TODO: I'm not yet sure as to how to verify that the generated images
  # has the correct dimentions... without using LibMagick...
  it "should be able to generate resized images" do
    resizer.process

    File.exists?(File.join(output_path, "test1.jpg")).should be_true
    File.exists?(File.join(output_path, "test2.png")).should be_true
    File.exists?(File.join(output_path, "invalid.cr")).should be_false
  end
end
