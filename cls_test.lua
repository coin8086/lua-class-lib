require 'cls_demos'

print '--------------------------------------------'

p = cls_demos.Person('Bob')
p:say()

p2 = cls_demos.Person('David')
p2:say()

print '--------------------------------------------'

e = cls_demos.Employee('Bob', 1000, 1)
e:say()
e:showId()

e2 = cls_demos.Employee('Alice', 10000, 2)
e2:say()
e2:showId()

print '--------------------------------------------'

if isInstanceOf(e, cls_demos.Person) then
    print 'e is an instance of Person'
else
    print 'e is not an instance of Person'
end

if isInstanceOf(e, cls_demos.Worker) then
    print 'e is an instance of Worker'
else
    print 'e is not an instance of Worker'
end

w = cls_demos.Worker(100)

if isInstanceOf(w, cls_demos.Person) then
    print 'w is an instance of Person'
else
    print 'w is not an instance of Person'
end

if isInstanceOf(w, cls_demos.Worker) then
    print 'w is an instance of Worker'
else
    print 'w is not an instance of Worker'
end
