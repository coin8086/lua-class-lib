require 'cls'

module(..., package.seeall)

class 'Person'
{
    __init__ = function(self, name)
        self.name = name
    end;

    say = function(self)
        print('Hello, my name is ' .. self.name .. '.')
        self:saySthElse()
    end;

    saySthElse = function(self)
    end
}

class 'Worker'
{
    __init__ = function(self, id)
        self.id = id
    end;

    showId = function(self)
        print('My worker id is ' .. self.id .. '.')
    end
}

class 'Employee: Person, Worker'
{
    __init__ = function(self, name, salary, id)
        Person.__init__(self, name)
        Worker.__init__(self, id)
        self.salary = salary
    end;

    saySthElse = function(self)
        print('My salary is ' .. self.salary .. '.')
    end
}
