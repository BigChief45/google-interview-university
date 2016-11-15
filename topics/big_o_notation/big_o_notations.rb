require 'benchmark'

@my_array = (1..10_000_000).to_a

# O(1)
def add_element(element)
  @my_array.push(element)
end

# O(N)
def linear_search(value)
  @my_array.each { |i| return i if i == value }
end

# O(N^2)
def bubble_sort(array)
  n = array.length

  loop do
    swapped = false

    (n-1).times do |i|
      if array[i] > array[i+1]
        array[i], array[i+1] = array[i+1], array[i]
        swapped = true
      end
    end
    break if not swapped
  end

  array
end

# O( log N )
# Occurs when data being used decreases roughly by 50% each time through the algorithm
# log N algorithms are very efficient because increases in the amount of data have little
# to no effect at some point early on because the amount of data is half each time.
def binary_search(array, element, low=0, high=array.length-1)
  return nil if high < low

  mid = ( low + high ) / 2

  if array[mid] > element
    return binary_search(array, element, low, mid - 1)
  elsif array[mid] < element
    return binary_search(array, element, mid + 1, high)
  else
    return mid
  end
end

# O( N log N )
# comparisons = log n!
# comparisons = log n + log(n-1) + ... + log(1)
# comparisons = n log n
def quick_sort(array)
  return array if array.length <= 1

  pivot = array[0]

  less, greatereq = array[1..-1].partition { |x| x < pivot }
  quick_sort(less) + [pivot] + quick_sort(greatereq)
end

Benchmark.bm(50) do |x|
  x.report("add_element") { add_element(10) }
  puts

  x.report("linear_search(1,000)") { linear_search(1000) }
  x.report("linear_search(10,000,000)") { linear_search(10_000_000) }
  puts

  x.report("bubble_sort([1..10])") { bubble_sort((1..10).to_a.shuffle) }
  x.report("bubble_sort([1..10,000])") { bubble_sort((1..10_000).to_a.shuffle) }
  puts

  x.report("binary_search([1..10])") { binary_search((1..10).to_a, 4) }
  x.report("binary_search([1..5,000,000])") { binary_search((1..5_000_000).to_a, 4_999_999) }
  puts

  x.report("quick_sort([1..20])") { quick_sort((1..20).to_a.shuffle) }
  x.report("quick_sort([1..400,000])") { quick_sort((1..400_000).to_a.shuffle) }
end