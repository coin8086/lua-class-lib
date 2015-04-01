# Index #


# class #
**Type**
> function

**Summary**
> Define a class in the environment of the calling function.

**Examples**
> 
```
class 'myclass1' ...
class 'myclass2: parent1, parent2' ...
```

**Parameters**
  * A single string containing a name list

> To define a class without a parent, put a single class name in the list, like
```
'myclass'
```

> To inherit from other classes, list these classes' names after a '**:**' following the class name, separated by '**,**', like
```
'subclass: parent1, parent2'
```
> Spaces before/after ':' and ',' will be trimed.

> _Note: The base classes **must** be 'visible' at the point that a subclass is defining, or an exception will be raised._

> A valid class name starts with a letter followed by zero or more characters of letter, number and underscore '`_`'. It has the following pattern
```
'[a-zA-Z][a-zA-Z0-9_]*'
```
> An exception will be raised if an invalid name is used.

**Return**
  * A [Class Closure](APIReference#Class_Closure.md)

> In fact, calling _class_ doesn't really define a class, but only do halfway by returning a closure. The closure takes a single table argument, which is the class definition body, and defines a [Class Object](APIReference#Class_Object.md) finally. See [Class Closure](APIReference#Class_Closure.md) for details.


# _Class Closure_ #
**Type**
> closure

**Summary**
> A halfway class definition closure, returned by a _[class](APIReference#class.md)_ call. It takes a single table argument as a class definition body, and defines a [Class Object](APIReference#Class_Object.md) in the environment of the previous _[class](APIReference#class.md)_ call. The [Class Object](APIReference#Class_Object.md) is also returned.

**Examples**
> 
```
class 'MyClass1' 
{
    __init__ = function(self, x, y, z)  --initializer 
        self.x = x
        --...
    end;

    foo = function(self)  --method
        --...
    end;

    --...
}
--At this point a Class Object, MyClass1, has been defined 
--in the environment of the function calling "class 'MyClass1'"
```

> class 'MyClass1' returns a Class Closure, which takes a following table as an argument and defines a [Class Object](APIReference#Class_Object.md) bound to variable MyClass1 in the environment of the function that calls _[class](APIReference#class.md)_.

**Parameters**
  * A single table as a class definition body

> Class members, such as initializer and methods, as well as attributes, go in the table.

**Return**
  * A [Class Object](APIReference#Class_Object.md)

# _Class Object_ #

**Type**
> table

**Summary**
> A table defined by a [Class Closure](APIReference#Class_Closure.md) call. In fact, it's exactly the same table that is passed as an argument to the [Class Closure](APIReference#Class_Closure.md) call, but with a metatable set by Lua Class lib, which makes it be able to be called as a constructor to create new objects of the class.

**Examples**
> 
```
class 'MyClass1' 
{
    __init__ = function(self, x, y)  --initializer 
        self.x = x
        self.y = y
    end;

    --...
}
--At this point a Class Object, MyClass1, has been defined.

obj = MyClass1(1, 2)
assert(type(MyClass1) == 'table')
assert(type(MyClass1.__init__) == 'function')
```

**Parameters**
> When called as a constructor, a Class Object internally calls the `__init__` function defined by user, passing a class instance as the first argument along with all arguments passed to it, and returns a new instance. If no `__init__` is defined, it ignores any arguments and just returns a new instance.

**Return**
> A class instance


# isInstanceOf #

**Type**
> function

**Summary**
> Determine whether an object is an instance of a class or a derived one of that class.

**Examples**
> 
```
class 'A' ...
class 'B: A' ...
a = A()
b = B()
assert(isInstanceOf(a, A))
assert(isInstanceOf(b, A))
assert(!isInstanceOf(a, B))
```

**Parameters**
  * an instance
  * a [Class Object](APIReference#Class_Object.md)

> An exception will be raised when an instance or [Class Object](APIReference#Class_Object.md) argument is invalid.

**Return**
  * true or false

# getClass #

**Type**
> function

**Summary**
> Get the [Class Object](APIReference#Class_Object.md) of an instance.

**Examples**
> 
```
class 'A' ...
o = A()
C = getClass(o)
assert(C == A)
```

**Parameters**
  * an instance

**Return**
  * The [Class Object](APIReference#Class_Object.md) of an instance

# getBaseClasses #

**Type**
> function

**Summary**
> Get the base classes's [Class Object](APIReference#Class_Object.md) of a subclass.

**Examples**
> 
```
class 'A' ...
class 'B' ...
class 'C: A, B' ...
bases = getBaseClasses(C)
assert(bases[1] == A)
assert(bases[2] == B)
assert(#bases == 2)
```

**Parameters**
  * a [Class Object](APIReference#Class_Object.md)

**Return**
  * An array of base classes's [Class Object](APIReference#Class_Object.md), in the order that they're inherited in a subclass. It's empty when a class has no base class.