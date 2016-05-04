require 'test_helper'

class JobTest < ActiveSupport::TestCase

  test "should not save job without title" do
    job = Job.new
    assert_not job.save
  end
  test "should not save job without company" do
    job = Job.new
    assert_not job.save
  end
  test "should not save job without description" do
    job = Job.new
    assert_not job.save
  end
  
end
