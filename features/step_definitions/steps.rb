require 'test/unit/assertions'
World(Test::Unit::Assertions)

a = 0
b = 0

Given /^a is two$/ do 
a = 2
end

Given /^b is two$/ do 
b = 2
end

Then /^a plus b equals four$/ do
assert_equal(4, a+b)
end
