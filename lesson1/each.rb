def each(arr)
  idx = 0
  while idx < arr.size
    yield(arr[idx])
    idx += 1
  end
  arr
end

result = each([1, 2, 3]) { |num| puts num }
p result
