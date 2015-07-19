<?php

/*
 * Enum structure emulation
 * Prefer the use of http://fr2.php.net/manual/en/class.splenum.php
 */

abstract class Enum
{
    protected $value;

    /**
     *
     * @return mixed
     */
    function __toString()
    {
        return $this->value;
    }

    /**
     *
     * @param mixed $value
     * @throws \UnexpectedValueException
     */
    function __construct($value)
    {
        $reflection = new \ReflectionClass(get_called_class());
        $constList = array_values($reflection->getConstants());

        if (!in_array($value, $constList)) {
            throw new \UnexpectedValueException('Trying to set an invalid enum value');
        }

        $this->value = $value;
    }
}
