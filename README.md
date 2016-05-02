# lua-class-lib
A "class" keyword to Lua 5.1!

Lua Class Lib is an OOP tool for Lua. It provides a class 'keyword' to help you do OOP in Lua in an intuitive way. It's similar to OOP in Python but in Lua idiom. So you may feel familiar if you know Python. However you're not required to know Python to use it.

# Class Definition and Instantiation
```
require 'cls'

class 'Worker'  --define class Worker
{
    __init__ = function(self, id)  --initializer
        self.id = id  --initialize instance member
    end;

    showId = function(self)  --method
        print('My worker id is ' .. self.id .. '.')
    end
}

w = Worker(100)  --create an object of Worker
w:showId()       --call Worker's method
```

Output:
```
My worker id is 100.
```

# Inheritance and Polymorphism

```
require 'cls'

--class 'Worker' ... defined as above

class 'Person'
{
    __init__ = function(self, name)
        self.name = name
    end;

    say = function(self)
        print('Hello, my name is ' .. self.name .. '.')
        self:saySthElse()
    end;

    saySthElse = function(self)  --will be override later
    end
}

class 'Employee: Person, Worker'  --Employee inherits Person and Worker
{
    __init__ = function(self, name, salary, id)
        Person.__init__(self, name)  --call base's initializer directly
        Worker.__init__(self, id)
        self.salary = salary
    end;

    saySthElse = function(self)
        print('My salary is ' .. self.salary .. '.')
    end
}

e = Employee('Bob', 1000, 1)
e:say()
e:showId()

```

Output:
```
Hello, my name is Bob.
My salary is 1000.
My worker id is 1.
```

# Next
See https://github.com/coin8086/lua-class-lib/wiki/API-Reference for API details, and https://github.com/coin8086/lua-class-lib/wiki/Lua-and-OOP for a deeper view on OOP and Lua.
