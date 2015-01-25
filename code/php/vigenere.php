<?php

/*
 * Apply a Vigenere rotation on a string using a given key
 */

class Vigenere
{
    const ROT_WAY_ENCODE = false;
    const ROT_WAY_DECODE = true;

    protected $key;

    /**
     *
     * @param string $key
     */
    public function __construct($key)
    {
        $this->key = $key;
    }

    /**
     *
     * @param string $rawString
     * @param boolean $way
     * @return string
     * @throws RuntimeException
     */
    protected function transform($rawString, $way)
    {
        $res = '';
        $string = preg_replace('/[^\x20-\x7D]/', '', $rawString);
        $stringLength = strlen($string);
        $keyLength = strlen($this->key);

        for ($i = 0; $i < $stringLength; ++$i) {
            $keyChar = $this->key[$i % $keyLength];

            switch ($way) {
                case self::ROT_WAY_DECODE:
                    $res .= chr((94 + ord($string[$i]) - ord($keyChar)) % 94 + 32);
                    break;
                case SELF::ROT_WAY_ENCODE:
                    $res .= chr((30 + ord($string[$i]) + ord($keyChar)) % 94 + 32);
                    break;
                default:
                    throw new RuntimeException('Invalid way of transformation');
            }
        }

        return $res;
    }

    /**
     *
     * @param string $string
     * @return string
     */
    public function encode($string)
    {
        return $this->transform($string, self::ROT_WAY_ENCODE);
    }

    /**
     *
     * @param string $string
     * @return string
     */
    public function decode($string)
    {
        return $this->transform($string, self::ROT_WAY_DECODE);
    }
}

$key = "I'VE GOT BALLS OF STEEL!";
$v = new Vigenere($key);

$msg = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}";
$encoded = $v->encode($msg);
$decoded = $v->decode($encoded);

var_dump($msg);
var_dump($encoded);
var_dump($decoded);

$msg = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
$encoded = $v->encode($msg);
$decoded = $v->decode($encoded);

var_dump($msg);
var_dump($encoded);
var_dump($decoded);
