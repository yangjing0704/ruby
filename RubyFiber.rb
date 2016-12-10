require 'fiber' 
COUNT=500_0000
fun1=Fiber.new do
  COUNT.times{Fiber.yield }
end
fun2=Fiber.new do
  COUNT.times{Fiber.yield }
end

arr =[]
arr.push fun1
arr.push fun2
loop do
  sleep 0.05 if arr.empty?
  arr.each{|fun| fun.alive? ? fun.resume : arr.delete(fun)}
end



#~ q = Queue.new
#~ q.push fun1
#~ q.push fun2

#~ loop do
#~ sleep 0.01 if q.empty?
#~ fun = q.pop
#~ if fun.alive? 
#~ fun.resume
#~ q.push(fun) 
#~ end
#~ end



#f1.resume if f1.alive?
#f2.resume if f2.alive?
