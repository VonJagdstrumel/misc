<?php

/*
 * Enum structure emulation
 * Prefer the use of http://fr2.php.net/manual/en/class.splenum.php
 */

abstract class Enum
{
    protected $value = null;

    public function getValue()
    {
        if (is_null($this->value)) {
            throw new Exception('Enum value not set');
        }

        return $this->value;
    }

    public function setValue($value)
    {
        $reflection = new ReflectionClass(get_called_class());
        $constList = array_values($reflection->getConstants());

        if (!in_array($value, $constList)) {
            throw new Exception('Trying to set an invalid enum value');
        }

        $this->value = $value;
    }
}

class EnumTest extends Enum
{
    const ZERO = 0;
    const ONE = 1;
    const TWO = 2;
    const THREE = 3;

}

$enum = new EnumTest();

try {
    var_dump($enum->getValue()); // Will throw an exception
} catch (Exception $e) {
    echo $e->getMessage() . PHP_EOL;
}

$enum->setValue(EnumTest::TWO);
var_dump($enum->getValue());

try {
    $enum->setValue(42); // Will throw an exception
} catch (Exception $e) {
    echo $e->getMessage() . PHP_EOL;
}

var_dump($enum->getValue());
