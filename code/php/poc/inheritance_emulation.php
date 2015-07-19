<?php

/*
 * Inheritance by composition emulation
 * PHP >= 5.6
 */

class One
{
    public $bar;

    public static function staticFunction($arg)
    {
        var_dump("staticFunction: $arg");
    }

    public function instanceFunction($arg)
    {
        var_dump("instanceFunction: $arg");
    }
}

class Two
{
    public $instanceParentClass;
    public $foo;

    public function __call($name, $arguments)
    {
        $this->instanceParentClass->$name(...$arguments);
    }

    public static function __callStatic($name, $arguments)
    {
        One::$name(...$arguments);
    }

    public function __set($name, $value)
    {
        $this->instanceParentClass->$name = $value;
    }

    public function &__get($name)
    {
        return $this->instanceParentClass->$name;
    }

    public function __isset($name)
    {
        return isset($this->instanceParentClass->$name);
    }

    public function __unset($name)
    {
        unset($this->instanceParentClass->$name);
    }

    public function daFunction($arg)
    {
        var_dump("daFunction: $arg");
    }
}

// Notre objet vers lequel on va relayer les opérations
$instance = new One();

// Notre objet de relai
$o = new Two();
$o->instanceParentClass = $instance;

// On teste nos appels
$o->daFunction(79);
$o->instanceFunction(42);
Two::staticFunction(71);

// Et nos affectations
$o->foo = 16;
$o->bar = 27;
var_dump($o->foo);
var_dump($o->bar);

// On regarde ce qui se passe dans la bête
var_dump($o);
