def reduce(arr, acc = nil)
  idx = 0
  acc, idx = arr[0], 1 if acc.nil?
  while idx < arr.size
    acc = yield(acc, arr[idx])
    idx += 1
  end
  acc
end

array = [1, 2, 3, 4, 5]

p reduce(array) { |acc, num| acc + num }               # => 15
p reduce(array, 10) { |acc, num| acc + num }           # => 25
p reduce(array) { |acc, num| acc + num if num.odd? }   # => NoMethodError: undefined method `+' for nil:NilClass
