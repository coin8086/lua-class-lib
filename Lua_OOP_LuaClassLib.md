_(This article presumes readers have a basic knowledge on Lua. And to understand the last part, "Design and Implementation", a good Lua knowledge is required and some knowledge on Python OOP is a plus.)_

# Index #


Why Lua Class Lib? Why Lua? Why OOP? Just for fun, relax! Let's take an interesting tour to OOP in Lua.

# A Long Story About OOP in Lua #
Lua is cool! "But it lacks for full support for OOP!" you may argue that. Sure, I agree with you, if your standard for OOP is just a 'class' key word or something alike, which may disappoint you when you do a full search of that word in Lua official document and only find something totally unrelated! The fact is exactly that. However, there's more.

## Object ##
Let's drop those superficial forms of OOP and be after its essence: what on earth an object is? In concept, it's just something that has status and behavior. In implementation, an object's status is usually kept in some properties on it, and its behavior is usually defined by some methods on it. That's it!

According to that definition, a Lua table is just a good implementation of that OO concept:
```
t = {}                                           --t is an object
t.status = 100                                   --t has some property
t.method = function(self) print self.status end  --also some method
```

## Class ##
"But what about the class?" you may ask. Good question! But first let's make it clear: what on earth does a 'class' mean? In concept, it simply means a category: objects in the same category have something in common. In implementation, it usually means some way to create an object of a category.

According to that definition, the object t in above code does have a class: an anonymous category in concept. You can create another object in that conceptual 'class' as:
```
t2 = {}                                           --t2 is another object of the same 'class' as t
t2.status = 101                                   --t2 has a different status
t2.method = function(self) print self.status end  --and the same method
```

Or, make the code reusable:
```
function createA(status)
    local o = {}
    o.status = status
    o.method = function(self) print self.status end
    return o
end

t1 = createA(100)
t2 = createA(101)
```

## Inheritance ##
"But what about inheritance?" Again, let's first make the concept clear: what's inheritance? In concept, it means some relationship among classes: class A inheriting class B usually means A has something in common with B, and thus objects of class A behave much like those of class B. In implementation, it usually means some code organization.

Having that in mind, we can say t3 in the following code has a conceptual class which inherits t2's:
```
t3 = {}                                           
t3.status = 10000                                 
t3.method = function(self) print self.status end  
t3.anotherStatus = 'hello'
t3.anotherMethod = function(self, n) self.status = self.status + n end
```

We can make the code reusable as:
```
function createB(status, anotherStatus)
    local o = createA(status)
    o.anotherStatus = anotherStatus
    o.anotherMethod = function(self, n) self.status = self.status + n end
    return o
end
t3 = createB(10000, 'hello')
```

That's most of the story about OOP in Lua. Not so appealing? I know you want more. See the next!

# Lua Class Lib #
"But I want a more good-looking way for OOP in Lua, such as XXX language, it's more friendly." I heard your complains, and I guess your XXX language usually refers to such as C++, C#, Java, or Python, etc. OK, Lua Class lib comes to your rescue!

## First Look ##
Here is a first look:
```
require 'cls'   --import Lua Class Lib

class 'Person'  --define a Class
{
    __init__ = function(self, name) --define an instance initializer
        self.name = name
    end;

    say = function(self)            --define a method
        print('Hello, my name is ' .. self.name .. '.')
        self:saySthElse()
    end;

    saySthElse = function(self)
    end
}
p = Person('Bob')  --create an object
p:say()            --call its method
```

Output:
```
Hello, my name is Bob.
```

Class inheritance:
```
class 'Employee: Person'  --define a class inheriting class Person defined as above
{
    __init__ = function(self, name, salary, id)
        Person.__init__(self, name)  --call base class's method directly
        self.salary = salary
    end;

    saySthElse = function(self)      --override base class's method
        print('My salary is ' .. self.salary .. '.')
    end
}

e = Employee('Bob', 1000)
e:say()
```

Output:
```
Hello, my name is Bob.
My salary is 1000.
```

Even multiple inheritance:
```
class 'A' {...}
class 'B' {...}
class 'C: A, B' {...}
c = C()
assert(isInstanceOf(c, A))
assert(isInstanceOf(c, B))
assert(isInstanceOf(c, C))
```

The _class_ in above code is really a user defined function to do all the magic, and it's not a keyword in the language! Really cool, isn't it? Thanks to the power of the Lua language, it's not too hard to achieve this. (For details of the _class_ function and other APIs see http://code.google.com/p/lua-class-lib/wiki/APIReference)

I guess you're eager to know how, but before we move on, I suggest you download the lib and have a look at its source. Believe it or not: it's surprisingly short(no more than 100 lines totally, including comments and empty lines)! Let's say it again: Lua is cool!

## Design and Implementation ##
Lua doesn't provide a class keyword and something alike as in other OO languages do, but Lua grants you much power to shape your own OO system. The Lua Class Lib is just an example on how you can shape it. And it's also supposed to give you an idea about how you can use the powerful language.

The lib is inspired by and modeled on Python OOP(Although the two languages are quite different, it doesn't matter when we come to the essence of OOP). The general design principles are:
  * A class is a table of attributes and methods, which is shared by all its instances, as well as derived classes.
  * An instance is a table of attributes and methods, with access to its class's members.
  * When referencing a member of an instance, the member is first looked up in the instance, then its class, and the first find is returned.
  * When assigning to a member of an instance, the member is always stored in the instance.
  * The class definition and instantiation 'grammar' should be intuitive and simple.
  * Keep all simple.

Here is the code behind the scenes:
```
local function parseName(str)
    local _begin, _end, cls = assert(str:find('%s*([a-zA-Z][a-zA-Z0-9_]*)%s*%:?'))
    if not str:find(':', _end) then
        return cls, {}
    end
    local bases = {}
    while true do
        local base
        _begin, _end, base = str:find('%s*([a-zA-Z][a-zA-Z0-9_]*)%s*%,?', _end + 1)
        if base then
            table.insert(bases, base)
        else
            break
        end
    end
    return cls, bases
end

local function create(t, ...)
    local o = {}
    if t.__init__ then
        t.__init__(o, ...)
    end
    return setmetatable(o, {__index = t, __class__ = t})
end

function class(name)
    local env = getfenv(2)
    local clsName, bases = parseName(name)
    for i, v in ipairs(bases) do
        bases[i] = env[v]   --Replace string name with class table
    end

    return function (t)
        local meta = {__call = create, __bases__ = bases}
        meta.__index = function(nouse, key)
            for _, cls in ipairs(meta.__bases__) do
                local val = cls[key]    --Do a recursive search on each cls
                if val ~= nil then
                    return val
                end
            end
        end
        env[clsName] = setmetatable(t, meta)
    end
end
```

The code is short, but delicate, deserving a good read.

Note that it just demonstrates a minimal(possibly adequate) OO system's implementation, and there's always room to improve and extend. However, before you extend it, ask yourself "Do I really require that extension?" and "Will the extension make the whole system too complicated?" Have fun!

Sorry I can't say more, for the reason of time. But after all, the code itself speaks.